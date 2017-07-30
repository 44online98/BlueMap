//
//  LocationManger.m
//  GoogleMapAPIMapKit
//
//  Created by MC372 on 5/8/13.
//  Copyright (c) 2013 MC372. All rights reserved.
//

#import "LocationManger.h"

static LocationManger *_instace = nil;
@interface LocationManger ()<CLLocationManagerDelegate>
@property (nonatomic,retain) CLLocationManager *locationManager;
@end
@implementation LocationManger
#pragma mark - Accessory
-(void)startUpdateLocationWithBlock:(void (^)(id, id))block{
    @autoreleasepool {
        _flagToStopUpdateLocation = YES;
        if (block) {
            self.blockUpdateLocation = [block copy];
        }
        
        /* detect enable gps */
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedWhenInUse:{
                [self startUpdateLocation];
                NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            }

                break;
            case kCLAuthorizationStatusAuthorizedAlways:{
                [self startUpdateLocation];
                NSLog(@"kCLAuthorizationStatusAuthorized");
            }
                break;
            case kCLAuthorizationStatusDenied:{
                self.blockUpdateLocation(nil,@"kCLAuthorizationStatusDenied");
                NSLog(@"kCLAuthorizationStatusDenied");
            }
                break;
            case kCLAuthorizationStatusNotDetermined:{
                [self startUpdateLocation];
                NSLog(@"kCLAuthorizationStatusNotDetermined");
            }
                break;
            case kCLAuthorizationStatusRestricted:{
                self.blockUpdateLocation(nil,@"kCLAuthorizationStatusDenied");
                NSLog(@"kCLAuthorizationStatusRestricted");
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - Helper Method
+(LocationManger *)sharedLocationManager{
    if (!_instace) {
        _instace = [[LocationManger alloc]init];
    }
    return _instace;
}
-(void)startUpdateLocation{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    if (self.locationManager) {
        [self.locationManager startUpdatingHeading];
        [self.locationManager requestWhenInUseAuthorization];
    }
}
-(void)stopUpdateLocation{
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
    }
}
#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    self.blockUpdateLocation(newLocation,nil);
    
    /* Use old method*/
    if ([_delegate respondsToSelector:@selector(resultLocationInfo:)]) {
        
        [_delegate resultLocationInfo:newLocation.coordinate];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (self.flagToStopUpdateLocation == YES) {
        self.blockUpdateLocation(locations[0],nil);
    }
    self.flagToStopUpdateLocation = NO;

    if ([_delegate respondsToSelector:@selector(resultLocationInfo:)]) {
        [_delegate resultLocationInfo:[[locations objectAtIndex:0]coordinate ]];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.blockUpdateLocation(nil,error.description);
    
    /* Use old method*/
    if ([_delegate respondsToSelector:@selector(resultLocationInfoWithError:)]) {
        [_delegate resultLocationInfoWithError:error];
    }
}
@end
