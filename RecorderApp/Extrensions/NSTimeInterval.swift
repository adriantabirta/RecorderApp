//
//  NSTimeInterval.swift
//  RecorderApp
//
//  Created by Oneest on 8/17/18.
//  Copyright © 2018 Oneest. All rights reserved.
//

import Foundation

extension TimeInterval {

    var toHumanTime: String {
        let min = Int(self / 60)
        let sec = Int(self.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min, sec)
    }
}
