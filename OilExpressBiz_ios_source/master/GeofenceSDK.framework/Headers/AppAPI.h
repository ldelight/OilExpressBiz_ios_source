//
//
//  AppAPI.h
//  AppAPI
//
//  Created by dkitec on 2015. 1. 9..
//  Copyright (c) 2015년 dkitec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ObjEventData.h"
#import "API_Protocol.h"
#import "GeofenceSDK_Delegate.h"
#import "BlockDefine.h"

typedef void (^GeofenceSDKInitCompletionHandler)(API_RETURN_CODE returnCode);
typedef void (^GeoCompletionRet)(BOOL success, id result, NSError *error);

@interface AppAPI : NSObject

@property (nonatomic, weak) id<GeofenceSDK_Delegate> KTBeacon_Delegate;     // Service App delegate

// 초기화 및 인증 함수

// 동기 요청
- (API_RETURN_CODE) Geofence_Init:(NSString *)clientId         // 제휴사 id
                     clientSecret:(NSString *)clientSecret     // 제휴사 pass
                   registrationId:(NSString *)registrationId   // 제휴사 App, APNS token (없을 경우 nil)
                         delegate:(id)delegate;                // 제휴사 App, AppDelegate self 객체

// 비동기 요청
- (void)Geofence_Init:(NSString *)clientId         // 제휴사 id
         clientSecret:(NSString *)clientSecret     // 제휴사 pass
       registrationId:(NSString *)registrationId   // 제휴사 App, APNS token (없을 경우 nil)
             delegate:(id)delegate                 // 제휴사 App, AppDelegate self 객체
           completion:(GeofenceSDKInitCompletionHandler)completion;

// 모니터링 시작 함수
// 개인정보보호 동의 허용 여부 (FALSE : 거부 / TRUE : 허용)
// 위치 정보 이용 동의 여부   (FALSE : 거부 / TRUE : 허용)
- (API_RETURN_CODE) Geofence_startMonitoring : (BOOL)isPrivacyAllow locationService:(BOOL)isLocationServiceAllow;

// SDK 설정 및 요청 함수
- (API_RETURN_CODE) Geofence_setAPI : (API_ORDER_CODE) iCode;
- (void)Geofence_setAPI:(API_ORDER_CODE) code completion:(GeoCompletionRet)completion;


// SDK 내부용 UUID
- (NSString *) Geofence_getSDKUUID;




// 로컬 노티 알럿 메시지 및 사운드 On 설정
// strAlertMessage 를 설정하면 모든 로컬 노티는 해당 문구로 표시됨.
//- (API_RETURN_CODE) KTB_setLocalnotiAlert : (NSString *) strAlertMessage sound : (BOOL) isSoundOn;





// 로컬 노티 정보를 입력받아, objEventData object를 반환한다.
- (ObjEventData *) geteventInfoForLocalNoti : (UILocalNotification *) pushInfo;


// 리액션 노티피케이션 등록
- (void)sendReactionNotificationWith:(NSString *)identifier data:(UILocalNotification *)notification;
    
// 리액션 노티피케이션 등록 (iOS 10)
- (void)sendReactionNotificationWith:(NSString *)identifier eventInfo:(NSDictionary *)eventInfo;
    
/*!
 \brief device token 등록  api
 \author tk
 */
- (void) Geofence_setRegistrationID:(NSString*)regID;

/*!
 \brief remote push 처리 api
 \author tk
 */
//- (Boolean) KTB_isBeaconPushMessage:(NSDictionary*)userInfo;

/*!
 \brief 네트워크 타임아웃 설정 ( 초단위 )
 */
- (API_RETURN_CODE) Geofence_setNetworkTimeout:(NSInteger)timeoutSeconds;

/*!
 \brief 네트워크 타임아웃 설정값 조회 ( 초단위 )
 */
- (NSInteger) Geofence_getNetworkTimeout;

/*!
 \brief 초기화 여부 조회
 */
- (BOOL) Geofence_isInitialized;


//
// local noti 처리한다.
//
//- (void)handleLocalNoti:(NSDictionary *)dic show:(BOOL)show;

//- (void)callToastMessage:(NSString *)message isCampaign:(BOOL)isCampaign;
- (void)callToastMessage:(NSString *)message;
- (void)callAlertMessage:(NSString *)message;




@end

