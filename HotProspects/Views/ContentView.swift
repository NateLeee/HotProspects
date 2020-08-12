//
//  ContentView.swift
//  HotProspects
//
//  Created by Nate Lee on 8/11/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

class DelayedUpdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
        didSet {
            if value >= 10 {
                value = 0
            }
        }
    }
    
    init() {
        for i in 0 ... 10 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var delayedUpdater = DelayedUpdater()
    
    var body: some View {
        Text("\(delayedUpdater.value)")
    }
    
    // Custom funcs
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
