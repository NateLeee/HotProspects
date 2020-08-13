//
//  Prospect.swift
//  HotProspects
//
//  Created by Nate Lee on 8/13/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    let id = UUID()
    
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published fileprivate(set) var people: [Prospect]
    
    init() {
        // UserDefaults
        if let data = UserDefaults.standard.data(forKey: Constants.saveKey) {
            if let prospects = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = prospects
                return
            }
        }
        
        self.people = []
        
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(self.people) {
            UserDefaults.standard.setValue(encoded, forKey: Constants.saveKey)
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        
        save()
    }
}
