//
//  UltraSoundDecoder.h
//  UltraSound
//
//  Created by sapsaldog on 2/7/17.
//  Copyright © 2017 KT corp. All rights reserved.
//

#ifndef UltraSoundDecoder_h
#define UltraSoundDecoder_h

#import <Foundation/Foundation.h>
#import "UltraSoundDelegate.h"

@interface UltraSoundDecoder : NSObject <UltraSoundDelegate>
{
    
}

@property (assign, readwrite) long durationScan;
@property (assign, readwrite) long durationSleep;
@property (atomic) id<UltraSoundDelegate> delegate;

+ (UltraSoundDecoder *)getInstance;

- (BOOL) start;
- (BOOL) start: (id<UltraSoundDelegate>) delegate;
- (BOOL) stop;
- (void) startShakingMode: (long) duration;
- (void) apply;
- (UltraSoundDecoder *)setListener: (id<UltraSoundDelegate>) delegate;
- (UltraSoundDecoder *)setScheduleWithScanDuration: (long) durationScan withSleepDuration: (long) durationSleep;
- (long) getDurationScan;
- (long) getDurationSleep;

- (double) getRSSI;
- (NSString *) getVersion;
+ (void)log:(NSString *)firstArg, ...;
//+ (void)setDebugMode:(BOOL) isEnable;

@end

#endif /* UltraSoundDecoder_h */
