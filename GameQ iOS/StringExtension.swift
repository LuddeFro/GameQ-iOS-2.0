//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import Foundation

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
    
    func validEmail() -> (Bool) {
        //^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,4}$
        let regex:Regex = Regex("^[a-z0-9._%+\\-]+@[a-z0-9.\\-]+\\.[a-z]{2,4}$")
        return regex.test(self)
    }
    
    func validPassword() -> (Bool) {
        if count(self) >= 6 {
            return true
        } else {
            return false
        }
    }
    
}


