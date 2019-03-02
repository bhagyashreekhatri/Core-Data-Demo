//
//  Company.swift
//  Created by Bhagyashree Haresh Khatri on 02/03/2019.
//  Copyright © 2019 Bhagyashree Haresh Khatri. All rights reserved.

import Foundation

struct Company : Codable {

        let bs : String?
        let catchPhrase : String?
        let name : String?

        enum CodingKeys: String, CodingKey {
                case bs = "bs"
                case catchPhrase = "catchPhrase"
                case name = "name"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                bs = try values.decodeIfPresent(String.self, forKey: .bs)
                catchPhrase = try values.decodeIfPresent(String.self, forKey: .catchPhrase)
                name = try values.decodeIfPresent(String.self, forKey: .name)
        }

}
