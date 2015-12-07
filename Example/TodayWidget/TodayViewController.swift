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
  
  let communicator: AppExtensionCommunicator? = AppExtensionCommunicator(grounpIdentifer: "group.com.lazyapps.AppExtensionCommunicatorExample")
  
  let communicator2: AppExtensionCommunicator = AppExtensionCommunicator()
  
  let id = "AppExtensionCommunicatorExample"
  
  let id2 = "AppExtensionCommunicatorExample2"
  
  override func loadView() {
    super.loadView()
    preferredContentSize = CGSizeMake(0, 64)
    view.addSubview(_button)
    view.addSubview(_button2)
    if communicator == nil {
      _button.setTitle("Setup App Groups Required", forState: .Normal)
      _button.setTitleColor(UIColor.redColor(), forState: .Normal)
    }
  }
  
  override func viewDidLayoutSubviews() {
    var b = view.bounds
    b.size.height = 32
    _button.frame = b
    b.origin.y = 32
    _button2.frame = b
  }
  
  private lazy var _button: UIButton = {
    let b = UIButton(frame: CGRectZero)
    b.setTitle("Diliver a Random Number", forState: .Normal)
    b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    b.setTitleColor(UIColor.blueColor(), forState: .Highlighted)
    b.addTarget(self, action: "_buttonTouchUpInside:", forControlEvents: .TouchUpInside)
    
    return b
  }()
  
  private lazy var _button2: UIButton = {
    let b = UIButton(frame: CGRectZero)
    b.setTitle("Diliver a nil Message", forState: .Normal)
    b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    b.setTitleColor(UIColor.blueColor(), forState: .Highlighted)
    b.addTarget(self, action: "_buttonTouchUpInside:", forControlEvents: .TouchUpInside)
    
    return b
  }()
  
  @objc private func _buttonTouchUpInside(btn: UIButton) {
    if btn == _button {
      let r = arc4random_uniform(UInt32(Int32.max))
      communicator?.deliverMessageWithIdentifier(identifier: id, content: ["random" : NSNumber(int: Int32(r))])
    } else {
      communicator2.deliverMessageWithIdentifier(identifier: id2)
    }
  }
  
}
