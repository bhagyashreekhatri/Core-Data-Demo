//
//  Addres.swift
//  Created by Bhagyashree Haresh Khatri on 02/03/2019.
//  Copyright © 2019 Bhagyashree Haresh Khatri. All rights reserved.

import Foundation

struct Addres : Codable {

        let city : String?
        let geo : Geo?
        let street : String?
        let suite : String?
        let zipcode : String?

        enum CodingKeys: String, CodingKey {
                case city = "city"
                case geo = "geo"
                case street = "street"
                case suite = "suite"
                case zipcode = "zipcode"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                city = try values.decodeIfPresent(String.self, forKey: .city)
                geo = try values.decodeIfPresent(Geo.self, forKey: .geo)
                //geo = Geo(from: decoder)
                street = try values.decodeIfPresent(String.self, forKey: .street)
                suite = try values.decodeIfPresent(String.self, forKey: .suite)
                zipcode = try values.decodeIfPresent(String.self, forKey: .zipcode)
        }

}
