//
//  HomeViewController.swift
//  Amanda
//
//  Created by Automan on 2/23/16.
//  Copyright © 2016 Automan. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

class HomeViewController: MasterViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MFMessageComposeViewControllerDelegate {
    var header: UIView?
    var headerImg: UIImageView?
    var headerTitle: UILabel?
    var weatherLabel: UILabel?
    var jsonData: NSData?
    var collectionView: UICollectionView?
    var footerLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //status bar & bg color
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.view.backgroundColor = bgColor
        
        //header
        //set header bg
        header = UIView()
        header!.frame = CGRectMake(0, 0, screen.width, screen.width)
        header!.backgroundColor = UIColor.blackColor()
        //set header img
        headerImg = UIImageView(frame: CGRectMake(0, 0, header!.frame.size.width, header!.frame.size.height))
        let imgAddress = NSURL(string: "https://source.unsplash.com/random")
        headerImg!.setImageWithUrl(imgAddress!)
//        let data = NSData(contentsOfURL: imgAddress!)
//        if data != nil {
//            headerImg!.image = UIImage(data: data!)
//        }
        //get unsplash image
        headerImg!.contentMode = UIViewContentMode.ScaleAspectFill
        headerImg!.alpha = 0.5
        header!.addSubview(headerImg!)
        //add header to screen
        self.view.addSubview(header!)
        //set title
        let titleHeight: CGFloat = 34
        headerTitle = UILabel(frame: CGRectMake(0,(screen.width - titleHeight) / 2,screen.width,titleHeight))
        headerTitle!.text = "这里是标题"
        headerTitle!.textColor = UIColor.whiteColor()
        headerTitle!.textAlignment = NSTextAlignment.Center
        headerTitle!.font = UIFont(name: light, size: 24)
        header!.addSubview(headerTitle!)
        //set weather
        //weather label
        let weatherHeight: CGFloat = 40
        weatherLabel = UILabel(frame: CGRectMake(0,headerTitle!.frame.origin.y + headerTitle!.frame.size.height - 5,screen.width,weatherHeight))
        weatherLabel!.text = ""
        weatherLabel!.textAlignment = NSTextAlignment.Center
        weatherLabel!.textColor = UIColor.whiteColor()
        weatherLabel!.font = UIFont(name: medium, size: 12)
        header!.addSubview(weatherLabel!)
        //get weather
        Alamofire.request(.GET, "http://www.weather.com.cn/data/cityinfo/101020100.html")
            .responseJSON { response in
                if let data = response.result.value {
                    print(data)
                    self.jsonData = data as? NSData
                    let dic: NSDictionary = (data["weatherinfo"] as? NSDictionary)!
                    let temp1: NSString = dic["temp1"] as! NSString
                    let temp2: NSString = dic["temp2"] as! NSString
                    let weather: NSString = dic["weather"] as! NSString
                    self.weatherLabel!.text = "\(temp2)~\(temp1) \(weather)"
                    print(self.weatherLabel!.text)
                } else {
                    print("newtwork erro")
                }
        }
        
        //set buttons
        //set collection view
        //set layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screen.width / 4, height: 120)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        //set collection view
        collectionView = UICollectionView(frame: CGRectMake(0, screen.width, screen.width, 120), collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        self.view.addSubview(collectionView!)
        
        //set footer
        let footerHeight: CGFloat = 17
        footerLabel = UILabel(frame: CGRectMake(0,screen.height - footerHeight - 10,screen.width,footerHeight))
        footerLabel!.text = "Automan❤️Amanda"
        footerLabel!.font = UIFont(name: medium, size: 12)
        footerLabel!.textAlignment = NSTextAlignment.Center
        self.view.addSubview(footerLabel!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell
        switch indexPath.row {
        case 0:
            cell.addSubview(actionBtn("iconCall"))
        case 1:
            cell.addSubview(actionBtn("iconFacetime"))
        case 2:
            cell.addSubview(actionBtn("iconMessage"))
        case 3:
            cell.addSubview(actionBtn("iconWechat"))
        default:
            print("cell unknown")
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    //set action button function
    func actionBtn(iconAddress: String) -> UIButton {
        //layout
        let btn: UIButton = UIButton(frame: CGRectMake(0,0,screen.width / 4,120))
        btn.setImage(UIImage(named: iconAddress), forState: UIControlState.Normal)
        //target
        switch iconAddress {
        case "iconCall":
            btn.addTarget(self, action: "call:", forControlEvents: UIControlEvents.TouchUpInside)
        case "iconFacetime":
            btn.addTarget(self, action: "facetime", forControlEvents: UIControlEvents.TouchUpInside)
        case "iconMessage":
            btn.addTarget(self, action: "message", forControlEvents: UIControlEvents.TouchUpInside)
        case "iconWechat":
            btn.addTarget(self, action: "wechat", forControlEvents: UIControlEvents.TouchUpInside)
        default:
            print("unknown aciton")
        }
        btn.addTarget(self, action: "btnSelected:", forControlEvents: UIControlEvents.TouchDown)
        return btn
    }
    
    //message deleget
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //action function
    func call(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
    }
    
    func facetime() {
        UIApplication.sharedApplication().openURL(NSURL(string: "facetime://\(phoneNumber)")!)
    }
    
    func message() {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        messageComposer.recipients = [phoneNumber]
        messageComposer.body = "老公, "
        presentViewController(messageComposer, animated: true, completion: nil)
    }
    
    func wechat() {
        UIApplication.sharedApplication().openURL(NSURL(string: "weixin://")!)
    }
    
    func btnSelected(sender: UIButton) {
        btnBlink(sender)
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
