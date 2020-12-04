//
//  repairRequestQuery.swift
//  Ims Repair
//
//  Created by Kevin Tierney on 11/21/20.
//

import Foundation
import FirebaseFirestoreSwift

struct repair: Identifiable, Codable{
    @DocumentID var id : String?
    var name : String
    var email: String
    var company: String
    var brand: String
    var model: String
    var sn: String
    var issue: String
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case company
        case brand
        case model
        case sn
        case issue
        case status
        }
    }



