//
//  SFCDecoder.h
//  Pods
//
//  Created by sapsaldog on 6/15/16.
//
//

#ifndef SFCDecoder_h
#define SFCDecoder_h
#import <AVFoundation/AVFoundation.h>
#import "UltraSoundDelegate.h"

@interface UltraSoundInternalDecoder : NSObject
{
    AVAudioEngine *_audioEngine;
}

@property (nonatomic, weak) id<UltraSoundDelegate> delegate;
@property (atomic) BOOL isRunning;

+ (UltraSoundInternalDecoder *)getInstance;
- (BOOL) start: (id<UltraSoundDelegate>) delegate;
- (BOOL) stop;
- (double) getRSSI;
- (NSString *) getVersion;
@end

#endif /* SFCDecoder_h */
