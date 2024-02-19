//
//  SampleView.swift
//  AppStoreMockInterview
//
//  Created by Brian Voong on 2/3/24.
//

import SwiftUI
import Observation

@MainActor
class SampleViewModel: ObservableObject {
    @Published var count = 0
    @Published var foo = "BAR"
    
    func increaseOnBackgroundThread() {
        Task {
            count += 5
        }
    }
}

@Observable
class ObservableSampleViewModel {
    var count = 0
    
    func increaseOnBackgroundThread() {
        Task {
            count += 5
        }
    }
}

struct SampleView: View {
    
//    @StateObject var vm = SampleViewModel()
    @State var vm = ObservableSampleViewModel()
    
    var body: some View {
        Button {
//            vm.count += 1
            vm.increaseOnBackgroundThread()
        } label: {
            Text("Increase by 1: \(vm.count)")
                .font(.largeTitle)
        }

    }
}

#Preview {
    SampleView()
}
