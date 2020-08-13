//
//  MeView.swift
//  HotProspects
//
//  Created by Nate Lee on 8/13/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins


struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    
    let context = CIContext()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("My Info")) {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                    
                    TextField("Email address", text: $emailAddress)
                        .textContentType(.emailAddress)
                }
                
                Section(header: Text("QR Code")) {
                    HStack(alignment: .center) {
                        Spacer()
                        
                        Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 135)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Anout Me")
        }
    }
    
    // Custom Funcs
    func generateQRCode(from string: String) -> UIImage {
        let data = string.data(using: String.Encoding.utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputCIImage = filter.outputImage {
                if let cgimg = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
                    return UIImage(cgImage: cgimg)
                }
            }
        }
        
        return UIImage(systemName: "xmark.circle")!
    }
    
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
