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
    
    var body: some View {
        HStack(spacing: 25) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding([.leading], image == nil ? 0 : 20)
                .padding([.horizontal], image == nil ? 20 : 0)
            if let image = image {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .padding([.trailing], 15)
                    .padding([.vertical], -10)
            }
        }
        .padding([.leading, .trailing], 40)
        .padding([.top, .bottom], 12)
        .foregroundColor(.white)
        .background(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .brandPrimary, location: 0),
                    .init(color: .brandPrimary, location: 0.25),
                    .init(color: .white.opacity(0.9), location: 1.0)]),
                startPoint: .top,
                endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 1000, style: .continuous))
    }
}

struct MMButton_Previews: PreviewProvider {
    static var previews: some View {
        MMButton(title: "Test text", image: "metamask-fox")
    }
}
