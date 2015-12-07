//
//  AppExtensionCommunicator.swift
//  AppExtensionCommunicator
//
//  Created by CHEN Xian’an on 2/9/15.
//  Copyright (c) 2015 CHEN Xian’an. All rights reserved.
//

import Foundation
//import AppExtensionCommunicatorHelper

/// message values accept only plist data types: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html
public typealias AppExtensionMessage = [String: AnyObject]

public typealias AppExtensionMessageHandler = AppExtensionMessage? -> ()

public class AppExtensionCommunicator {
  
  let containerURL: NSURL
  
  /// `containerURL` Application group container directory, usually you can get it by `containerURLForSecurityApplicationGroupIdentifier` of `NSFileManager`
  public init(containerURL theURL: NSURL) {
    containerURL = theURL
    _userInfoDir = containerURL.URLByAppendingPathComponent(".AppExtensionCommunicator")
    _checkAndCreateUserInfoDir()
  }
  
  
  deinit {
    let center = CFNotificationCenterGetDarwinNotifyCenter()
    CFNotificationCenterRemoveEveryObserver(center, unsafeBitCast(self, UnsafePointer<()>.self))
  }
  
  // MARK: private properties
  
  private let _userInfoDir: NSURL
  
  private lazy var _registeredHandlers = [String: AppExtensionMessageHandler]()
  
}

public extension AppExtensionCommunicator {

  /// Deliver `message` with `identifier`
  public func deliverMessage(message: AppExtensionMessage? = nil, withIdentifier identifier: String) {
    let target = _userInfoDir.URLByAppendingPathComponent(identifier)
    if let msg = message {
      NSDictionary.writeToURL(msg)(target, atomically: true)
    } else {
      try! NSFileManager().removeItemAtURL(target)
    }
    
    let center = CFNotificationCenterGetDarwinNotifyCenter()
    let identifierCF = identifier as CFString
    CFNotificationCenterPostNotification(center, identifierCF, nil, nil, true)
  }
  
  /// observe message with `identifier` using `messageHandler`
  public func observeMessageForIdentifier(identifier: String, usingHandler messageHandler: AppExtensionMessageHandler) {
    if _registeredHandlers[identifier] == nil {
      let darwinCenter = CFNotificationCenterGetDarwinNotifyCenter()
      CFNotificationCenterAddObserver(darwinCenter, unsafeBitCast(self, UnsafePointer<()>.self), _callback, identifier, nil, .DeliverImmediately)
    }
    
    _registeredHandlers[identifier] = messageHandler
  }
  
}

// MARK: private methods
private extension AppExtensionCommunicator {
  
  @objc func _handleNotificationCallbackWithName(name: String) {
    if let handler = _registeredHandlers[name] {
      let target = _userInfoDir.URLByAppendingPathComponent(name)
      let userInfo = NSDictionary(contentsOfURL: target) as? AppExtensionMessage
      handler(userInfo)
    }
  }
  
  func _checkAndCreateUserInfoDir() {
    let fm = NSFileManager()
    let dirExists: Bool = {
      var isDir = ObjCBool(true)
      let e = fm.fileExistsAtPath(self._userInfoDir.path!, isDirectory: &isDir)
      if !isDir.boolValue {
        try! fm.removeItemAtURL(self._userInfoDir)
        return false
      }
      
      return e
      }()
    
    if !dirExists {
      try! fm.createDirectoryAtURL(_userInfoDir, withIntermediateDirectories: true, attributes: nil)
    }
  }
  
}


private func _callback(center: CFNotificationCenter!, observer: UnsafeMutablePointer<()>, notiName: CFString!, obj: UnsafePointer<()>, userInfo: CFDictionary!) -> () {
  let communicator = unsafeBitCast(observer, AppExtensionCommunicator.self)
  let name = notiName as String
  communicator._handleNotificationCallbackWithName(name)
}
