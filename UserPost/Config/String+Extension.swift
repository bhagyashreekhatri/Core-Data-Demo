//
//  String+Extension.swift
//  MPA
//
//  Created by Lim Song Wee on 26/02/2018.
//  Copyright © 2018 Fireworks Solution. All rights reserved.
//

import Foundation
import UIKit


extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            
        } catch {
            print("error:", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
