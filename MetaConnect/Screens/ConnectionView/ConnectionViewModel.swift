//
//  ConnectionViewModel.swift
//  MetaConnect
//
//  Created by Francesco Marini on 17/05/22.
//

import SwiftUI

@MainActor
final class ConnectionViewModel: ObservableObject {
    @Environment(\.openURL) var openURL
    
    // - Might collapse isLoading and isConnected to a single enum
    @Published var isLoading: Bool = false
    @Published var isConnected: Bool = false
    @Published var alertItem: MCAlertItem?
    @Published var messageToSign: String = "Hello there"
    
    init() {
        WalletConnectManager.shared.delegate = self
    }
    
    func connect() {
        isLoading = true
        
        WalletConnectManager.shared.connect()
    }
    
    func disconnect() {
        isLoading = true
        
        WalletConnectManager.shared.disconnect()
    }
    
    func personalSignMessage() {
        WalletConnectManager.shared.personalSign(messageToSign)
        
        openMetaMask()
    }
    
    func ethSignMessage() {
        WalletConnectManager.shared.ethSign(messageToSign)
        
        openMetaMask()
    }
    
    func ethSendTransaction() {
        WalletConnectManager.shared.ethSendTransaction()
        
        openMetaMask()
    }
    
    private func openMetaMask() {
        // Should use universal link to open MetaMask, maybe
        let wcLinkUrl = "wc://wc"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            guard let url = URL(string: wcLinkUrl) else {
                return
            }
            
            self.openURL(url)
        }
    }
}


extension ConnectionViewModel: WalletConnectManagerDelegate {
    func failedToOpenMetaMask() {
        print("Failed to open MetaMask App")
        
        Task {
            self.isLoading = false
            self.isConnected = false
            
            // TODO: Should open modal with QR code
            self.alertItem = WCAlertContext.connectionFailed
        }
    }
    
    func failedToConnect() {
        print("Failed to connect")
        
        Task {
            self.isLoading = false
            self.isConnected = false
            self.alertItem = WCAlertContext.connectionFailed
        }
    }
    
    func didConnect() {
        print("Did connect")
        
        Task {
            isLoading = false
            isConnected = true
            alertItem = WCAlertContext.connectionSuccess
        }
    }
    
    func didDisconnect() {
        print("Did disconnect")
        
        Task {
            self.isLoading = false
            self.isConnected = false
            self.alertItem = WCAlertContext.disconnected
        }
    }
    
    func didReceiveResponse(title: String, message: String) {
        print("Did receive response")
        
        Task {
            self.alertItem = MCAlertItem(isOk: true, title: title, message: message, buttonText: "Ok")
        }
    }
    
    func didReceiveError(message: String) {
        print("Did receive error")
        
        Task {
            self.alertItem = MCAlertItem(isOk: false, title: "Error", message: message, buttonText: "Ok")
        }
    }
    
    
}
