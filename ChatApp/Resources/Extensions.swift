//
//  Extensions.swift
//  ChatApp
//
//  Created by 최광현 on 2021/03/31.
//

import Foundation
import UIKit

extension UIView {
    public var width: CGFloat {
        return self.frame.width
    }
    
    public var height: CGFloat {
        return self.frame.height
    }
    
    public var top: CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat {
        return self.height + self.top
    }
    
    public var left: CGFloat {
        return self.frame.origin.x
    }
    
    public var right: CGFloat {
        return self.width + self.left
    }
}
