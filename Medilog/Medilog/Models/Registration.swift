//
//  Registration.swift
//  Medilog
//
//  Created by Amarnath on 23/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//
enum Sex:String {
    case male = "Male"
    case female = "Female"
}

import Foundation

class Registration {
    var firstName:String?
    var lastName:String?
    var sex:Sex?
    var password:String?
    var confirmPassword:String?
    var email:String?
    var confirmEmail:String?
}
