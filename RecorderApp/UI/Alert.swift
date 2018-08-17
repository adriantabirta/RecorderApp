//
//  Alert.swift
//  RecorderApp
//
//  Created by Oneest on 8/17/18.
//  Copyright © 2018 Oneest. All rights reserved.
//

import UIKit
import Foundation

class Alert: NSObject {
    
    private var title = "Hey!"
    private var message = ""

    
    func title(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    func message(_ message: String) -> Self {
        self.message = message
        return self
    }
    
    func show() {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}
