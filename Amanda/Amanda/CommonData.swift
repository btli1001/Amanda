//
//  API.swift
//  Amanda
//
//  Created by Automan on 2/24/16.
//  Copyright © 2016 Automan. All rights reserved.
//

import Foundation
import UIKit

struct API {
    //weather
    let baiduAPIKey = "2cbde43749a4c5edf90819007111c32a"
    let weatherAPIURL = "http://apis.baidu.com/heweather/weather/free"
    let city = "shanghai"
    //unsplash
    let unsplashAppID = "23e4b86b222fdf6adf03e245ae68e414b4b6453f4da4f17c15c7bf6e73a2e1cc"
    let unsplashSecret = "9f6e4d39c1038b2f9923e6723dd41e595b2ad99983592561d6735ec3ed485d62"
    let unsplashToken = "9372636da7dfc0969ef4042fe6bf9239b47f41713d34a92d321f8d540455e321"
    let unsplashSource = NSURL(string: "https://source.unsplash.com/random")
    let unsplashAPI = "https://api.unsplash.com/photos/random"
}

struct Colors {
    let bgColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
}

struct Size {
    let screen = UIScreen.mainScreen().bounds
}

struct Fonts {
    let light = "PingFangSC-Light"
    let medium = "PingFangSC-Medium"
    let regular = "PingFangSC-Regular"
    let semibold = "PingFangSC-Semibold"
    let thin = "PingFangSC-Thin"
    let ultralight = "PingFangSC-Ultralight"
}

struct PersonalInfo {
    let phoneNumber = "18621579857"
}

public func btnBlink(sender: UIButton) {
    UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
        sender.alpha = 0
        }, completion: {finished in
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                sender.alpha = 1
                }, completion: {finished in})
    })
}