//
//  AppDetailView.swift
//  AppStoreMockInterview
//
//  Created by Brian Voong on 12/25/23.
//

import SwiftUI

struct AppDetailResults: Codable {
    let resultCount: Int
    let results: [AppDetail]
}

struct AppDetail: Codable {
    let artistName: String
    let trackName: String
    let releaseNotes: String
    let description: String
    let screenshotUrls: [String]
    let artworkUrl512: String
}

@MainActor
class AppDetailViewModel: ObservableObject {
    
    @Published var appDetail: AppDetail?
    
    private let trackId: Int
    init(trackId: Int) {
        // fetch JSON Data
        //
        self.trackId = trackId
        print("Fetch JSON data for app detail")
        fetchJSONData()
    }
    
    private func fetchJSONData() {
        Task {
            do {
                guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(trackId)") else { return }
                let (data, _) = try await URLSession.shared.data(from: url)
//                print(String(data: data, encoding: .utf8))
                
                let appDetailResults = try JSONDecoder().decode(AppDetailResults.self, from: data)
                appDetailResults.results.forEach { appDetail in
                    print(appDetail.description)
                }
                
                self.appDetail = appDetailResults.results.first
                
            } catch {
                print("Failed fetching app detail:", error)
            }
            
        }
        
    }
    
}

struct AppDetailView: View {
    
    @StateObject var vm: AppDetailViewModel
    
    init(trackId: Int) {
        self._vm = .init(wrappedValue: AppDetailViewModel(trackId: trackId))
        self.trackId = trackId
    }
    
    let trackId: Int
    
    var body: some View {
        ScrollView {
            if let appDetail = vm.appDetail {
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: appDetail.artworkUrl512)) { image in
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .scaledToFill()
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 100, height: 100)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(appDetail.trackName)
                            .font(.system(size: 24, weight: .semibold))
                        Text(appDetail.artistName)
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.system(size: 24))
                            .padding(.vertical, 4)
                    }
                    
                    Spacer()
                }
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("What's New")
                            .font(.system(size: 24, weight: .semibold))
                            .padding(.vertical)
                        Spacer()
                        Button(action: {}, label: {
                            Text("Version History")
                        })
                    }
                    
                    Text(appDetail.releaseNotes)
                }
                .padding(.horizontal)
                
                previewScreenshots
                
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.vertical)
                    
                    Text(appDetail.description)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @State var isPresentingFullScreenScreenshots = false
    
    private var previewScreenshots: some View {
        VStack {
            Text("Preview")
                .font(.system(size: 24, weight: .semibold))
                .padding(.vertical)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(vm.appDetail?.screenshotUrls ?? [], id: \.self) { screenshotUrl in
                        Button(action: {
                            isPresentingFullScreenScreenshots.toggle()
                        }, label: {
                            AsyncImage(url: URL(string: screenshotUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 350)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 200, height: 350)
                                    .foregroundStyle(Color(.label))
                            }
                        })
                    }
                }
                .padding(.horizontal)
            }
        }
        .fullScreenCover(isPresented: $isPresentingFullScreenScreenshots, content: {
            FullScreenScreenshotsView(screenshotUrls: vm.appDetail?.screenshotUrls ?? [])
        })
    }
}

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
                            .font(.system(size: 24, weight: .semibold))
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
                }
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        AppDetailView(trackId: 547702041)
    }
    .preferredColorScheme(.dark)
}
