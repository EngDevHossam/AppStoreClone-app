//
//  FullScreenScreenshotsView.swift
//  AppStoreMockInterview
//
//  Created by Brian Voong on 12/26/23.
//

import SwiftUI

struct FullScreenScreenshotsView: View {
    @Environment(\.dismiss) var dismiss
    let screenshotUrls: [String]
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color(.label))
                            .font(.system(size: 28, weight: .semibold))
                    })
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(screenshotUrls, id: \.self) { screenshotUrl in
                            let width = proxy.size.width - 64
                            AsyncImage(url: URL(string: screenshotUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 550)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: width, height: 550)
                                    .foregroundStyle(Color(.label))
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
            }
        }
        
    }
}

#Preview {
    FullScreenScreenshotsView(screenshotUrls: [
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/6a/85/06/6a850670-9d47-d5b6-70a3-a137cd563fcd/6b40a3a8-547c-4a7b-bf69-891081b0536a_1.png/392x696bb.png",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/78/eb/60/78eb60db-9b71-22f2-e01c-9cb8ebcd6e3f/ec35c974-525e-42b0-a26a-c025bdba75eb_2.png/392x696bb.png",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/4f/e4/d6/4fe4d605-2b52-0d47-8134-632c0c3cbd03/9cc929db-b731-4415-9141-b3f68bfd99d2_3.png/392x696bb.png",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/8f/fb/8c/8ffb8c5c-a8bc-bd96-887f-9728e993eab6/9d98f0fa-8245-4e1e-95e2-50ca4258a087_4.png/392x696bb.png",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/9f/15/7d/9f157d43-f876-ddc6-e91e-e9c6b3c51684/c895de96-2174-4998-9629-81f4c4caf70a_5.png/392x696bb.png",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/db/e7/99/dbe7999b-d6b9-b1bd-9373-13a3418e3254/6811408a-0fb7-4a59-9a77-47d16bf42153_6.jpg/392x696bb.jpg",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/e8/0a/e1/e80ae1ca-b733-c662-bfd8-d697d15608b8/1f257b15-19d4-4cb6-aa63-5721312b3626_7.png/392x696bb.png"
      ])
}
