//
//  ViewController.swift
//  Example
//
//  Created by CHEN Xian’an on 2/10/15.
//  Copyright (c) 2015 CHEN Xian’an. All rights reserved.
//

import UIKit
import AppExtensionCommunicator

class ViewController: UIViewController {

  var communicator: AppExtensionCommunicator?
  
  override func loadView() {
    super.loadView()
    navigationItem.title = "AppExtensionCommunicator Example"
    view.backgroundColor = UIColor.whiteColor()
    view.addSubview(_textView)
    if let containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.lazyapps.AppExtensionCommunicatorExample") {
      communicator = AppExtensionCommunicator(containerURL: containerURL)
      communicator?.observeMessageForIdentifier("AppExtensionCommunicatorExample") { message in
        self._textView.text = "Received Notification: \n\n\(message)"
      }
    } else {
      _textView.text = "Setup App Groups Required"
    }
  }
  
  override func viewDidLayoutSubviews() {
    _textView.frame = self.view.bounds
    _textView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)
    _textView.contentOffset = CGPointMake(0, -self.topLayoutGuide.length)
  }
  
  private lazy var _textView: UITextView = {
    let tv = UITextView(frame: CGRectZero)
    tv.text = "Swipe down Today View to install extension and test notification"
    tv.font = UIFont.systemFontOfSize(27)
    tv.editable = false
    
    return tv
  }()

}

