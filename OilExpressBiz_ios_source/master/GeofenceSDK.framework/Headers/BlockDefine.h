//
//  BlockDefine.h
//  GigaBeaconSDK
//
//  Created by dkitec on 2016. 7. 15..
//  Copyright © 2016년 dkitec. All rights reserved.
//

#ifndef BlockDefine_h
#define BlockDefine_h

#import "API_Protocol.h"

typedef void(^DownloadProgress)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);
typedef void(^GeoCompletion)(BOOL success, id result, NSError *error);
typedef void(^GeoVoid)();
typedef void(^RequestAccessTokenCompletionHandler)(API_RETURN_CODE returnCode);


#endif /* BlockDefine_h */
