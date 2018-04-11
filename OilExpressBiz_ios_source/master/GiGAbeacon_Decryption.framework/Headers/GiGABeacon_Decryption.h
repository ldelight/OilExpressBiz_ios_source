#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NetAssociation.h"

@interface GiGABeacon_Decryption : NSObject <NetAssociationDelegate>

/**
 *  Decryption Module Init
 *
 *  @return GiGABeacon_Decryption - singleton Instance
 */
+(GiGABeacon_Decryption*)getInstance;


/**
 *  Major Minor Decryption Function - Input Major, Minor
 *
 *  @param major       beacon Major Value
 *  @param minor       beacon Minor Value
 *
 *  @return NSDictionary : {
                             decryption = Decryption Code (2000 / 2001);
                             major      = NSNumber(CLBeaconMajorValue);
                             minor      = NSNumber(CLBeaconMinorValue);
                             ntpState   = NTP State Code (1000 / 1001 / 1002 / 1003);
                             rtcState   = RTC State Code (3000 / 3001);
                            }
 
 ntpState = timeSync State Code
 : 1000 = NTP Sync Success – Save Sync Time Data
 : 1001 = No NTP Sync - Using Saved NTP Sync Time Data
 : 1002 = NTP Timeout – Using Saved NTP Sync Time Data
 : 1003 = NTP Timeout – Using Device Time Data
 
 decryption = Decryption State Code
 : 2000 = Decryption – Input Data is Encryption Data
 : 2001 = No Decryption – Input Data is No Encryption Data
 
 rtcState= RTC State
 : 3000 = RTC STATE TODAY - Using RTC date for decryption
 : 3001 = RTC STATE NEXTDAY- Using RTC date +1 for decryption
 : 3002 = RTC STATE ㅖㄲㄸㅍDAY- Using RTC date -1 for decryption
*/
-(NSDictionary*)decryptionDataFromMajor:(CLBeaconMajorValue)major Minor:(CLBeaconMinorValue)minor;


@end
