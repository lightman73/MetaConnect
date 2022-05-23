//
//  ContentView.swift
//  MetaConnect
//
//  Created by Francesco Marini on 17/05/22.
//

import SwiftUI

struct ConnectionView: View {
    @StateObject var viewModel = ConnectionViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    
    let metamaskImage = "metamask-fox"
    
    var body: some View {
        ZStack {
            if !viewModel.isConnected {
                Button {
                    viewModel.connect()
                } label: {
                    MMButton(title: "Connect", image: metamaskImage)
                }
            } else {
                VStack(alignment: .center) {
                    HStack(spacing: 5) {
                        Text("Connected to MetaMask")
                            .font(.title2)
                            .foregroundColor(.brandPrimary)
                        Image(metamaskImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .padding([.trailing], 15)
                            .padding([.vertical], -10)
                    }
                    .padding([.top], 30)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Message to sign:")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.brandPrimary)
                            .padding([.leading], 1)
                        
                        TextField("Message to sign", text: $viewModel.messageToSign)
                            .foregroundColor(.brandPrimary)
                            .textFieldStyle(.roundedBorder)
                            .background(.clear)
                    }
                    .padding([.horizontal, .bottom], 20)
                    
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
                        viewModel.ethSignMessage()
                    } label: {
                        Label("Eth sign message", systemImage: "signature")
                    }
                    .tint(.brandPrimary)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 1000))
                    .controlSize(.regular)
                    .padding([.bottom], 30)
                    
                    Button {
                        viewModel.ethSendTransaction()
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
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
            
            if viewModel.alertItem != nil {
                MCAlertView(alertItem: $viewModel.alertItem)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .brandPrimary.opacity(colorScheme == .light ? 0.1 : 0.7), location: 0),
                .init(color: .clear, location: colorScheme == .light ? 0.7 : 2)]),
            startPoint: .top,
            endPoint: .bottom))
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
            .preferredColorScheme(.dark)
    }
}
