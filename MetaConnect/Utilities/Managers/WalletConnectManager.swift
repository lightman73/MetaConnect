//
//  WalletConnectManager.swift
//  MetaConnect
//
//  Created by Francesco Marini on 17/05/22.
//

import SwiftUI
import WalletConnectSwift
import CryptoSwift


protocol WalletConnectManagerDelegate {
    func failedToOpenMetaMask()
    func failedToConnect()
    func didConnect()
    func didDisconnect()
    func didReceiveResponse(title: String, message: String)
    func didReceiveError(message: String)
}

final class WalletConnectManager {
    @Environment(\.openURL) var openURL
    
    static let shared = WalletConnectManager()
    var client: Client!
    var session: Session!
    var delegate: WalletConnectManagerDelegate?

    // gnosis wc bridge: https://safe-walletconnect.gnosis.io/
    // test bridge with latest protocol version: https://bridge.walletconnect.org
    var bridgeURL = "https://safe-walletconnect.gnosis.io/"

    var walletAccount: String {
        return session.walletInfo!.accounts[0]
    }
    
    let sessionKey = "sessionKey"
    
    
    init(delegate: WalletConnectManagerDelegate, bridgeURL: String?) {
        self.delegate = delegate
        
        guard let bridgeURL = bridgeURL else {
            return
        }

        self.bridgeURL = bridgeURL
    }
    
    private init() {}

    func connect() -> Void {
        // TODO: ^ Should be a rethrows, and should be handled
        
        let wcUrl =  WCURL(topic: UUID().uuidString,
                           bridgeURL: URL(string: bridgeURL)!,
                           key: try! randomKey())
        
        let clientMeta = Session.ClientMeta(name: "MetaConnect",
                                            description: "MetaConnect",
                                            icons: [],
                                            url: URL(string: "https://safe.gnosis.io")!)
        
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        
        client = Client(delegate: self, dAppInfo: dAppInfo)

        print("WalletConnect URL: \(wcUrl.absoluteString)")

        // shouldn't be a forced try
        try! client.connect(to: wcUrl)
        
        /// https://docs.walletconnect.org/mobile-linking#for-ios
        /// **NOTE**: Using URL scheme link. Might use a universal link, but it seems that MetaMask is having some problems atm
        ///  see: https://github.com/MetaMask/metamask-mobile/issues/3965
        let wcLinkUrl = "wc://wc?uri=\(wcUrl.absoluteString)"
        ///  let universalLinkUrl = "https://metamask.app.link/wc?uri=\(connectionUrl)"

        /// **NOTE**: Using SwiftUI openURL, in a UIKit app, might be better to use UIApplication.shared.canOpenURL/open
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let url = URL(string: wcLinkUrl) else {
                return
            }
            
            self.openURL(url) { success in
                if !success {
                    self.delegate?.failedToOpenMetaMask()
                }
            }
        }
    }
    
    func disconnect() {
        // TODO: ^ Should be a rethrows, and should be handled
        
        // shouldn't be a forced try
        try! client.disconnect(from: session)
    }
    
    
    func personalSign(_ messageToSign: String = "Hello there") {
        // TODO: ^ Should be a rethrows, and should be handled
        
        let fullMessage = "\u{19}Ethereum Signed Message:\n\(messageToSign.count)\(messageToSign)"
        let keccak256Hash = fullMessage.bytes.sha3(.keccak256).toHexString()
        
        print("personalSign, message: \(messageToSign)")
        print("Full message: \(fullMessage)")
        print("Keccak256: \(keccak256Hash)")
        print(messageToSign.bytes.sha3(.keccak256).toHexString())
        
        // shouldn't be a forced try
        try? client.personal_sign(url: session.url, message: messageToSign, account: session.walletInfo!.accounts[0]) {
            [weak self] response in
            self?.handleReponse(response, expecting: "Signature")
        }
    }
    
    func ethSign(_ messageToSign: String = "Hello there") {
        // TODO: ^ Should be a rethrows, and should be handled
        
        /// message should be the 32 bytes keccak256 hash for ethSign, so for "Hello there", it is "0x008cd552e9e10023c6fd4bb49b4f210ca2d89846d76efa98a8b4f87b9af72825"
        
        let keccak256Hash = messageToSign.bytes.sha3(.keccak256).toHexString()
        
        print("ethSign, message: \(messageToSign)")
        print("Keccak256: \(keccak256Hash)")
        
        // shouldn't be a forced try
        try? client.eth_sign(url: session.url, account: session.walletInfo!.accounts[0], message: "\(keccak256Hash)") {
            [weak self] response in
            self?.handleReponse(response, expecting: "Signature")
        }
    }
    
    func ethSendTransaction() {
        // example with two chained requests: 1) get nonce 2) sendTransaction
        try? client.send(nonceRequest()) { [weak self] response in
            guard let self = self, let nonce = self.nonce(from: response) else { return }
            let transaction = Stub.transaction(from: self.walletAccount, nonce: nonce)
            try? self.client.eth_sendTransaction(url: response.url, transaction: transaction) { [weak self] response in
                self?.handleReponse(response, expecting: "Hash")
            }
        }
    }
    
    func reconnectIfNeeded() {
        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client.reconnect(to: session)
        }
    }
    
    
    // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
    private func randomKey() throws -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            // we don't care in the example app
            enum TestError: Error {
                case unknown
            }
            throw TestError.unknown
        }
    }
    
    private func nonceRequest() -> Request {
        return .eth_getTransactionCount(url: session.url, account: session.walletInfo!.accounts[0])
    }
    
    private func nonce(from response: Response) -> String? {
        return try? response.result(as: String.self)
    }
    
    private func handleReponse(_ response: Response, expecting: String) {
        if let error = response.error {
            delegate?.didReceiveError(message: error.localizedDescription)
            return
        }
        
        do {
            let result = try response.result(as: String.self)
            delegate?.didReceiveResponse(title: expecting, message: result)
            
        } catch {
            delegate?.didReceiveError(message: "Unexpected response type error: \(error)")
        }
    }
}


// MARK: - ClientDelegate conformance
extension WalletConnectManager: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        delegate?.failedToConnect()
    }

    func client(_ client: Client, didConnect url: WCURL) {
        // do nothing
    }

    func client(_ client: Client, didConnect session: Session) {
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: sessionKey)
        delegate?.didConnect()
    }

    func client(_ client: Client, didDisconnect session: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        delegate?.didDisconnect()
    }

    func client(_ client: Client, didUpdate session: Session) {
        // do nothing
    }
}



// MARK: - Request (from WalletConnectSwift) extensions
extension Request {
    static func eth_getTransactionCount(url: WCURL, account: String) -> Request {
        return try! Request(url: url, method: "eth_getTransactionCount", params: [account, "latest"])
    }
}


// MARK: - Stub data for requests/transactions
fileprivate enum Stub {
    /// https://docs.walletconnect.org/json-rpc-api-methods/ethereum#example-parameters
    static let typedData = """
{
    "types": {
        "EIP712Domain": [
            {
                "name": "name",
                "type": "string"
            },
            {
                "name": "version",
                "type": "string"
            },
            {
                "name": "chainId",
                "type": "uint256"
            },
            {
                "name": "verifyingContract",
                "type": "address"
            }
        ],
        "Person": [
            {
                "name": "name",
                "type": "string"
            },
            {
                "name": "wallet",
                "type": "address"
            }
        ],
        "Mail": [
            {
                "name": "from",
                "type": "Person"
            },
            {
                "name": "to",
                "type": "Person"
            },
            {
                "name": "contents",
                "type": "string"
            }
        ]
    },
    "primaryType": "Mail",
    "domain": {
        "name": "Ether Mail",
        "version": "1",
        "chainId": 1,
        "verifyingContract": "0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"
    },
    "message": {
        "from": {
            "name": "Cow",
            "wallet": "0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826"
        },
        "to": {
            "name": "Bob",
            "wallet": "0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB"
        },
        "contents": "Hello, Bob!"
    }
}
"""

    /// https://docs.walletconnect.org/json-rpc-api-methods/ethereum#example-parameters-1
    static func transaction(from address: String, nonce: String) -> Client.Transaction {
        return Client.Transaction(from: address,
                                  to: "0xd46e8dd67c5d32be8058bb8eb970870f07244567",
                                  data: "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675",
                                  gas: "0x76c0", // 30400
                                  gasPrice: "0x9184e72a000", // 10000000000000
                                  value: "0x9184e72a", // 2441406250
                                  nonce: nonce,
                                  type: nil,
                                  accessList: nil,
                                  chainId: nil,
                                  maxPriorityFeePerGas: nil,
                                  maxFeePerGas: nil)
    }

    /// https://docs.walletconnect.org/json-rpc-api-methods/ethereum#example-5
    static let data = "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f07244567"

}

