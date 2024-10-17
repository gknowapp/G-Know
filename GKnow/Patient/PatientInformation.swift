//
//  PatientInformation.swift
//  GKnow
//
//  Created by Catherine Chu on 10/2/24.
//

import SwiftUI

struct PatientInformation: Codable, Identifiable {
    var id: String
    var fields: Fields
}

struct Fields: Codable {
    var firstName: String?
    var middleName: String?
    var lastName: String?
//    var dob: Date?
//    var birthOrder: [String]?
//    var role: [String]?
}

