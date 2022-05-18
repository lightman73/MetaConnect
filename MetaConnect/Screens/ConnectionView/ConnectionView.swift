//
//  ContentView.swift
//  WalletConnectTest
//
//  Created by Francesco Marini on 17/05/22.
//

import SwiftUI

struct ConnectionView: View {
    @StateObject var viewModel = ConnectionViewModel()
    
    var body: some View {
        ZStack {
            if !viewModel.isConnected {
                Button {
                    viewModel.connect()
                } label: {
                    MMButton(title: "Connect", image: "metamask-fox")
                }
            } else {
                VStack {
                    Text("Connected")
                        .font(.title2)
                        .foregroundColor(.brandPrimary)
                        .padding([.top], 20)
                    
                    Spacer()
                    
                    Button {
                        viewModel.personalSignMessage()
                    } label: {
                        Label("Personal sign message", systemImage: "signature")
                    }
                    .tint(.brandPrimary)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 1000))
                    .controlSize(.regular)
                    
                    Button {
                        viewModel.eth_sendTransaction()
                    } label: {
                        Label("Send transaction", systemImage: "paperplane")
                    }
                    .tint(.brandPrimary)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 1000))
                    .controlSize(.regular)
                    
                    Spacer()
                    
                    Button {
                        viewModel.disconnect()
                    } label: {
                        MMButton(title: "Disconnect")
                    }
                    .padding([.bottom], 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .blur(radius: viewModel.alertItem != nil ? 20 : 0)
                /// Overlay should be present only in dark mode.
//                .overlay {
//                    if viewModel.alertItem != nil {
//                        Rectangle()
//                            .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.7))
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    }
//                }
                
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
            
            if viewModel.alertItem != nil {
                WCAlertView(alertItem: $viewModel.alertItem)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .brandPrimary.opacity(0.1), location: 0),
                .init(color: .clear, location: 0.7)]),
            startPoint: .top,
            endPoint: .bottom))
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
            .preferredColorScheme(.light)
    }
}
