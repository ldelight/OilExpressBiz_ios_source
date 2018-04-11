//
//  SFCLBSEncoder.h
//  UltraSound
//
//  Created by sapsaldog on 1/27/17.
//  Copyright © 2017 KT corp. All rights reserved.
//

#ifndef SFCLBSEncoder_h
#define SFCLBSEncoder_h
#import <AVFoundation/AVFoundation.h>
class SfcLbsEnc;

@interface SFCLBSEncoder : NSObject
{
    
@private
    SfcLbsEnc *encoderInternal;
}

+ (id)sharedEncoder;
- (double *) encode:(NSString *) hexStr;
@end

#endif /* SFCLBSEncoder_h */
