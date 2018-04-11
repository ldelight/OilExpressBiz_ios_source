//
//  Status.h
//  UltraSound
//
//  Created by sapsaldog on 2/7/17.
//  Copyright © 2017 KT corp. All rights reserved.
//

#ifndef UltraSoundStatus_h
#define UltraSoundStatus_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UltraSoundStatus) {
    ULTRASOUND_MODULE_START,
    ULTRASOUND_MODULE_END,
    SCAN_START,
    SLEEP_START,
    SHAKING_START,
    SHAKING_STOP,
    THREAD_START,
    THREAD_STOP,
    ERROR_AUDIO_RECORD,
    CRC_ERROR_DETECTED,
};

@interface UltraSoundStatusUtility : NSObject {}
+ (NSString *) stringWithUltraSoundStatus:(UltraSoundStatus) input;

@end


#endif /* UltraSoundStatus_h */
