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
    view.backgroundColor = UIColor.white
    view.addSubview(_textView)
    if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.lazyapps.AppExtensionCommunicatorExample") {
      communicator = AppExtensionCommunicator(containerURL: containerURL)
      communicator?.observeMessage(forIdentifier: "AppExtensionCommunicatorExample") { message in
        self._textView.text = "Received Notification: \n\n\(String(describing: message))"
      }
    } else {
      _textView.text = "Setup App Groups Required"
    }
  }
  
  override func viewDidLayoutSubviews() {
    _textView.frame = self.view.bounds
    _textView.scrollIndicatorInsets = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: self.view.safeAreaInsets.bottom, right: 0)
    _textView.contentOffset = CGPointMake(0, -self.view.safeAreaInsets.top)
  }
  
  private lazy var _textView: UITextView = {
    let tv = UITextView(frame: CGRectZero)
    tv.text = "Swipe down Today View to install extension and test notification"
    tv.font = UIFont.systemFont(ofSize: 27)
    tv.isEditable = false
    
    return tv
  }()

}

