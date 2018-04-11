//
//  FrontViewController.m
//  KTBeaconApp
//
//  Created by nami0342 on 2015. 3. 5..
//  Copyright (c) 2015년 unus. All rights reserved.
//

#import "FrontViewController.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "Util.h"


@import CoreLocation;

@interface FrontViewController () <UIPickerViewDataSource, UIPickerViewDelegate , CLLocationManagerDelegate,UIWebViewDelegate >

@property (nonatomic, strong) NSMutableArray        *m_arReturnList;
@property (nonatomic, strong) NSMutableArray        *m_arOrderList;
@property (nonatomic, readwrite) NSInteger          m_iSelected;
@property (nonatomic, readwrite) NSInteger          m_iLinecount;
@property (nonatomic, readwrite) NSString*          m_deviceToken;

@property (nonatomic) BOOL isPrivacyAllow;
@property (nonatomic) BOOL isLocationAllow;


@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FrontViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<  viewDidLoad    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    
    //웹뷰설정
    self.webView.delegate = self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Constants" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *url = [dict objectForKey:@"GOTO_OIL_URL"];
    
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [self.webView loadRequest:request];
    NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<  viewDidLoad    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> %@ ", nsUrl);
    //웹뷰 설정 끝
    
    self.isPrivacyAllow = YES;
    self.isLocationAllow= YES;
    
    AppDelegate* apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(self.m_arReturnList == nil)
    {
        self.m_arReturnList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    if([self.m_arReturnList count] == 0)
    {
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"key", @"FAIL", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"key", @"SUCCESS", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"2", @"key", @"LISENCE_INVALID", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"3", @"key", @"NO_DELEGATE_OR_LICESE", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"4", @"key", @"NO_DELEGATE", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"9", @"key", @"NETWORK_ERROR", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"10", @"key", @"ETC", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"13", @"key", @"LOCAL_PUSH_WITH_CALLBACK_ON", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"14", @"key", @"LOCAL_PUSH_WITH_CALLBACK_OFF", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"15", @"key", @"LOCAL_PUSH_OFF", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"50", @"key", @"BLUETOOTH_ON", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"51", @"key", @"BLUETOOTH_OFF", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"52", @"key", @"LOCATION_ON", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"53", @"key", @"LOCATION_OFF", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"54", @"key", @"PUSH_NOTI_ON", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"55", @"key", @"PUSH_NOTI_OFF", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"60", @"key", @"PRIVACY_DENIED", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"61", @"key", @"LOCATTION_DENIED", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"62", @"key", @"PRIVACY_LOCATION_DENIED", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"100", @"key", @"PLATFORM_APP_AUTH_FAIL", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"101", @"key", @"PLATFORM_DEVICE_ID_REQUIRED", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"102", @"key", @"PLATFORM_INTERFACE_NOT_FOUND", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"103", @"key", @"PLATFORM_INTERNAL_ERROR", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"104", @"key", @"PLATFORM_SDK_UPGRADE_REQUIRED", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"105", @"key", @"PLATFORM_AGENT_UPGRADE_REQUIRED", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"200", @"key", @"PLATFORM_NOT_KT_BEACON", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"201", @"key", @"PLATFORM_IMSI_TOKEN_INVALID", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"202", @"key", @"PLATFORM_ACCESS_TOKEN_INVALID", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"203", @"key", @"PLATFORM_ACCESS_TOKEN_EXPIRE", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"900", @"key", @"OS_LOW", @"desc", nil]];
        [self.m_arReturnList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"999", @"key", @"FOUND_BEACON", @"desc", nil]];
        
    }
    
    
    
    if(self.m_arOrderList == nil)
    {
        self.m_arOrderList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    if([self.m_arOrderList count] == 0)
    {
        [self.m_arOrderList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"13", @"key", @"BG_LOCAL_PUSH_WITH_CALLBACK_ON", @"desc", nil]];
        [self.m_arOrderList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"14", @"key", @"BG_LOCAL_PUSH_WITH_CALLBACK_OFF", @"desc", nil]];
        [self.m_arOrderList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"15", @"key", @"_BG_LOCAL_PUSH_OFF", @"desc", nil]];
        [self.m_arOrderList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"40", @"key", @"MONITORING_DETECT_EVERYONE", @"desc", nil]];
        [self.m_arOrderList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"41", @"key", @"MONITORING_DETECT_STRONGEST", @"desc", nil]];
        [self.m_arOrderList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"50", @"key", @"NO_REQUIRED_LEAVE_EVENT", @"desc", nil]];
        
        [self.m_arOrderList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"90", @"key", @"TEST_MODE_ON", @"desc", nil]];
        [self.m_arOrderList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"91", @"key", @"TEST_MODE_OFF", @"desc", nil]];
    }
    
    
    self.m_msServerRequest = [[NSMutableString alloc] initWithString:@""];
    self.m_msServerResponse = [[NSMutableString alloc] initWithString:@""];
    self.m_msSDKResponse = [[NSMutableString alloc] initWithString:@""];
    
    
    [self addServerRequestLog:@""];
    [self addServerResponseLog:@""];
    [self addSDKResponseLog:0 Log:@""];
    
    
    /**/
    ////////////////// 제휴사 App 추가 code ////////////////////////////////////////////////////////////////
    // iPhone4 판단
    BOOL isAvailable_BLE = YES;
    NSString *strModel = [UIDevice currentDevice].model;
    if ([strModel isEqualToString:@"iPhone3,1"])
    {
        // BLE 미지원 단말
        isAvailable_BLE = NO;
    }
    if ([strModel isEqualToString:@"iPhone3,3"])
    {
        // BLE 미지원 단말
        isAvailable_BLE = NO;
    }
    // 사용자 동의를 기존에 받았다면 비콘 모니터링을 시작 처리 * (메인 뷰 init 함수에 있어야 한다.) *. 앱이 시스템에 의해 시작될 경우 여기까지 메모리가 로드되므로 여기에 추가
    //@" %s", BOOL_VAL ? "true" : "false"
    //    [self.view makeToast:[NSString stringWithFormat:@"isAgreeAllPrivacy : %@" , [self isAgreeAllPrivacy]?@"true":@"false"  ]];
    //    [self.view makeToast:[NSString stringWithFormat:@"isAvailable_BLE : %@" , isAvailable_BLE?@"true":@"false"  ]];
    //    if([self isAgreeAllPrivacy] == YES && isAvailable_BLE == YES)
    if(isAvailable_BLE == YES)
    {
        //        [self performSelector:@selector(startMonitoring) withObject:nil afterDelay:2.0f];
        //        [self.view makeToast:@"테스트"];
    }else{
        //        [self.view makeToast:@"테스트2"];
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) viewDidAppear:(BOOL)animated
{
    
}


////////////////// 제휴사 App 추가 code ////////////////////////////////////////////////////////////////
// 사용자가 위치동의 및 개인정보 이용 동의한지 체크
//- (BOOL) isAgreeAllPrivacy
//{
//    // 2가지 모두 동의했을 경우
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *strAllAgree = [userDefaults objectForKey:@"All_Agreement"];
//
//    [self.view makeToast:[NSString stringWithFormat:@"strAllAgree : %@" , strAllAgree]];
//
//    if([strAllAgree isEqualToString:@"2"] == YES)
//        return YES;
//
//    return NO;
//}


////////////////// 제휴사 App 추가 code ////////////////////////////////////////////////////////////////
// 비콘 모니터링 시작
// 위치동의 및 개인정보동의 2가지 다 허용될 경우 모니터링 함수를 호출하여 시작.
- (void) startMonitoring
{
    API_RETURN_CODE retCode;
    
    if ( self.isLocationAllow ) {
        [self.m_appApi Geofence_setAPI:API_ORDER_GPS_CAMPAIGN_ENABLE];
    }
    
    
    // 블루투스 체크
    retCode = [self.m_appApi Geofence_setAPI:API_ORDER_DEVICE_STATUS_BLUETOOTH];
    if (retCode == API_RETURN_CODE_BLUETOOTH_OFF)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.view makeToast:@"블루투스 동작하지 않음"];
        });
    }
    
    
    retCode = [self.m_appApi Geofence_startMonitoring:self.isPrivacyAllow locationService:self.isLocationAllow];
    
    if (retCode == API_RETURN_CODE_SUCCESS)
    {
        
        // 성공 시 UI 변경이 필요할 경우 dispatch_async를 통해 UI를 상태를 변경한다.
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.view makeToast:@"성공"];
        });
    }
    else
    {
        // 실패 시 UI 변경이 필요한 경우 dispatch_async를 통해 UI 상태를 변경한다.
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.view makeToast:@"실패"];
        });
        
        // 모니터링 실패일 경우 에러 처리
        NSLog(@"Error code : %d", retCode);
        
        
        switch (retCode) {
                
                // 인증 실패
            case API_RETURN_PLATFORM_APP_AUTH_FAIL:
                break;
                
                // 인증 실패
            case API_RETURN_CODE_LISENCE_INVALID:
                break;
                
                // 네트워크 에러 : 최초 인증시 네트워크 에러로 인한 실패
            case API_RETURN_CODE_NETWORK_ERROR:
                break;
                
                // 블루투스 장치 Off
            case API_RETURN_CODE_BLUETOOTH_OFF:
                break;
                
                // 위치 정보 서비스 Off
            case API_RETURN_CODE_LOCATION_OFF:
                break;
                
                // 단말 OS 버전이 낮음 (7.0 이하)
            case API_RETURN_CODE_OS_LOW:
                break;
                
                // 기타 리턴 코드 항목은 API_Protocol.h 참조
            default:
                break;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self.view makeToast:[self getReturnCodeDescription:retCode]];
    });
}
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)setCampaignMessage:(NSString *)message {
//    self.m_lbReturnCode.text = message;
//}

- (void) updateVzone:(NSString *)vzoneCntMessage
{
    if (vzoneCntMessage.length>0) {
        //        self.responseLabel.text = [NSString stringWithFormat:@"서버 응답:%@", vzoneCntMessage];
    }
}

- (void) setDeviceToken:(NSString *)deviceToken{
    
    self.m_deviceToken = deviceToken;
    NSLog(@"deviceToken:%@", deviceToken);
}

#pragma mark

- (IBAction)click_clearLog:(id)sender {
    self.logText.text = @"";
    //    [self webViewAlert: @"ddd"];
}

- (void) addServerRequestLog : (NSString *) strLog
{
    [self.m_msServerRequest appendString:@"\n"];
    [self.m_msServerRequest appendString:strLog];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self.m_tvServerRequest setText:self.m_msServerRequest];
    });
}


- (void) addServerResponseLog : (NSString *) strLog
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Constants" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *date = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *now = [NSDate date];
    [formatter setDateFormat:@"[yyyy-MM-dd hh:mm:ss]"];
    date = [formatter stringFromDate:now];
    
    NSLog(@"%@", date);
    
    if ([strLog rangeOfString:@"Enter"].location != NSNotFound
        || [strLog rangeOfString:@"Leave"].location != NSNotFound
        || [strLog rangeOfString:@"RemoteNotification"].location != NSNotFound
        
        ) {
        [self.m_msServerResponse appendString:@"\n"];
        
        [self.m_msServerResponse appendString:date];
        //[self.m_msServerResponse appendString:strLog];
        if([strLog rangeOfString:@"Enter"].location != NSNotFound){
            [self.m_msServerResponse appendString:@"Enter"];
            [self gotoUrl:self.webView getUrl:[[dict objectForKey:@"GOTO_OIL_URL"] stringByAppendingString: [dict objectForKey:@"GOTO_MAIN_SALE"]] ]; // 페이지 이동
        }else if([strLog rangeOfString:@"Leave"].location != NSNotFound){
            [self.m_msServerResponse appendString:@"Leave"];
        }else if([strLog rangeOfString:@"Notification"].location != NSNotFound){
            [self.m_msServerResponse appendString:@"Notification"];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([strLog rangeOfString:@"Enter"].location != NSNotFound || [strLog rangeOfString:@"Leave"].location != NSNotFound) {
            [self.logText setText:self.m_msServerResponse];
        }
        //[self.view makeToast:[NSString stringWithFormat:@"ServerResponse : %@" , self.m_msServerResponse]];
    });
}


- (void) addSDKResponseLog : (int) retcode Log:(NSString *) strLog
{
    if(retcode == API_RETURN_CODE_FOUND_BEACON)
    {
        
        if ( strLog ){
            [self.m_msSDKResponse appendString:strLog];
            [self.m_msSDKResponse appendString:@"\n"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
        
        return;
    }
    
    [self.m_msSDKResponse appendString:@"\n"];
    [self.m_msSDKResponse appendString:[self getReturnCodeDescription:retcode]];
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}


#pragma mark

-(void) scrollToBottom : (UITextView *) textView
{
    CGPoint p = [textView contentOffset];
    //    tv.text = [NSString stringWithFormat:@"%@\n%@", tv.text, @"New line"];
    [textView setContentOffset:p animated:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
    });
}


#pragma mark
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.m_arOrderList count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strTitle = [NSString stringWithFormat:@"%@) %@", [[self.m_arOrderList objectAtIndex:row] objectForKey:@"key"], [[self.m_arOrderList objectAtIndex:row] objectForKey:@"desc"]];
    return strTitle;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.m_iSelected = row;
    
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    label.text = [NSString stringWithFormat:@"%@", [[self.m_arOrderList objectAtIndex:row] objectForKey:@"desc"]];
    return label;
}

#pragma mark -
#pragma private methods

- (NSString *)getReturnCodeDescription:(API_RETURN_CODE)returnCode
{
    NSString *codeString = [NSString stringWithFormat:@"%d",returnCode];
    NSString *codeDescription = @"";
    
    for(NSDictionary *dicItem in self.m_arReturnList)
    {
        if([[dicItem objectForKey:@"key"] isEqualToString:codeString] == YES)
        {
            codeDescription = [NSString stringWithFormat:@"%@) %@", [dicItem objectForKey:@"key"], [dicItem objectForKey:@"desc"]];
            break;
        }
    }
    
    return codeDescription;
}

// 메서드 (webview 인스턴스 객체, 이동시킬 url주소)
- (void)gotoUrl:(UIWebView*)view getUrl:(NSString*)getUrl
{
    NSURL *url = [NSURL URLWithString:getUrl];
    [view loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma webview의 자바스크립트에서 호출되는 함수 설정
//url스킴에 jscall:을 포함한 경우에는 해당 메소드를 찾아서 실행시킴
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] absoluteString] hasPrefix:@"jscall:"]) {
        
        NSString *requestString = [[request URL] absoluteString];
        NSArray *components = [requestString componentsSeparatedByString:@"://"];
        NSString *functionName = [components objectAtIndex:1];
        
        NSLog(@"function name : %@", functionName);
        [self performSelector:NSSelectorFromString(functionName)];
        
        return NO;
    }
    
    return YES;
}

//기기정보를 전달함 웹뷰로 전달
- (void)callDeviceInfo {
    //FCM 등록 id 전달
    NSLog(@"callDeviceInfo %@ ", self.m_deviceToken);
    
    NSString *deviceToken = self.m_deviceToken;
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSInteger badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSString *scriptString = [NSString stringWithFormat:@"callClientInfo('%@','%@','%ld')", token, @"ios", badgeCount];
    
    //    NSString *scriptString = [NSString stringWithFormat:@"callClientInfo('%@','%@')", token, @"ios"];
    [self.webView stringByEvaluatingJavaScriptFromString:scriptString];
    
}

//위치정보 서버로 웹뷰로 전달
- (void)callLocationInfo {
    // Location Manager 생성
    self.locationManager = [[CLLocationManager alloc] init];
    // Location Receiver 콜백에 대한 delegate 설정
    self.locationManager.delegate = self;
    // 사용중에만 위치 정보 요청
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    // Location Manager 시작하기
    [self.locationManager startUpdatingLocation];
    
    float latitude = fabs(self.locationManager.location.coordinate.latitude);
    float longitude = fabs(self.locationManager.location.coordinate.longitude);
    
    // Location Manager 끝내기
    [self.locationManager stopUpdatingLocation];
    
    NSString *scriptString = [NSString stringWithFormat:@"setLocation('%f','%f')", latitude, longitude];
    [self.webView stringByEvaluatingJavaScriptFromString:scriptString];
}

//파일 다운로드 시
- (void) callDownloadFile{
    NSString *scriptString = [NSString stringWithFormat:@"downloadFile()"];
    [self.webView stringByEvaluatingJavaScriptFromString:scriptString];
}

//자동로그인 체크 시
- (void) setAutoLoginYes{
    //?
}

//자동로그인 취소
- (void) setAutoLoginNo{
    //removeSessionCookie
    //removeCookieAll
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void) resetBadge{
    //badge 초기화
    NSLog(@"resetBadge");
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void) webViewAlert:(NSString *)message{
    //    NSString *scriptString = [NSString stringWithFormat:@"iOSAlert('%@')", message];
    NSString *scriptString = [NSString stringWithFormat:@"alert('%@')", message];
    [self.webView stringByEvaluatingJavaScriptFromString:scriptString];
}
@end

