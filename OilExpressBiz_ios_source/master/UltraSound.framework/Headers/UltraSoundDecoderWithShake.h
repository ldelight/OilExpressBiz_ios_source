//
//  UltraSoundDecoderWithShake.h
//  UltraSound
//
//  Created by sapsaldog on 01/03/2017.
//  Copyright © 2017 KT corp. All rights reserved.
//

#ifndef UltraSoundDecoderWithShake_h
#define UltraSoundDecoderWithShake_h

#import "UltraSoundDelegate.h"

@interface UltraSoundDecoderWithShake : NSObject <UltraSoundDelegate>
{
}

@property (nonatomic, weak) id<UltraSoundDelegate> delegate;
@property (assign, readonly) long durationShake;

+ (UltraSoundDecoderWithShake *)getInstance;
- (UltraSoundDecoderWithShake *)setScheduleWithShakeDuration: (long) durationShake;
- (void) start: (id<UltraSoundDelegate>) delegate;

@end

#endif /* UltraSoundDecoderWithShake_h */
