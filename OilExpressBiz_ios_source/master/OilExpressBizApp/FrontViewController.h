//
//  FrontViewController.h
//  KTBeaconApp
//
//  Created by nami0342 on 2015. 3. 5..
//  Copyright (c) 2015년 unus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import <GeofenceSDK/GeofenceSDK.h>

@interface FrontViewController : UIViewController

@property (nonatomic, strong) NSMutableString  *m_msServerRequest;
@property (nonatomic, strong) NSMutableString  *m_msServerResponse;
@property (nonatomic, strong) NSMutableString  *m_msSDKResponse;
@property (nonatomic, strong) AppAPI           *m_appApi;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *logText;
@property (weak, nonatomic) IBOutlet UIButton *logClearBtn;

- (IBAction)click_clearLog:(id)sender;


- (void) addServerRequestLog : (NSString *) strLog;
- (void) addServerResponseLog : (NSString *) strLog;
- (void) addSDKResponseLog : (int) retcode Log:(NSString *) strLog;
- (BOOL) isAgreeAllPrivacy;
- (void) startMonitoring;
- (void) gotoUrl:(UIWebView*)view getUrl:(NSString*)getUrl;

- (void) setCampaignMessage:(NSString *)message;
- (void) updateVzone:(NSString *)vzoneCntMessage;
- (void) setDeviceToken:(NSString *)deviceToken;

//- (void)callDeviceInfo ;
- (void) webViewAlert:(NSString *)message;
@end
