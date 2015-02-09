//
//  DarwinNotifyCenterCallback.m
//  AppExtensionCommunicator
//
//  Created by CHEN Xian’an on 2/9/15.
//  Copyright (c) 2015 CHEN Xian’an. All rights reserved.
//

#import "DarwinNotifyCenterCallback.h"
#import <Foundation/Foundation.h>

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  id aen = (__bridge id)observer;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [aen performSelector:NSSelectorFromString(@"_handleNotificationCallbackWithName:") withObject:(__bridge NSString *)name];
#pragma clang diagnostic pop
}

void addObserverWithNameForDarwinNotifyCenter(const void *observer, NSString *name) {
  CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
  CFNotificationCenterAddObserver(center, observer, notificationCallback, (__bridge CFStringRef)name, nil, CFNotificationSuspensionBehaviorDeliverImmediately);
}
