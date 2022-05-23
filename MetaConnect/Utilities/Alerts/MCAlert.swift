//
//  MCAlert.swift
//  MetaConnect
//
//  Created by Francesco Marini on 17/05/22.
//


struct MCAlertItem {
    let isOk: Bool
    let title: String
    let message: String
    let buttonText: String
}

struct WCAlertContext {
    // - WalletConnect Alerts
    static let connectionFailed = MCAlertItem(isOk: false,
                                              title: "Connection failed",
                                              message: "Couldn't connect to MetaMask wallet. Please try again",
                                              buttonText: "Ok")
    static let disconnected = MCAlertItem(isOk: true,
                                          title: "Disconnected",
                                          message: "Disconnected from MetaMask wallet.",
                                          buttonText: "Ok")
    
    static let connectionSuccess = MCAlertItem(isOk: true,
                                               title: "Connected to Wallet",
                                               message: "You are now connected to your MetaMask wallet",
                                               buttonText: "Ok")
    
    static let checkMetaMaskAndAuthorize = MCAlertItem(isOk: true,
                                                       title: "Confirmation needed",
                                                       message: "Please open MetaMask and follow the instructions",
                                                       buttonText: "Ok")
}
