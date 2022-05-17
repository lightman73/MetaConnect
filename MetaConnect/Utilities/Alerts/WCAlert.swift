//
//  WCAlert.swift
//  WalletConnectTest
//
//  Created by Francesco Marini on 17/05/22.
//


struct WCAlertItem {
    let isOk: Bool
    let title: String
    let message: String
    let buttonText: String
}

struct WCAlertContext {
    // - WalletConnect Alerts
    static let connectionFailed = WCAlertItem(isOk: false,
                                              title: "Connection Failed",
                                                 message: "Couldn't connect to MetaMask wallet. Please try again",
                                                 buttonText: "Ok")
    static let disconnected = WCAlertItem(isOk: true,
                                        title: "Disconnected",
                                                 message: "Disconnected from MetaMask wallet.",
                                                 buttonText: "Ok")
    
    static let connectionSuccess = WCAlertItem(isOk: true,
                                               title: "Connected to Wallet",
                                            message: "You are now connected to your MetaMask wallet",
                                            buttonText: "Ok")
}
