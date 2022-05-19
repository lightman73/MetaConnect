//
//  WCAlertView.swift
//  WalletConnectTest
//
//  Created by Francesco Marini on 17/05/22.
//

// TODO: Should add a thin white border when in dark mode.

import SwiftUI

struct WCAlertView: View {
    @Binding var alertItem: WCAlertItem?
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if alertItem!.isOk {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .symbolVariant(.circle)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.brandPrimary,
                                         .green)
                    /// There seems to be an issue with SFSymbols rendered with
                    ///  palette mode, and using a gradient for one of the colors:
                    ///  the part rendered with gradient gets rendered, and after
                    ///  maybe a tenth of a second, it disappears (or it's re-rendered
                    ///  with the background color). Damn.
//                                         LinearGradient(
//                            gradient: Gradient(stops: [
//                                .init(color: .green, location: 0.25),
//                                .init(color: .white.opacity(0.9), location: 1.0)]),
//                            startPoint: .top,
//                            endPoint: .bottomTrailing))
                        .padding()
                } else {
                    Image(systemName: "exclamationmark")
                        .font(.title2)
                        .symbolVariant(.circle)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.brandPrimary,
                                         .red)
//                    LinearGradient(
//                            gradient: Gradient(stops: [
//                                .init(color: .red, location: 0.25),
//                                .init(color: .white.opacity(0.9), location: 1.0)]),
//                            startPoint: .top,
//                            endPoint: .bottomTrailing))
                        .padding()
                }
                    
                
                Text(alertItem!.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.brandPrimary)
                
                Spacer()
            }
            .padding()
            
            Text(alertItem!.message)
                .font(.headline)
                .padding([.vertical])
                .padding([.horizontal], 10)
            
            Rectangle()
                .frame(width: 300, height: 0.5, alignment: .center)
                .padding([.top])
            
            Button {
                alertItem = nil
            } label: {
                MMButton(title: alertItem!.buttonText)
            }
            .padding([.vertical], 10)
        }
        .frame(width: 300)
        .background(LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .brandPrimary, location: colorScheme == .light ? -7 : -1.5),
                .init(color: Color(.systemBackground), location: colorScheme == .light ? 0.7 : 3)]),
            startPoint: .top,
            endPoint: .bottom))
        .cornerRadius(20)
        .shadow(radius: 40)
    }
}

struct WCAlertView_Previews: PreviewProvider {
    static var previews: some View {
        WCAlertView(alertItem: .constant(WCAlertItem(isOk: true, title: "A really long test title", message: "A really, really, really, long test message", buttonText: "Ok"))) //, isShowing: .constant(true))
    }
}

