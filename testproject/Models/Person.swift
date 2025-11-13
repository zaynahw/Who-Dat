//
//  File.swift
//  iosproject
//
//  Created by Zaynah Wahab on 11/11/25.
//

import SwiftUI

struct Person: Identifiable {
    
    var id: UUID = UUID()
    var name: String
    var locationMet: String
    var major: String
    var dateMet: String
    var insta: String
    var tags: [String]
    var description: String
    var imageData: Data? = nil
    
    init(name: String = "No Name",
        locationMet: String = "",
        major: String = "",
        dateMet: String = "01/01/2025",
        insta: String = "",
        tags: [String] = [],
        imageData: Data? = nil,
         description: String = ""){
        self.name = name.isEmpty ? "No Name" : name
        self.locationMet = locationMet
        self.major = major
        self.dateMet = dateMet
        self.insta = insta
        self.tags = tags
        self.imageData = imageData
        self.description = description.isEmpty ? "No Description": description
    }
    
}
