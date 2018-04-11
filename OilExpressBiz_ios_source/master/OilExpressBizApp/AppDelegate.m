//
//  AppDelegate.m
//  KTBeaconApp
//
//  Created by suhyang i on 2015. 2. 4..
//  Copyright (c) 2015년 unus. All rights reserved.
//

#import "AppDelegate.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/sysctl.h>
#import "Common.h"
#import "UIView+Toast.h"
#import "FrontViewController.h"

// for iOS 10
@import UserNotifications;

@interface AppDelegate () // <UNUserNotificationCenterDelegate>

@property (nonatomic,strong) NSString* noitMessage;
@property (nonatomic,strong) NSString * apnsToken;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self.m_vcFront addServerResponseLog:@"test test"];
    
    //API에 설정 키값 설정
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Constants" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *clientId = [dict objectForKey:@"CLIENT_ID"];
    NSString *secretId = [dict objectForKey:@"SECRET_ID"];

    // Local noti : 제휴사 app에 추가
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
                                                                             (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    
    // for iOS 10
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
    
    // Remote push noti : 현재 이용 불가능
    if (YES) {
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
                                                                                 (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
    } else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    
    //
    // Local push noti를 클릭해서 앱이 실행된 경우 처리 : 제휴사 app에 추가
    //
    if (launchOptions) {
        UILocalNotification *localnoti = nil;
        localnoti = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        
        if(localnoti != nil) {
            NSLog(@"Local push noti를 클릭해서 앱이 실행된 경우 처리");
            [self application:application didReceiveLocalNotification:localnoti];
            // 페이지 이동
            [self.m_vcFront gotoUrl:self.m_vcFront.webView getUrl:[[dict objectForKey:@"GOTO_OIL_URL"] stringByAppendingString: [dict objectForKey:@"GOTO_MAIN_SALE"]] ];
        }
        
        // Remote push noti를 클릭해서 앱이 실행된 경우 해당 정보를 전달
        NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo!= nil) {
            NSLog(@"Remote push noti를 클릭해서 앱이 실행된 경우");
            [self application:application didReceiveRemoteNotification:userInfo];
            // 페이지 이동
            [self.m_vcFront gotoUrl:self.m_vcFront.webView getUrl:[[dict objectForKey:@"GOTO_OIL_URL"] stringByAppendingString: [dict objectForKey:@"GOTO_MAIN_SALE"]]];
        }
    }
    
    // iPhone4 판단(블루투스 사용가능 단말 체크) : 제휴사 app에 추가
    BOOL isAvailable_BLE = YES;
    NSString *deviceModel = [UIDevice currentDevice].model;
    if ([deviceModel isEqualToString:@"iPhone3,1"] || [deviceModel isEqualToString:@"iPhone3,3"]) {
        isAvailable_BLE  = NO;
    }
    
    // 블루투스 사용가능시 처리(SDK 초기화 및 인증, registrationId를 제외한 다른 항목은 필수) : 제휴사 app에 추가
    if (isAvailable_BLE) {
        self.appAPI = [[AppAPI alloc] init];
        [self.appAPI Geofence_setNetworkTimeout:10];
        
        [self.appAPI Geofence_Init:clientId
                      clientSecret:secretId
                    registrationId:nil
                          delegate:self
                        completion:^(API_RETURN_CODE returnCode)
        {
            // 메인 뷰컨트롤러에 appAPI 멤버를 전달한다. (필수)
            [self.m_vcFront setM_appApi:self.appAPI];
                                      
            // callback과 local noti 둘다 받도록 설정, monitoring 시작
            if (returnCode == API_RETURN_CODE_SUCCESS) {
                [self.appAPI Geofence_setAPI:API_ORDER_IN_BG_LOCAL_PUSH_WITH_CALLBACK_ON];
                [self.m_vcFront startMonitoring];
            } else {
                // 초기화 실패일 경우 에러 처리
                [self handleLoginFail:returnCode];
            }
        }];
    }
    
    // Background 실행 설정
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
    }];
    
    // rootViewController 설정
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.m_vcFront = [[FrontViewController alloc] initWithNibName:@"FrontViewController" bundle:nil];
    self.window.rootViewController = self.m_vcFront;
    
    [self.window makeKeyAndVisible];
    
    // 배지처리
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    UIBackgroundRefreshStatus backgroundRefreshStatus = [[UIApplication sharedApplication] backgroundRefreshStatus];
    if (backgroundRefreshStatus != UIBackgroundRefreshStatusAvailable) {
        [self.m_vcFront.view makeToast:@"Background Refresh Disabled"];
    }
    
    /**/
    //
    // LocalNoti를 통한 진입 처리
    //
    UILocalNotification *localNoti = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNoti) {
        NSDictionary *dic = localNoti.userInfo;
        if (dic) {
            
        }
    }
    
    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"performFetchWithCompletionHandler");
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // registration id 등록, 제휴사 app에 추가
    [self.appAPI Geofence_setRegistrationID:[NSString stringWithFormat:@"%@" , deviceToken]];
    
    NSLog(@"deviceToken 111 :%@", deviceToken);
    
    // 테스트앱 로그용도
    [self.m_vcFront addServerResponseLog:[NSString stringWithFormat:@"%@" , deviceToken]];
    if ( self.noitMessage ) {
        [self.m_vcFront addServerResponseLog:self.noitMessage];
    }
    self.apnsToken = [NSString stringWithFormat:@"%@" , deviceToken];
    [self.m_vcFront setDeviceToken:[NSString stringWithFormat:@"%@" , deviceToken]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 제휴사 app이 Backgournd 상태임을 SDK에게 알림, 제휴사 app에 추가
    [self.appAPI Geofence_setAPI:API_ORDER_STATUS_BACKGROUND];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 제휴사 app이 Foreground 상태임을 SDK 알림, 제휴사 app에 추가
    [self.appAPI Geofence_setAPI:API_ORDER_STATUS_FOREGROUND];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

//
// Local noti 수신시 처리
//
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if(notification.userInfo != nil && [notification.userInfo isKindOfClass:[NSNull class]] == NO) {
        ObjEventData *eventInfo = [self.appAPI geteventInfoForLocalNoti:notification];
        
        // 앱 설치 유도
        if ([eventInfo.strContentType isEqualToString:@"400"]) {
            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:eventInfo.strContentTitle
                                                            delegate:nil
                                                   cancelButtonTitle:@"취소"
                                                   otherButtonTitles:@"확인", nil];
            alert.tag = 200;
            [alert show];
            return;
        }
        
        //[self callback_responseAPI:[eventInfo description] parameter:nil];
        
        // 다른 local push 를 이용할 경우 KT Beacon용 local push 판단 방법
        if(eventInfo.strIndex != nil && [eventInfo.strIndex length] != 0) {
            NSLog(@"kt beacon local push : %@", notification);
            NSLog(@"eventdata description : %@", [eventInfo description]);
        }
        
        ////////////////// 제휴사 App 추가 code ////////////////////////////////////////////////////////////////
        // v 1.1.5
        //// Event handler of over ios8 for user action with beacon notification
        NSMutableDictionary *mdicNoti = [NSMutableDictionary dictionaryWithDictionary:notification.userInfo];
        [mdicNoti setValue:[[NSBundle mainBundle] bundleIdentifier] forKey:@"ebundle"];
        notification.userInfo = mdicNoti;
        
        // 내부 처리용
        [self.appAPI sendReactionNotificationWith:nil data:notification];
    }
}

//
// push 수신시 처리 : 현재는 사용 불가.
//
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    self.noitMessage =[NSString stringWithFormat:@"RemoteNotification :  %@" , userInfo];
    NSLog(@"!!!!!!!!!didReceiveRemoteNotification!!!!!!!!!!");
    [self.m_vcFront addServerResponseLog:self.noitMessage];
    
    
    // 앱이 실행 중일 시 알람 처리
    NSDictionary * alertDic = [userInfo objectForKey:@"aps"];
    if([alertDic count] > 0){
        NSArray* alertlist = [[alertDic objectForKey:@"alert"] componentsSeparatedByString:@"\n"];
        
        NSString * messageTitle = [alertlist objectAtIndex:0];
        NSString * messageBody = [alertlist objectAtIndex:1];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageTitle
                                                        message:messageBody
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        [alert show];
        
        //배지 처리
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: [[alertDic objectForKey:@"badge"] intValue]  ];
    }
}
  
//  for iOS 10 UNUserNotificationCenter
#pragma mark - UNUserNotificationCenterDelegate
    
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    completionHandler(UNNotificationPresentationOptionAlert);
}
    
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if(userInfo != nil && [userInfo isKindOfClass:[NSNull class]] == NO) {
        
        ObjEventData *eventInfo = [[ObjEventData alloc] initWithUserInfo:userInfo];
        
        // 앱 설치 유도
        if ([eventInfo.strContentType isEqualToString:@"400"]) {
            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:eventInfo.strContentTitle
                                                            delegate:nil
                                                   cancelButtonTitle:@"취소"
                                                   otherButtonTitles:@"확인", nil];
            alert.tag = 200;
            [alert show];
            return;
        }
        
        //[self callback_responseAPI:[eventInfo description] parameter:nil];
        
        // 다른 local push 를 이용할 경우 KT Beacon용 local push 판단 방법
        if(eventInfo.strIndex != nil && [eventInfo.strIndex length] != 0) {
            NSLog(@"eventdata description : %@", [eventInfo description]);
        }
        
        ////////////////// 제휴사 App 추가 code ////////////////////////////////////////////////////////////////
        // v 1.1.5
        //// Event handler of over ios8 for user action with beacon notification
        NSMutableDictionary *mdicNoti = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        [mdicNoti setValue:[[NSBundle mainBundle] bundleIdentifier] forKey:@"ebundle"];
        
        // 내부 처리용
        [self.appAPI sendReactionNotificationWith:nil eventInfo:mdicNoti];
    }
}
// end iOS 10 UNUserNotificationCenter

#pragma mark - GeofenceSDK_Delegate

////////////////// 제휴사 App 추가 code ////////////////////////////////////////////////////////////////
// Delegate를 통한 이벤트 수신처리 : 필수
- (void)callback_GeofenceSDK:(ObjEventData *)eventInfo {
    [self.m_vcFront addSDKResponseLog:API_RETURN_CODE_FOUND_BEACON Log:[eventInfo description]];
    //[self callback_responseAPI:[eventInfo description] parameter:nil];
    
    ////////////////// 제휴사 App 추가 code ////////////////////////////////////////////////////////////////
    // SDK 인증 오류 및 인증 만료 상태 체크 : 재 인증 전까지 동작 안하니 필수로 재인증 절차를 밟아야 함.
    if([eventInfo.strEventName isEqualToString:@"Error"] == YES)
    {
        NSString *strError = [NSString stringWithFormat:@"Error : retcode(%d) \nError code (%@)", eventInfo.retCode, eventInfo.strEventCode];
        NSLog(@"%@", strError);
        
#if VIEW_ALL_LOG
        [self.m_vcFront addSDKResponseLog:0 Log:strError];      // LOG
#endif
        ////////////////// 제휴사 App 추가 code ////////////////////////////////////////////////////////////////
        // 제휴사 App에서 재인증 절차 시행.
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        if(self.appAPI == nil) {
            // 비콘 인식 시 들어오므로 무한 재 인증 처리 안되게 처리 해야 함.
            return;
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Constants" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSString *clientId = [dict objectForKey:@"CLIENT_ID"];
        NSString *secretId = [dict objectForKey:@"SECRET_ID"];
        
        ////////////////// 제휴사 App 추가 code ////////////////////////////////////////////////////////////////
        // SDK 초기화 및 인증 (필수)
        API_RETURN_CODE returnCode = [self.appAPI Geofence_Init:clientId
                                                   clientSecret:secretId
                                                 registrationId:@"0000"
                                                       delegate:self];
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        if (returnCode != API_RETURN_CODE_SUCCESS) {
            switch (returnCode) {
                case API_RETURN_PLATFORM_APP_AUTH_FAIL: // 인증 실패
                {
                    // Monitoring 중지 - 필요 시
//                     [self.appAPI Geofence_setAPI:API_ORDER_MONITORING_OFF];
                }
                    break;
                    
                case API_RETURN_CODE_LISENCE_INVALID:   // 인증 실패
                {
                    // Monitoring 중지 - 필요 시
//                    [self.appAPI Geofence_setAPI:API_ORDER_MONITORING_OFF];
                }
                    break;
                    
                case API_RETURN_CODE_NETWORK_ERROR:     // 네트워크 에러 : 최초 인증시 네트워크 에러로 인한 실패
                    break;
                    
                case API_RETURN_CODE_BLUETOOTH_OFF:     // 블루투스 장치 Off
                    break;
                    
                case API_RETURN_CODE_LOCATION_OFF:      // 위치 정보 서비스 Off
                    break;
                    
                case API_RETURN_CODE_OS_LOW:            // 단말 OS 버전이 낮음 (7.0 이하)
                {
                    // ios 버전이 낮아 질 경우 (비 정상적인 상황)
                }
                    break;
                    // 기타 리턴 코드 항목은 API_Protocol.h 참조
                default:
                    break;
            }
        }
        return;
    }
    
    ////////////////// 제휴사 App 추가 code ////////////////////////////////////////////////////////////////
    // 수신된 이벤트 정보 처리
    // 하단은 처리 예시
    if(eventInfo != nil && [eventInfo isKindOfClass:[NSNull class]] == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = @"";
            NSString *desc    = eventInfo.desc;
            if (desc.length > 0) {
                message = [NSString stringWithFormat:@"%@ - %@ - %@ - %@", eventInfo.strContentTitle, eventInfo.enter, eventInfo.type, eventInfo.desc];
            } else {
                message = [NSString stringWithFormat:@"%@ - %@ - %@", eventInfo.strContentTitle, eventInfo.enter, eventInfo.type];
            }
            [self callToastMessage:message isCampaign:YES];
        });
    }
}

-(void)callback_handler:(CALLBACK_TYPE)ct withData:(NSDictionary *)data {
    if ( (int)ct == 0x7ffffffe ) { // Request Data
        [self callback_requestAPI:[data objectForKey:@"URL"] parameter:[data objectForKey:@"PARAM"]];
    } else if ( (int)ct == 0x7fffffff ) { /// Response Data
        [self callback_responseAPI:[data objectForKey:@"URL"] parameter:[data objectForKey:@"PARAM"]];
    } else {
        switch (ct) {
            case CALLBACK_TYPE_SET_LOCATION_SERVICE:
                [self callback_responseAPI:@"CALLBACK_TYPE_SET_LOCATION_SERVICE" parameter:data];
                NSLog( @"Location Service %@" , data );
                break;
            case CALLBACK_TYPE_SET_PRIVACY_POLICY:
                [self callback_responseAPI:@"CALLBACK_TYPE_SET_PRIVACY_POLICY" parameter:data];
                NSLog( @"Privacy Policy %@" , data );
                break;
            case CALLBACK_TYPE_SET_PUSH_RECEIVE:
                [self callback_responseAPI:@"CALLBACK_TYPE_SET_PUSH_RECEIVE" parameter:data];
                NSLog( @"Push Receive %@" , data );
                break;
            case CALLBACK_TYPE_SET_REGISTRATIOIN_ID:
                [self callback_responseAPI:@"CALLBACK_TYPE_SET_REGISTRATIOIN_ID" parameter:data];
                NSLog( @"Registration ID %@" , data );
                break;
        }
    }
}

//
// 서버 request, response 결과 콜백
//
- (void)callback_requestAPI:(NSString *)serverAPI parameter:(NSDictionary *)parameter
{
    NSString *log = @"";
    if (parameter) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:parameter];
        log = [NSString stringWithFormat:@"%@\n%@\n", serverAPI, dic];
    } else {
        log = serverAPI;
    }
    
    NSLog(@"%@", log);

    [self.m_vcFront addServerRequestLog:log];
}

- (void)callback_responseAPI:(NSString *)serverAPI parameter:(NSDictionary *)parameter
{
    NSString *log = @"";
    if (parameter) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:parameter];
        NSString *rssi = [dic objectForKey:@"rssi_range"];
        if (rssi) {
            if ([rssi isEqual:[NSNull null]]) {
                //rssi = @"-85";
            }
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                message:[NSString stringWithFormat:@"rssi 임계치 : %@", rssi]
//                                                               delegate:nil
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"확인", nil];
//                [alert show];
//            });
//            NSString *message = [NSString stringWithFormat:@"rssi 임계치 : %@", rssi];
//            [self callToastMessage:message isCampaign:YES];

        }
        
        log = [NSString stringWithFormat:@"%@\n%@\n", serverAPI, dic ? dic : @""];;
    } else {
        log = serverAPI;
    }
   
    NSLog(@"%@", log);

    [self.m_vcFront addServerResponseLog:log];
    NSLog(@"!!!!!!!!!!!!!!!!!callback_responseAPI!!!!!!!!!!!!!!!");
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/kr/app/itunes-connect/id376771144?mt=8"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - Methods

//
// 토스트 메시지 처리
//
- (void)callToastMessage:(NSString *)message isCampaign:(BOOL)isCampaign {
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.m_vcFront.view makeToast:message];
        if (isCampaign) {
//            [self.m_vcFront setCampaignMessage:message];
            NSLog(@"%@", message);
        } else {
            if ([message rangeOfString:@"vzone"].location != NSNotFound) {
                [self.m_vcFront updateVzone:message];
            }
        }
    });
}

//
// 알림창 처리
//
/*
- (void)callAlertMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        [alert show];
    });
}
*/

- (void)handleLoginFail:(API_RETURN_CODE)code {
    NSLog(@"Error code : %d", code);
    switch (code) {
        case API_RETURN_PLATFORM_APP_AUTH_FAIL:    // 인증 실패
            break;
            
        case API_RETURN_CODE_LISENCE_INVALID:      // 인증 실패
            break;
            
        case API_RETURN_CODE_NETWORK_ERROR:        // 네트워크 에러 : 최초 인증시 네트워크 에러로 인한 실패
            break;
            
        case API_RETURN_CODE_OS_LOW:               // 단말 OS 버전이 낮음 (7.0 이하)
            break;
            // 기타 리턴 코드 항목은 API_Protocol.h 참조
        default:
            break;
    }
}

@end
