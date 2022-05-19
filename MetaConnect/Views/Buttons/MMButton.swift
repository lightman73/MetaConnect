//
//  MMButton.swift
//  WalletConnectTest
//
//  Created by Francesco Marini on 17/05/22.
//

import SwiftUI

struct MMButton: View {
    var title: String
    var image: String? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 25) {
            Text(title)
                .font(.headline)
                .foregroundColor(.brandSecondary)
                .padding([.leading], image == nil ? 0 : 20)
                .padding([.horizontal], image == nil ? 20 : 0)
            if let image = image {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .padding([.trailing], 15)
                    .padding([.vertical], -10)
            }
        }
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 8)
        .foregroundColor(.white)
        .background(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .white.opacity(0.9), location: colorScheme == .light ? -1.25 : 0),
                    .init(color: .brandPrimary, location: 0.75),
                    .init(color: .brandPrimary, location: 1)]),
                startPoint: .topLeading,
                endPoint: .bottom)
        )
        .clipShape(RoundedRectangle(cornerRadius: 1000, style: .continuous))
        .shadow(radius:2, x:2, y:2)
    }
}

struct MMButton_Previews: PreviewProvider {
    static var previews: some View {
        MMButton(title: "Test text", image: "metamask-fox")
            
            
    }
}
