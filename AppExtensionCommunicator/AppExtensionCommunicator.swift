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
public typealias AppExtensionMessageContent = [String: AnyObject]

public typealias AppExtensionMessageContentHandler = AppExtensionMessageContent? -> ()

public class AppExtensionCommunicator {
  
  let containerURL: NSURL?
  
  /// `containerURL` Application group container directory, usually you can get it by `containerURLForSecurityApplicationGroupIdentifier` of `NSFileManager`
  /// Pass nil if you don't need to deliver message content
  public init(containerURL theURL: NSURL? = nil) {
    containerURL = theURL
    if let url = containerURL {
      _userInfoDir = url.URLByAppendingPathComponent(".AppExtensionCommunicator")
      _checkAndCreateUserInfoDir(_userInfoDir!)
    } else {
      _userInfoDir = nil
    }
  }
  
  public convenience init?(grounpIdentifer: String) {
    guard let containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(grounpIdentifer) else { return nil }
    self.init(containerURL: containerURL)
  }
  
  deinit {
    let center = CFNotificationCenterGetDarwinNotifyCenter()
    CFNotificationCenterRemoveEveryObserver(center, unsafeBitCast(self, UnsafePointer<()>.self))
  }
  
  // MARK: private properties
  private let _userInfoDir: NSURL?
  
  private lazy var _registeredHandlers = [String: AppExtensionMessageContentHandler]()
  
}

public extension AppExtensionCommunicator {

  /// Deliver `message` with `identifier`
  public func deliverMessageWithIdentifier(identifier identifier: String, content: AppExtensionMessageContent? = nil) {
    if let target = _userInfoDir?.URLByAppendingPathComponent(identifier),
      let cnt = content {
        NSDictionary.writeToURL(cnt)(target, atomically: true)
    }
    
    let center = CFNotificationCenterGetDarwinNotifyCenter()
    let identifierCF = identifier as CFString
    CFNotificationCenterPostNotification(center, identifierCF, nil, nil, true)
  }
  
  /// observe message with `identifier` using `messageHandler`
  public func observeMessageForIdentifier(identifier: String, usingHandler contentHandler: AppExtensionMessageContentHandler) {
    if _registeredHandlers[identifier] == nil {
      let darwinCenter = CFNotificationCenterGetDarwinNotifyCenter()
      CFNotificationCenterAddObserver(darwinCenter, unsafeBitCast(self, UnsafePointer<()>.self), _callback, identifier, nil, .DeliverImmediately)
    }
    
    _registeredHandlers[identifier] = contentHandler
  }
  
}

// MARK: private methods
private extension AppExtensionCommunicator {
  
  @objc func _handleNotificationCallbackWithName(name: String) {
    if let handler = _registeredHandlers[name] {
      let target = _userInfoDir?.URLByAppendingPathComponent(name)
      let userInfo = target.flatMap { NSDictionary(contentsOfURL: $0) as? AppExtensionMessageContent }
      handler(userInfo)
    }
  }
  
  func _checkAndCreateUserInfoDir(dir: NSURL) {
    let fm = NSFileManager()
    let dirExists: Bool = {
      var isDir = ObjCBool(true)
      let e = fm.fileExistsAtPath(dir.path!, isDirectory: &isDir)
      if !isDir.boolValue {
        try! fm.removeItemAtURL(dir)
        return false
      }
      
      return e
    }()
    
    if !dirExists {
      try! fm.createDirectoryAtURL(dir, withIntermediateDirectories: true, attributes: nil)
    }
  }
  
}


private func _callback(center: CFNotificationCenter!, observer: UnsafeMutablePointer<()>, notiName: CFString!, obj: UnsafePointer<()>, userInfo: CFDictionary!) -> () {
  let communicator = unsafeBitCast(observer, AppExtensionCommunicator.self)
  let name = notiName as String
  communicator._handleNotificationCallbackWithName(name)
}
