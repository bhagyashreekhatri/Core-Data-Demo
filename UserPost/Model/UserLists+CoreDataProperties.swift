//
//  UserLists+CoreDataProperties.swift
//  
//  Created by Bhagyashree Haresh Khatri on 02/03/2019.
//
//

import Foundation
import CoreData


extension UserLists {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLists> {
        return NSFetchRequest<UserLists>(entityName: "UserLists")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var username: String?
    @NSManaged public var id: Int32
    @NSManaged public var address: String?
    @NSManaged public var company: String?

}
