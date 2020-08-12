//
//  ContentView.swift
//  HotProspects
//
//  Created by Nate Lee on 8/11/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    @State private var backgroundColor = Color.red
    
    var body: some View {
        VStack {
            Text("Placeholder")
                .padding()
                .layoutPriority(1)
                .padding()
                .background(backgroundColor)
            
            Text("3D Touch Me")
                .padding()
                .contextMenu(ContextMenu(menuItems: {
                    Button(action: {
                        self.backgroundColor = .red
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                        Text("Red")
                    }
                    
                    Button(action: {
                        self.backgroundColor = .blue
                    }) {
                        Text("Blue")
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        self.backgroundColor = .yellow
                    }) {
                        Text("Yellow")
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.yellow)
                    }
                    
                }))
        }
    }
    
    // Custom funcs
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
