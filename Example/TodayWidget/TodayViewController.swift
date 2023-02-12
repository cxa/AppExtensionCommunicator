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
    preferredContentSize = CGSizeMake(self.view.bounds.width, 44)
    view.addSubview(_button)
    if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.lazyapps.AppExtensionCommunicatorExample") {
      communicator = AppExtensionCommunicator(containerURL: containerURL)
    } else {
      _button.setTitle("Setup App Groups Required", for: .normal)
      _button.setTitleColor(UIColor.red, for: .normal)
    }
  }
  
  override func viewDidLayoutSubviews() {
    _button.frame = view.bounds
  }
  
  private lazy var _button: UIButton = {
    let b = UIButton(frame: CGRectZero)
    b.setTitle("Tap to Diliver Message", for: .normal)
    b.setTitleColor(UIColor.white, for: .normal)
    b.setTitleColor(UIColor.blue, for: .highlighted)
    b.addTarget(self, action: #selector(_buttonTouchUpInside(btn:)), for: .touchUpInside)
    
    return b
  }()
  
  @objc private func _buttonTouchUpInside(btn: UIButton) {
    let r = arc4random_uniform(UInt32(Int32.max))
    communicator?.deliver(message: ["random" : NSNumber(value: Int32(r))], withIdentifier: "AppExtensionCommunicatorExample")
  }
  
}
