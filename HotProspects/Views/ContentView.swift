//
//  ContentView.swift
//  HotProspects
//
//  Created by Nate Lee on 8/11/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

enum NetworkError: Error {
    case badURL, requestFailed, unknown
    case dataIsNil
}


struct ContentView: View {
    @State private var text = "Hello, World!"
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                Text(self.text)
                    .onAppear {
                        self.fetchData(from: "https://www.apple.com") { (result) in
                            switch result {
                            case .failure(let error):
                                self.text = error.localizedDescription
                                
                            case .success(let resultString):
                                self.text = resultString
                                
                            }
                        }
                }
                .frame(width: geo.size.width * 0.9)
            }
        }
    }
    
    // Custom funcs
    func fetchData(from urlString: String, handler completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(Result.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(Result.failure(.requestFailed))
                    return
                }
                guard let data = data else {
                    completion(Result.failure(.dataIsNil))
                    return
                }
                // Otherwise, all is well
                // Decode first
                let stringData = String(decoding: data, as: UTF8.self)
                completion(Result.success(stringData))
            }
        }.resume()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
