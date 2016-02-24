//
//  Funcs.swift
//  Amanda
//
//  Created by Automan on 2/24/16.
//  Copyright © 2016 Automan. All rights reserved.
//

import Foundation
import UIKit

public func btnBlink(sender: UIButton) {
    UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
        sender.alpha = 0
        }, completion: {finished in
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                sender.alpha = 1
                }, completion: {finished in})
    })
}
