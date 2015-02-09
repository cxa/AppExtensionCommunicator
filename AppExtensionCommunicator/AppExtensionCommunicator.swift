//
//  AppExtensionCommunicator.swift
//  AppExtensionCommunicator
//
//  Created by CHEN Xian’an on 2/9/15.
//  Copyright (c) 2015 CHEN Xian’an. All rights reserved.
//

import Foundation
import AppExtensionCommunicatorHelper

/// message values accept only plist data types: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html
public typealias AppExtensionMessage = [String: AnyObject]

public typealias AppExtensionMessageHandler = AppExtensionMessage? -> Void

@objc
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
    CFNotificationCenterRemoveEveryObserver(center, unsafeBitCast(self, UnsafePointer<Void>.self))
  }
  
  /// Deliver `message` with `identifier`
  public func deliverMessage(message: AppExtensionMessage? = nil, withIdentifier identifier: String) {
    let target = _userInfoDir.URLByAppendingPathComponent(identifier)
    if let info = message {
      NSDictionary.writeToURL(info)(target, atomically: true)
    } else {
      NSFileManager().removeItemAtURL(target, error: nil)
    }
    
    let center = CFNotificationCenterGetDarwinNotifyCenter()
    let identifierCF = identifier as CFString
    CFNotificationCenterPostNotification(center, identifierCF, nil, nil, 1)
  }
  
  /// observe message with `identifier` using `messageHandler`
  public func observeMessageForIdentifier(identifier: String, usingHandler messageHandler: AppExtensionMessageHandler) {
    if _registeredHandlers[identifier] == nil {
      addObserverWithNameForDarwinNotifyCenter(unsafeBitCast(self, UnsafePointer<Void>.self), identifier)
    }
    
    _registeredHandlers[identifier] = messageHandler
  }
  
  // MARK: private properties
  
  private let _userInfoDir: NSURL
  
  private lazy var _registeredHandlers = [String: AppExtensionMessageHandler]()
  
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
        fm.removeItemAtURL(self._userInfoDir, error: nil)
        return false
      }
      
      return e
      }()
    
    if !dirExists {
      fm.createDirectoryAtURL(_userInfoDir, withIntermediateDirectories: true, attributes: nil, error: nil)
    }
  }
  
}