//
//  Alert.swift
//  WalletConnectTest
//
//  Created by Francesco Marini on 17/05/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    // - WalletConnect Alerts
    static let connectionFailed = AlertItem(title: Text("Connection Failed"),
                                                 message: Text("Couldn't connect to MetaMask wallet. Please try again"),
                                                 dismissButton: .default(Text("Ok")))
    static let disconnected = AlertItem(title: Text("Disconnected"),
                                                 message: Text("Disconnected from MetaMask wallet."),
                                                 dismissButton: .default(Text("Ok")))
    
    static let connectionSuccess = AlertItem(title: Text("Connected to Wallet"),
                                            message: Text("You are now connected to your MetaMask wallet"),
                                            dismissButton: .default(Text("Ok")))
}
