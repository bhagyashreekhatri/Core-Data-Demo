//
//  Geo.swift
//  Created by Bhagyashree Haresh Khatri on 02/03/2019.
//  Copyright © 2019 Bhagyashree Haresh Khatri. All rights reserved.
import Foundation

struct Geo : Codable {

        let lat : String?
        let lng : String?

        enum CodingKeys: String, CodingKey {
                case lat = "lat"
                case lng = "lng"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                lat = try values.decodeIfPresent(String.self, forKey: .lat)
                lng = try values.decodeIfPresent(String.self, forKey: .lng)
        }

}
