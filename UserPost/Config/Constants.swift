//
//  Constants.swift
//  UserPost
//
//  Created by Bhagyashree Haresh Khatri on 02/03/2019.
//  Copyright © 2019 Bhagyashree Haresh Khatri. All rights reserved.
//

import UIKit
import Foundation

class Constants: NSObject {
    
    struct AUTH_API {
        static let baseURL = "https://jsonplaceholder.typicode.com/"
        static let getUsersListURL = "users"
        static let getUsersPostURL = "posts?userId="
    }
}

