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

class HomeViewController: MasterViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MFMessageComposeViewControllerDelegate, UIScrollViewDelegate {
    var header: UIView?
    var headerImg: UIImageView?
    var headerTitle: UILabel?
    var subtitle: UILabel?
    var jsonData: NSData?
    var scrollView: UIScrollView?
    var collectionView: UICollectionView?
    var footerLabel: UILabel?
    let square: CGFloat = Size().screen.width / 2 - 0.5
    let headerHeight = Size().screen.height - Size().screen.width
    var btnLogout: UIButton?
    let phoneNumber = LocalData().userDefaults.objectForKey(LocalData().keyUser)?.objectForKey("callNumber")

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(phoneNumber!)
        // Do any additional setup after loading the view.
        //status bar & bg color
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.navigationController?.navigationBarHidden = true
        self.view.backgroundColor = Colors().bgColor
        
        //header
        //set header bg
        header = UIView()
        header!.frame = CGRectMake(0, 0, Size().screen.width, headerHeight)
        header!.backgroundColor = UIColor.grayColor()
//        header!.layer.anchorPoint = CGPoint(x: 0, y: 0)
        //set header img
        headerImg = UIImageView(frame: CGRectMake(0, 0, header!.frame.size.width, header!.frame.size.height))
        //get unsplash image
        headerImg!.contentMode = UIViewContentMode.ScaleAspectFill
        headerImg!.alpha = 0.5
        header!.addSubview(headerImg!)
        //add header to screen
        self.view.addSubview(header!)
        //set title
        let titleHeight: CGFloat = 45
        headerTitle = UILabel(frame: CGRectMake(0,(header!.frame.size.height - titleHeight) / 2 - 10,Size().screen.width,titleHeight))
        headerTitle!.textColor = UIColor.whiteColor()
        headerTitle!.textAlignment = NSTextAlignment.Center
        headerTitle!.font = UIFont(name: Fonts().light, size: 32)
        header!.addSubview(headerTitle!)
        //set weather
        //weather label
        let weatherHeight: CGFloat = 40
        let weatherWidth: CGFloat = Size().screen.width * 0.9
        subtitle = UILabel(frame: CGRectMake((Size().screen.width - weatherWidth) / 2,headerTitle!.frame.origin.y + headerTitle!.frame.size.height,weatherWidth,weatherHeight))
        subtitle!.numberOfLines = 0
        subtitle!.textAlignment = NSTextAlignment.Center
        subtitle!.textColor = UIColor.whiteColor()
        subtitle!.font = UIFont(name: Fonts().semibold, size: 14)
        subtitle!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        header!.addSubview(subtitle!)
        //get weather
        getData()
        
        //set scroll view
        scrollView = UIScrollView(frame: CGRectMake(0,0,Size().screen.width,Size().screen.height))
        scrollView!.alwaysBounceVertical = true
        scrollView!.contentSize = CGSize(width: Size().screen.width, height: Size().screen.height)
        scrollView!.delegate = self
        self.view.addSubview(scrollView!)
        
        //add pull refresh
        let loadView = DGElasticPullToRefreshLoadingViewCircle()
        loadView.tintColor = UIColor.whiteColor()
        scrollView!.dg_addPullToRefreshWithActionHandler({
            self.clearCache()
            self.getData()
            }, loadingView: loadView)
        
        //set collection view
        //set layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: square, height: square)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        //set collection view
        collectionView = UICollectionView(frame: CGRectMake(0, Size().screen.height - Size().screen.width, Size().screen.width, Size().screen.width), collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.backgroundColor = Colors().bgColor
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        scrollView!.addSubview(collectionView!)
        
        //log out btn
        btnLogout = UIButton()
        let logoutWith: CGFloat = 20
        let logoutHeight: CGFloat = 20
        btnLogout!.frame.size = CGSize(width: logoutWith, height: logoutHeight)
        btnLogout!.frame.origin = CGPoint(x: Size().screen.width - logoutWith - 15, y: 30)
//        btnLogout!.backgroundColor = UIColor.blackColor()
//        btnLogout!.setTitle("logout", forState: .Normal)
        btnLogout!.setImage(UIImage(named: "logout"), forState: UIControlState.Normal)
        btnLogout!.addTarget(self, action: "logout:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView!.addSubview(btnLogout!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        scrollView!.dg_removePullToRefresh()
    }
    
    //get data
    func getData() {
        getImg()
        getWeatherData()
    }
    
    func clearCache() {
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    //get header img
    func getImg() {
        Alamofire.request(.GET, API().unsplashAPI, parameters: ["client_id": API().unsplashAppID])
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
                if let reponseJSON = response.result.value {
                    let json = JSON(reponseJSON)
                    //print(json["urls"]["full"])
                    let url = NSURL(string: json["urls"]["small"].string!)
                    self.headerImg!.image = UIImage(data: NSData(contentsOfURL: url!)!)
                    self.scrollView!.dg_stopLoading()
                }
        }
    }
    
    //get weather data
    func getWeatherData() {
        Alamofire.request(.GET, API().weatherAPIURL, headers: ["apikey": API().baiduAPIKey], parameters: ["city": API().city])
            .responseJSON { response in
                if let reponseJSON = response.result.value {
                    let json = JSON(reponseJSON)
                    //print(json)
                    //let temp = json["HeWeather data service 3.0"][0]["daily_forecast"][0]["tmp"]["min"].string! + "~" + json["HeWeather data service 3.0"][0]["daily_forecast"][0]["tmp"]["max"].string! + "℃"
                    let tempNow = json["HeWeather data service 3.0"][0]["now"]["tmp"].string!
                    let cond = json["HeWeather data service 3.0"][0]["now"]["cond"]["txt"].string!
                    self.subtitle!.text = json["HeWeather data service 3.0"][0]["suggestion"]["comf"]["txt"].string!
                    self.subtitle!.sizeToFit()
                    self.headerTitle!.text = tempNow + "℃" + " " + cond
                } else {
                    self.headerTitle!.text = "网络抽风了,稍等"
                }
        }
    }
    
    //scroll view delegate funciton
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let alphaRate = -scrollView.contentOffset.y * 0.008
        let heightRate = 1 + -scrollView.contentOffset.y * 0.005
        
        if scrollView.contentOffset.y < 0 {
            headerImg!.frame.size.height = headerHeight * heightRate
            header!.frame.size.height = headerHeight * heightRate
            headerTitle!.alpha = 1 - alphaRate
            subtitle!.alpha = 1 - alphaRate
        } else {
            headerTitle!.alpha = 1 + alphaRate
            subtitle!.alpha = 1 + alphaRate
        }
    }
    
    //collection view delegate function
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
        let btn: UIButton = UIButton(frame: CGRectMake(0,0,square,square))
        btn.setImage(UIImage(named: iconAddress), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.whiteColor()
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
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber!)")!)
    }
    
    func facetime() {
        UIApplication.sharedApplication().openURL(NSURL(string: "facetime://\(phoneNumber!)")!)
    }
    
    func message() {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        messageComposer.recipients = ["\(phoneNumber!)"]
        messageComposer.body = "亲爱的, "
        presentViewController(messageComposer, animated: true, completion: nil)
    }
    
    func wechat() {
        UIApplication.sharedApplication().openURL(NSURL(string: "weixin://")!)
    }
    
    func btnSelected(sender: UIButton) {
        btnBlink(sender)
    }
    
    func logout(sender: UIButton) {
        let actionSheet = UIAlertController(title: "是否登出", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionLogout = UIAlertAction(title: "登出", style: UIAlertActionStyle.Destructive, handler: { handler in
            LocalData().userDefaults.removeObjectForKey(LocalData().keyUser)
            let login = LoginViewController()
            self.navigationController?.setViewControllers([login], animated: true)
        })
        let actionCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {handler in})
        actionSheet.addAction(actionLogout)
        actionSheet.addAction(actionCancel)
        self.presentViewController(actionSheet, animated: true, completion: {})
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
