//
//  API_Protocol.h
//  KTBeaconSDK
//
//  Created by dkitec on 2015. 1. 9..
//  Copyright (c) 2015년 dkitec. All rights reserved.
//

#ifndef KTBeaconSDK_API_Protocol_h
#define KTBeaconSDK_API_Protocol_h

typedef enum {
    API_RETURN_CODE_FAIL                        = 0,    // 실패
    API_RETURN_CODE_SUCCESS                     = 1,    // 성공
    API_RETURN_CODE_LISENCE_INVALID             = 2,    // 제휴사 라이센스 키 오류
    API_RETURN_CODE_NO_DELEGATE_OR_LICESE       = 3,    // 제휴사 라이센스 키 미 입력 및 AppDelegate 객체 미 입력
    API_RETURN_CODE_NO_DELEGATE                 = 4,    // 제휴사 Appdelegate가 없음 (필수 값)
    API_RETURN_CODE_NETWORK_ERROR               = 9,    // 네트워트 연결 실패
    API_RETURN_CODE_ETC                         = 10,   // 알수없는 에러
    
    API_RETURN_LOCAL_PUSH_WITH_CALLBACK_ON      = 13,   // 로컬 푸시와 call back을 동시 전송 ON   : SDK -> App  (Local push + delegate call back)
    API_RETURN_LOCAL_PUSH_WITH_CALLBACK_OFF     = 14,   // 로컬 푸쉬만 전송                     : SDK -> App  (Local push only)
    API_RETURN_LOCAL_PUSH_OFF                   = 15,   // 로컬 푸쉬 전송 중지                   : SDK -x-> App  (기본)
    
    API_RETURN_CODE_BLUETOOTH_ON                = 50,   // 단말 블루투스 장치 ON    (내부용)
    API_RETURN_CODE_BLUETOOTH_OFF               = 51,   // 단말 블루투스 장치 OFF
    API_RETURN_CODE_LOCATION_ON                 = 52,   // 위치 정보 사용 가능 - ON (내부용)
    API_RETURN_CODE_LOCATION_OFF                = 53,   // 위치 정보 사용 불가 - 사용자가 위치 정보 사용 거부 or 꺼짐 - OFF
    API_RETURN_CODE_PUSH_NOTI_ON                = 54,   // push noti 이용 ON    (내부용)
    API_RETURN_CODE_PUSH_NOTI_OFF               = 55,   // push noti 이용 OFF
    
    API_RETURN_CODE_PRIVACY_DENIED              = 60,   // 제휴사에서 개인정보보호동의 거부        (하나라도 거부되면 SDK 동작 안함)
    API_RETURN_CODE_LOCATTION_DENIED            = 61,   // 제휴사에서 위치 동의 거부
    API_RETURN_CODE_PRIVACY_LOCATION_DENIED     = 62,   // 제휴사에서 개인정보, 위치정보 둘다 거부
    
    // 고주파
    API_RETURN_CODE_HIGHFREQ_ALREADY_SHAKE_DETECTING            = 70,   // 이미 Shake 감지 중
    API_RETURN_CODE_HIGHFREQ_MIC_IN_USE                         = 71,   // 마이크 사용 중
    API_RETURN_CODE_HIGHFREQ_INVALID_SOUND                      = 72,   // 음원에 문제가 있음
    API_RETURN_CODE_HIGHFREQ_NOT_DETECTED                       = 73,   // 고주파 감지 안됨
    API_RETURN_CODE_HIGHFREQ_RECORD_PERMISSION_NOT_GRANTED      = 74,   // 마이크 사용 권한 없음
    API_RETURN_CODE_HIGHFREQ_ETC_ERROR                          = 75,   // 단말에 모션 센서 지원 안됨 등등

    // Flatform - response
    API_RETURN_PLATFORM_APP_AUTH_FAIL           = 100,  // 앱 인증에 실패하였습니다.
    API_RETURN_PLATFORM_DEVICE_ID_REQUIRED      = 101,  // 단말ID가 누락되었습니다
    API_RETURN_PLATFORM_INTERFACE_NOT_FOUND     = 102,  // 요청하신 인터페이스가 존재하지 않습니다.
    API_RETURN_PLATFORM_INTERNAL_ERROR          = 103,  // 처리 중 오류가 발생하였습니다.
    API_RETURN_PLATFORM_SDK_UPGRADE_REQUIRED    = 104,  // 하위 버전의 SDK를 사용하고 있습니다. SDK를 UPGRADE 해주세요
    API_RETURN_PLATFORM_AGENT_UPGRADE_REQUIRED  = 105,  // 하위 버전의 Agent를 사용하고 있습니다. Agent를 UPGRADE 해주세요
    
    
    // Flatform - access token (SDK 내부 사용용)
    API_RETURN_PLATFORM_NOT_KT_BEACON           = 200,  // 존재하지 않는 비콘입니다.
    API_RETURN_PLATFORM_IMSI_TOKEN_INVALID      = 201,  // 임시 Token이 유효하지 않습니다.
    API_RETURN_PLATFORM_ACCESS_TOKEN_INVALID    = 202,  // Access Token이 유효하지 않습니다.
    API_RETURN_PLATFORM_ACCESS_TOKEN_EXPIRE     = 203,  // 일정 시간이 경과하여 Access Token이 폐기되었습니다.
    
    API_RETURN_CODE_OS_LOW                      = 900,  // 제휴사 OS 버전이 7.0 이하일 경우 동작 안함.
    API_RETURN_CODE_FOUND_BEACON                = 999,   // 비콘 인식 됨.
    
    API_RETURN_CODE_NO_CAMPAIGN                 = -9999     // 캠페인이 없음
    
} API_RETURN_CODE;

typedef enum {
    API_ORDER_RESERVED                          = 0,
    API_ORDER_MONITORING_ON                     = 10,   // 비콘 모니터링 시작 (기본)
    API_ORDER_MONITORING_OFF                    = 11,   // 비콘 모니터링 중지
    API_ORDER_RESERVED_ANDROID                  = 12,   // 시스템 예약 (사용 안함)
    
    API_ORDER_IN_BG_LOCAL_PUSH_WITH_CALLBACK_ON = 13,   // 백그라운드 상태에서 로컬 푸시와 call back을 동시 전송 ON   : SDK -> App  (Local push + delegate call back)
    API_ORDER_IN_BG_LOCAL_PUSH_WITH_CALLBACK_OFF= 14,   // 백그라운드 상태에서 로컬 푸쉬만 전송                     : SDK -> App  (Local push only)
    API_ORDER_IN_BG_LOCAL_PUSH_OFF              = 15,   // 백그라운드 상태에서 로컬 푸쉬 전송 중지                   : SDK -x-> App  (기본)
    
    API_ORDER_STATUS_FOREGROUND                 = 20,   // 제휴사 app이 Foreground 상태임을 SDK 알림
    API_ORDER_STATUS_BACKGROUND                 = 21,   // 제휴사 app이 Backgournd 상태임을 SDK에게 알림
    
    API_ORDER_MONITORING_CONDITION_START        = 30,   // Background 동작시 설정에 따라 모니터링을 동작 / 중지 처리
    
    API_ORDER_MONITORING_DETECT_EVERYONE        = 40,   // 신호가 여러 개 일 경우 인식된 모든 신호를 처리
    API_ORDER_MONITORING_DETECT_STRONGEST       = 41,   // 신호가 여러 개 일 경우 가장 신호가 센 비콘을 인식
    
    API_ORDER_NO_REQUIRED_LEAVE_EVENT           = 50,   // Leave event 가 필요 없을 때, 설정
    
    API_ORDER_SIGNAL_FILTERING_ENABLE           = 60,   // 신호세기 제한 설정 (의미 없이 약한 신호 필터링)
    API_ORDER_SIGNAL_FILTERING_DISABLE          = 61,   // 신호세기 제한 해제
    //[20151014][탁권형] 테스트 단말 기능 추가
    API_ORDER_REGISTER_TEST_DEVICE              = 70,   // 테스트 단말 등록
    
    API_ORDER_PRIVACY_POLICY_NO                 = 80,   // 개인정보약관거부
    API_ORDER_PRIVACY_POLICY_YES                = 81,   // 개인정보약관동의
    API_ORDER_LOCATION_SERVICE_NO               = 82,   // 위치서비스거부
    API_ORDER_LOCATION_SERVICE_YES              = 83,   // 위치서비스동의
    
    //[20151116][탁권형] 푸시수신 동의 여부
    API_ORDER_PUSH_RECEIVE_YES                  = 84,   // 푸쉬 수신 활성화
    API_ORDER_PUSH_RECEIVE_NO                   = 85,   // 푸쉬 수신 비활성화
    
    //[20151112][탁권형] 지오펜싱기반 기능
    API_ORDER_GPS_CAMPAIGN_ENABLE               = 88 ,  // GPS 기반 이벤트 기능 동작
    API_ORDER_GPS_CAMPAIGN_DISABLE              = 89 ,  // GPS 기반 이벤트 기능 해제
    
    API_ORDER_TEST_MODE_ON                      = 90,   // 테스트 명령, 비콘 인식 인식된 비콘만큼 고정된 테스트 이벤트 정보를 제휴사로 전달.
    API_ORDER_TEST_MODE_OFF                     = 91,   // 테스트 명령 중지, 비콘 인식시 릴리즈 상태로 처리 됨.
    
    //[20160420][탁권형] 앱 인증여부 확인
    //API_ORDER_IS_INITIALIZED                    = 92,   // 앱 인증 확인 용도
    
    //[20160420][탁권형] 로그인 재수행
    API_ORDER_LOGIN                             = 93,
    //API_ORDER_LOGOUT                            = 94,
    
//    API_DOWNLOAD_CAMPAIGN_LIST                  = 94,
//    API_DOWNLOAD_WIFI_LIST                      = 95,
    
    
    API_ORDER_WIFI_CAMPAIGN_ENABLE              = 96 ,  // WIFI 기반 이벤트 기능 동작
    API_ORDER_WIFI_CAMPAIGN_DISABLE             = 97 ,  // WIFI 기반 이벤트 기능 해제
    
    
    API_ORDER_FOUND_EVENT_BEACON                = 100,  // 이벤트 정보 ( 보통 추가정보와 함께 전달 됨 - objEventData 의 배열 형태)
    API_ORDER_DEVICE_STATUS                     = 900,  // 디바이스 상태 정보 (SDK 내부 사용용)
    API_ORDER_DEVICE_STATUS_MONITORING          = 901,  // 모니터링 상태
    API_ORDER_DEVICDE_STATUS_PUSH_SETTING       = 902,  // 푸쉬 세팅 상태
    
    API_ORDER_DEVICE_STATUS_BLUETOOTH           = 903,  // Bluetooth 상태
    API_ORDER_DEVICE_STATUS_LOCATION            = 904,  // Location service enable 상태

    API_ORDER_REQUEST_USER_LOCATION             = 905,  // 사용자에 의한 위/경도 정보 요청

    API_ORDER_REQUEST_USER_CAMPAIGN             = 906,  // 사용자에 의한 campaign 체크 요청
    
    API_ORDER_REQUEST_SHAKE_START               = 910,  // Shake 감지 시작
    API_ORDER_REQUEST_SHAKE_STOP                = 911,  // Shake 감지 중지

    API_ORDER_REQUEST_RESET                     = 1000  //
    
} API_ORDER_CODE;

#endif
