//
//  Prospect.swift
//  HotProspects
//
//  Created by Nate Lee on 8/13/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable, Comparable {
    let id = UUID()
    
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    fileprivate(set) var updatedAt = Date()
    
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.name < rhs.name
    }
    
}

class Prospects: ObservableObject {
    @Published fileprivate(set) var people: [Prospect]
    
    init() {
        // Now, decode JSON from the document dir.
        let url = Utilities.getDocumentsDirectory().appendingPathComponent(Constants.saveFileName)
        
        do {
            let data = try Data(contentsOf: url)
            people = try JSONDecoder().decode([Prospect].self, from: data)
            return
            
        } catch {
            print("Unable to load saved data.")
        }
        
        self.people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(self.people) {
            // UserDefaults.standard.setValue(encoded, forKey: Constants.saveKey)
            
            // Save data to the document dir.
            let url = Utilities.getDocumentsDirectory().appendingPathComponent(Constants.saveFileName)
            do {
                try encoded.write(to: url, options: [.atomicWrite])
                
                #if DEBUG
                let input = try String(contentsOf: url)
                print(input)
                #endif
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        
        prospect.updatedAt = Date()
        
        save()
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        
        prospect.updatedAt = Date()
        
        save()
    }
    
    enum SortOption {
        case name
        case mostRecent
    }
    
    func sort(by sortingOption: SortOption) {
        switch sortingOption {
        case .name:
            people.sort() // I said it 'cause I can.
            
        case .mostRecent:
            people.sort { (lhs, rhs) -> Bool in
                lhs.updatedAt > rhs.updatedAt
            }
        }
    }
}
