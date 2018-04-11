//
//  ObjEventData.h
//  GigaBeaconSDK
//
//  Created by dkitec on 2015. 1. 30..
//  Copyright (c) 2015년 dkitec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API_Protocol.h"

@interface ObjEventData : NSObject

@property (nonatomic, readwrite) API_RETURN_CODE  retCode;      // 결과코드
@property (nonatomic, strong) NSString* strIndex;               // 이벤트 인덱스 - 현재 시간 문자열
@property (nonatomic, strong) NSString* strEventName;           // Event 이름 (@"Event" , @"Error" , @"WIZ POI")
@property (nonatomic, strong) NSString* strEventCode;           // Event 코드 (camaign_id)

@property (nonatomic, strong) NSString* strPushID;              // push id
@property (nonatomic, strong) NSString* strContentType;         // ContentType ( 0001:캠페인 400:앱설치 유도 )
@property (nonatomic, strong) NSString* strContentTitle;        // title
@property (nonatomic, strong) NSString* strContentText;         // text
@property (nonatomic, strong) NSString* strImageUrl;            // image_url
@property (nonatomic, strong) NSString* strContentUrl;          // contentUrl(landing_url)
@property (nonatomic, strong) NSString* strEtc;                 // 캠페인 설명
@property (nonatomic, strong) NSString* strPackageName;         // 패키지 이름 strContentType:400(앱설치 유도)  일때 참조
@property (nonatomic, strong) NSString* strCampaignStartDate;   // 캠페인 시작일 YYYYMMDD
@property (nonatomic, strong) NSString* strCampaignEndDate;     // 캠페인 종료일 YYYYMMDD

@property (nonatomic, strong) NSString* strPushTp;              // push type
@property (nonatomic, strong) NSString* strSaid;                // said

@property (nonatomic, strong) NSString* strLatitude;            // 위도
@property (nonatomic, strong) NSString* strLongitude;           // 경도
@property (nonatomic, strong) NSString* strOpCode;              // poi opcode
@property (nonatomic, strong) NSString* strGeneralPOI;          // 비콘 범용 poi 정보


@property (nonatomic, strong) NSString* enter;                  // enter / leave
@property (nonatomic, strong) NSString* type;                   // beacon / location/ wifi
@property (nonatomic, strong) NSString* campaign_tp;            // campaign_type : A,T,G
@property (nonatomic, strong) NSString* desc;                   // description 정보


//@property (nonatomic, strong) NSString* strPOICode;             // POI code 정보 - WIZ 용도
//@property (nonatomic, strong) NSString* strInbox;               ///< 장문 컨텐츠
//@property (nonatomic, strong) NSString* strContents;            // 컨텐츠 URL strContentType:0001 일때 참조







/*! deprecated
@property (nonatomic, strong) NSString *strAlertMessage;    
@property (nonatomic, strong) NSString *strBigText;         
@property (nonatomic, strong) NSString *strEventURL;        
@property (nonatomic, strong) NSString *strImageURL;        
@property (nonatomic, strong) NSString *strMessage;
*/

/*!
 \brief userInfo 로부터 초기화
 \param userInfo SDK 에서 전달된 UILocalNotification::userInfo
 */
-(id)initWithUserInfo:(NSDictionary*)userInfo;

/**
 \brief UILocalNotifiaction::userInfo 로 변환
 */
-(NSDictionary*) userInfoDictionary;


@end
