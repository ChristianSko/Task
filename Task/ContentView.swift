//
//  ContentView.swift
//  Task
//
//  Created by Christian Skorobogatow on 27/7/22.
//

import SwiftUI


class TaskViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
        do {
            
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            
            await MainActor.run(body: {
                self.image  = UIImage(data: data)
                print("IMAGE RETURNED SUCESSFULLY")
            })
            
            
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchImage2() async {
        do {
            
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
            })
            
            
        } catch  {
            print(error.localizedDescription)
        }
        
    }
}


struct TaskHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME!") {
                    ContentView()
                }
            }
        }
    }
}

struct ContentView: View {
    
    @StateObject var viewModel = TaskViewModel()
    
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }

        }
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear{
//            fetchImageTask = Task {
//                try? await Task.sleep(nanoseconds: 5000000000)
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage()
//            }

//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
            
//            Task(priority: .high) {
//                try? await Task.sleep(nanoseconds:2_000_000_000)
//
//                await Task.yield( )
//                print("HIGH: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                print("userInitiated: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("MEDIUM: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print("LOW: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("utility: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .background) {
//                print("background: \(Thread.current) : \(Task.currentPriority)")
//            }
            
//            Task(priority: .userInitiated) {
//                print("userInitiated: \(Thread.current) : \(Task.currentPriority)")
//
//                Task.detached {
//                    print("detached: \(Thread.current) : \(Task.currentPriority)")
//                }
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
