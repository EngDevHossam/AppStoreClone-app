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

@Observable
class AppDetailViewModel {
    
    var appDetail: AppDetail?
    var error: Error?
    
    private let trackId: Int
    init(trackId: Int) {
        self.trackId = trackId
        fetchJSONData()
    }
    
    private func fetchJSONData() {
        Task {
            do {
                self.appDetail = try await APIService.fetchAppDetail(trackId: trackId)
            } catch {
                self.error = error
            }
        }
    }
    
}

struct AppDetailView: View {
    
    @State var vm: AppDetailViewModel
    
    init(trackId: Int) {
        self._vm = .init(wrappedValue: AppDetailViewModel(trackId: trackId))
        self.trackId = trackId
    }
    
    let trackId: Int
    
    var body: some View {
        GeometryReader { proxy in
            if let _ = vm.error {
                Text("Failed to fetch app details")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .font(.largeTitle)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            
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
                        Text("Reviews")
                            .font(.system(size: 24, weight: .semibold))
                            .padding(.vertical)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    ReviewsView(trackId: self.trackId, proxy: proxy)
                    
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.system(size: 24, weight: .semibold))
                            .padding(.vertical)
                        
                        Text(appDetail.description)
                    }
                    .padding(.horizontal)
                }
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

#Preview {
    NavigationStack {
        AppDetailView(trackId: 547702041)
    }
//    SearchView()
    .preferredColorScheme(.dark)
}
