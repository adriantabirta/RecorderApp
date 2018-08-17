//
//  RecordButton.swift
//  RecorderApp
//
//  Created by Oneest on 8/17/18.
//  Copyright © 2018 Oneest. All rights reserved.
//

import UIKit

class RecordButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor(red: 255/255, green: 91/255, blue: 119/255, alpha: 1)
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        titleLabel?.textColor = .white
        layer.cornerRadius = self.frame.width * 0.5
        layer.masksToBounds = true
    }
}
