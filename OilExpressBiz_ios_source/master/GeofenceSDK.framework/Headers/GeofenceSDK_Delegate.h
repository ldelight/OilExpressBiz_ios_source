//
//  GeofenceSDK_Delegate.h
//  GigaBeaconSDK
//
//  Created by dkitec on 2015. 1. 28..
//  Copyright (c) 2015년 dkitec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API_Protocol.h"

typedef enum {
    CALLBACK_TYPE_SET_REGISTRATIOIN_ID , // { [@"CODE" , NSNubmer API_RETURN_CODE] , [VALUE , @"registrationid"]}
    CALLBACK_TYPE_SET_PUSH_RECEIVE , // { [@"CODE" , NSNubmer API_RETURN_CODE] , [VALUE , @"Y" or @"N"]}
    CALLBACK_TYPE_SET_LOCATION_SERVICE,// { [@"CODE" , NSNubmer API_RETURN_CODE] , [VALUE , @"Y" or @"N"]}
    CALLBACK_TYPE_SET_PRIVACY_POLICY ,// { [@"CODE" , NSNubmer API_RETURN_CODE] , [VALUE , @"Y" or @"N"]}

} CALLBACK_TYPE ;

@class ObjEventData;

@protocol GeofenceSDK_Delegate <NSObject>
@required
/// @brief GiGABeacon 이벤트 데이터
- (void)callback_GeofenceSDK:(ObjEventData *)eventInfo;

@optional

/// @breif
///
- (void)callback_handler:(CALLBACK_TYPE)ct withData:(NSDictionary*)data;
- (void)callToastMessage:(NSString *)message isCampaign:(BOOL)isCampaign;
- (void)callAlertMessage:(NSString *)message;

@end



