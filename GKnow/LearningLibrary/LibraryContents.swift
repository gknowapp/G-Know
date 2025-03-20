//
//  LibraryContents.swift
//  GKnow
//
//  Created by Curt Leonard on 3/18/25.
//

import Foundation

struct LibraryContents {
    
    struct symbolNames {
        
        let male = ["Male", "Male", "A square represents a male on a genogram."]
        let female = ["Female", "Female", "A circle represents a female on a genogram"]
        let abortion = ["Abortion", "Abortion", "An X with no other symbol around it represents an abortion on a genogram"]
        let pregancy = ["Pregnancy", "Pregnancy", "A triangle represents a pregnancy on a genogram"]
        let miscarriage = ["Miscarriage", "Miscarriage", "A small filled in dot represents a miscarriage on a genogram"]

    }
    
    struct relationships  {

         let marriage = ["Marriage Connection", "Marriage", "This connection indicates two people are married."]
        let child = ["Child Connection", "Child", "This connection indicates that a child was born from this marriage"]
        let abuse = ["Abuse", "Abuse", "This connection indicates there was abuse from the person at the base of the arrow to the person at the tip of the arrow"]
        let harmony = ["Harmony", "Harmony", "This connection indicates a harmonious relationship between two people"]
        let friendship = ["Friendship", "Friendship", "This connection indicates a friendship between two people"]
        let fusion = ["Fusion", "Fusion", "This connection indicates a fusion between two people. This is a rare and significant connection."]
        let focus = ["Focused On", "Focused On", "This indicates that the person at the base of the arrow is focused on the person at the tip of the arrow"]
        let dating = ["Dating", "Dating", "This indicates that two people are dating"]
        let affair = ["Affair", "Affair", "This indicates that two people are having an affair"]
        let divorce = ["Divorce", "Divorce", "This indicates that two people have divorced"]
        //case engaged = "Engaged"
        
    }
    
    
}
