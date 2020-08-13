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
    var isContacted = false
}
