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

public typealias AppExtensionMessageHandler = (AppExtensionMessage?) -> Void

public class AppExtensionCommunicator {
  
  let containerURL: URL
  
  /// `containerURL` Application group container directory, usually you can get it by `containerURLForSecurityApplicationGroupIdentifier` of `NSFileManager`
  public init(containerURL theURL: URL) {
    containerURL = theURL
    _userInfoDir = containerURL.appendingPathComponent(".AppExtensionCommunicator", isDirectory: true)
    _checkAndCreateUserInfoDir()
  }
  
  deinit {
    let center = CFNotificationCenterGetDarwinNotifyCenter()
    CFNotificationCenterRemoveEveryObserver(center, unsafeBitCast(self, to: UnsafeRawPointer.self))
  }
  
  /// Deliver `message` with `identifier`
  public func deliver(message: AppExtensionMessage? = nil, withIdentifier identifier: String) {
    let target = _userInfoDir.appendingPathComponent(identifier)
    if let info = message as? NSDictionary {
      try? info.write(to: target)
    } else {
      try? FileManager().removeItem(at: target)
    }
    
    let center = CFNotificationCenterGetDarwinNotifyCenter()
    let identifierCF = CFNotificationName(identifier as CFString)
    CFNotificationCenterPostNotification(center, identifierCF, nil, nil, true)
  }
  
  /// observe message with `identifier` using `messageHandler`
  public func observeMessage(forIdentifier identifier: String, usingHandler messageHandler: @escaping AppExtensionMessageHandler) {
    if _registeredHandlers[identifier] == nil {
      addObserverWithNameForDarwinNotifyCenter(unsafeBitCast(self, to: UnsafeRawPointer.self), identifier)
    }
    
    _registeredHandlers[identifier] = messageHandler
  }
  
  // MARK: private properties
  
  private let _userInfoDir: URL
  
  private lazy var _registeredHandlers = [String: AppExtensionMessageHandler]()
  
}

// MARK: private methods
private extension AppExtensionCommunicator {
  
  @objc func _handleNotificationCallbackWithName(_ name: String) {
    if let handler = _registeredHandlers[name] {
      let target = _userInfoDir.appendingPathComponent(name)
      let userInfo = NSDictionary(contentsOf: target) as? AppExtensionMessage
      handler(userInfo)
    }
  }
  
  func _checkAndCreateUserInfoDir() {
    let fm = FileManager()
    let dirExists: Bool = {
      var isDir = ObjCBool(true)
      let e = fm.fileExists(atPath: self._userInfoDir.path, isDirectory: &isDir)
      if !isDir.boolValue {
        try? fm.removeItem(at: self._userInfoDir)
        return false
      }
      
      return e
      }()
    
    if !dirExists {
      try? fm.createDirectory(at: _userInfoDir, withIntermediateDirectories: true)
    }
  }
}
