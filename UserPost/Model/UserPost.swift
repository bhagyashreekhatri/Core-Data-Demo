//
//  UserPost.swift
// Created by Bhagyashree Haresh Khatri on 02/03/2019.
//  Copyright © 2019 Bhagyashree Haresh Khatri. All rights reserved.

import Foundation

struct UserPost : Codable {

        let body : String?
        var id = Int()
        let title : String?
        let userId : Int?

        enum CodingKeys: String, CodingKey {
                case body = "body"
                case id = "id"
                case title = "title"
                case userId = "userId"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                body = try values.decodeIfPresent(String.self, forKey: .body)
                id = try values.decodeIfPresent(Int.self, forKey: .id)!
                title = try values.decodeIfPresent(String.self, forKey: .title)
                userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        }

}
