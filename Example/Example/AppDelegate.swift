//
//  AppDelegate.swift
//  Example
//
//  Created by CHEN Xian’an on 2/10/15.
//  Copyright (c) 2015 CHEN Xian’an. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    let vc = ViewController()
    window?.rootViewController = UINavigationController(rootViewController: vc)
    window?.makeKeyAndVisible()
    
    return true
  }

}

