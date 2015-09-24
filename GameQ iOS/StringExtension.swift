

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
        if self.characters.count >= 6 {
            return true
        } else {
            return false
        }
    }
    
}


