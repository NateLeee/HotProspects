//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Nate Lee on 8/13/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI
import CodeScanner
import UserNotifications



enum FilterType {
    case none, contacted, uncontacted
}

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false
    @State private var showingSortOptions = false
    
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
                    HStack {
                        if (self.filter == .none) {
                            if (prospect.isContacted) {
                                Image(systemName: "checkmark.circle")
                            } else {
                                Image(systemName: "questionmark.diamond")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        .contextMenu {
                            Button(action: {
                                // prospect.isContacted.toggle() // Won't update the UI
                                self.prospects.toggle(prospect)
                            }) {
                                Text("\(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted")")
                            }
                            
                            if !prospect.isContacted {
                                Button("Remind Me") {
                                    self.addNotification(for: prospect)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(leading: Button(action: {
                self.showingSortOptions = true // Bring up the action sheet
                
            }, label: {
                Image(systemName: "slider.horizontal.3")
                Text("Sort")
                
            }), trailing: Button(action: {
                self.isShowingScanner = true
                
            }) {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            })
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "A\nexample@cool.com", completion: self.handleScan(result:))
        }
        .actionSheet(isPresented: $showingSortOptions) {
            ActionSheet(title: Text("Sort"), message: Text("Sort by?"), buttons: [
                .default(Text("Name"), action: {
                    // TODO: - Sort them by their name
                    self.prospects.sort(by: .name)
                    
                }),
                .default(Text("Most recent"), action: {
                    // TODO: - Sort them other way
                    self.prospects.sort(by: .mostRecent)
                    
                }),
                ActionSheet.Button.cancel()
            ])
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
            
            self.prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}


