//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Nate Lee on 8/13/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI
import CodeScanner


enum FilterType {
    case none, contacted, uncontacted
}

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(trailing: Button(action: {
                // TODO: - Scan QR Code first.
                //                let prospect = Prospect()
                //                prospect.name = "Paul Hudson"
                //                prospect.emailAddress = "paul@hackingwithswift.com"
                //                self.prospects.people.append(prospect)
                self.isShowingScanner = true
                
            }) {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            })
        }
        .sheet(isPresented: $isShowingScanner) {
            //            CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\nexample@cool.com") { (result) in
            //                switch result {
            //                case .failure(let error):
            //                    print(error.localizedDescription)
            //                case .success(let str):
            //                    print(str)
            //                }
            //            }
            CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\nexample@cool.com", completion: self.handleScan(result:))
        }
    }
    
    // Custom Funcs
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            self.prospects.people.append(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
}


