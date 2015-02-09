//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by CHEN Xian’an on 2/10/15.
//  Copyright (c) 2015 CHEN Xian’an. All rights reserved.
//

import UIKit
import AppExtensionCommunicator

class TodayViewController: UIViewController {
  
  var communicator: AppExtensionCommunicator?
  
  override func loadView() {
    super.loadView()
    preferredContentSize = CGSizeMake(0, 44)
    view.addSubview(_button)
    if let containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.lazyapps.AppExtensionCommunicatorExample") {
      communicator = AppExtensionCommunicator(containerURL: containerURL)
    } else {
      _button.setTitle("Setup App Groups Required", forState: .Normal)
      _button.setTitleColor(UIColor.redColor(), forState: .Normal)
    }
  }
  
  override func viewDidLayoutSubviews() {
    _button.frame = view.bounds
  }
  
  private lazy var _button: UIButton = {
    let b = UIButton(frame: CGRectZero)
    b.setTitle("Tap to Diliver Message", forState: .Normal)
    b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    b.setTitleColor(UIColor.blueColor(), forState: .Highlighted)
    b.addTarget(self, action: "_buttonTouchUpInside:", forControlEvents: .TouchUpInside)
    
    return b
  }()
  
  @objc private func _buttonTouchUpInside(btn: UIButton) {
    let r = arc4random_uniform(UInt32(Int32.max))
    communicator?.deliverMessage(message: ["random" : NSNumber(int: Int32(r))], withIdentifier: "AppExtensionCommunicatorExample")
  }
  
}
