//
//  LoginViewController.swift
//  Amanda
//
//  Created by Automan on 2/26/16.
//  Copyright © 2016 Automan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var btnAutoman: UIButton?
    var btnAmanda: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBarHidden = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        btnAutoman = getLoginButton("Amanda")
        btnAutoman!.frame.origin = CGPoint(x: (Size().screen.width - btnAutoman!.frame.size.width) / 2, y: (Size().screen.height - btnAutoman!.frame.size.height) / 2 - 20)
        btnAutoman!.tag = 0
        btnAutoman!.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnAutoman!)
        
        btnAmanda = getLoginButton("Automan")
        btnAmanda!.frame.origin = CGPoint(x: btnAutoman!.frame.origin.x, y: Size().screen.height / 2 + 20)
        btnAmanda!.tag = 1
        btnAmanda!.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnAmanda!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(sender: UIButton) {
        switch sender.tag {
        case 0:
            LocalData().userDefaults.setObject(LocalData().valueUserAmanda, forKey: LocalData().keyUser)
        case 1:
            LocalData().userDefaults.setObject(LocalData().valueUserAutoman, forKey: LocalData().keyUser)
        default:
            print("who is logining in?")
        }
        LocalData().userDefaults.setBool(true, forKey: LocalData().keyLogin)
        
        let home = HomeViewController()
        self.navigationController?.setViewControllers([home], animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
