//
//  AppDelegate.h
//  KTBeaconApp
//
//  Created by dkitec on 2015. 2. 4..
//  Copyright (c) 2015년 dkitec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GeofenceSDK/GeofenceSDK.h>
#import "Common.h"

@class FrontViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeofenceSDK_Delegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) FrontViewController *m_vcFront;

//
// 제휴사 앱에 추가
//
@property (nonatomic, strong) AppAPI *appAPI;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

