//
//  ConnectionViewModel.swift
//  WalletConnectTest
//
//  Created by Francesco Marini on 17/05/22.
//

import SwiftUI

@MainActor
final class ConnectionViewModel: ObservableObject {
    // - Might collapse isLoading and isConnected to a single enum
    @Published var isLoading: Bool = false
    @Published var isConnected: Bool = false
    @Published var alertItem: WCAlertItem?
    
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
        WalletConnectManager.shared.personalSign()
    }
    
    func eth_sendTransaction() {
        WalletConnectManager.shared.ethSendTransaction()
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
            self.alertItem = WCAlertItem(isOk: true, title: title, message: message, buttonText: "Ok")
        }
    }
    
    func didReceiveError(message: String) {
        print("Did receive error")
        
        Task {
            self.alertItem = WCAlertItem(isOk: false, title: "Error", message: message, buttonText: "Ok")
        }
    }
    
    
}
