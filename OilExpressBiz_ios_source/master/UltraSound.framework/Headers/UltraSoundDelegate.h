//
//  UltraSoundDelegate.h
//  UltraSound
//
//  Created by sapsaldog on 2/7/17.
//  Copyright © 2017 KT corp. All rights reserved.
//

#ifndef UltraSoundDelegate_h
#define UltraSoundDelegate_h

#import "UltraSoundStatus.h"

@protocol UltraSoundDelegate <NSObject>

- (void) onValueDetected:(NSString *) value;
- (void) onStatusChanged:(UltraSoundStatus) status;

@end


#endif /* UltraSoundDelegate_h */
