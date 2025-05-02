//
//  GKnowModels.swift
//  GKnow
//
//  Created by Curt Leonard on 5/1/25.

import Foundation
import SwiftData
import PencilKit
import SwiftUI


@Model
class Patient {
    @Attribute(.unique) var id = UUID()
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var dob: Date?
    var birthOrder: [String]?
    var role: [String]?
    
    
    init(firstName: String? = nil, middleName: String? = nil, lastName: String? = nil, dob: Date? = nil, birthOrder: [String]? = nil, role: [String]? = nil) {
        
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.dob = dob
        self.birthOrder = birthOrder
        self.role = role
    }
}
