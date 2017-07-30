//
//  LocationManger.h
//  GoogleMapAPIMapKit
//
//  Created by MC372 on 5/8/13.
//  Copyright (c) 2013 MC372. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <UIKit/UIKit.h>
// CHECK VERSION
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

typedef void (^UpdatedLocation)(id result,id error);

@protocol LocationManagerDelegate<NSObject>
@required
-(void)resultLocationInfo:(CLLocationCoordinate2D)coordinate;
-(void)resultLocationInfoWithError:(NSError *)error;
@end
@interface LocationManger : NSObject
@property (nonatomic,assign)id<LocationManagerDelegate>delegate;
@property (nonatomic,strong) UpdatedLocation blockUpdateLocation;
+(LocationManger *)sharedLocationManager;
#pragma mark - Deprecape
-(void)startUpdateLocation;
#pragma mark - New method
-(void)startUpdateLocationWithBlock:(void(^)(id result,id error))block;
-(void)stopUpdateLocation;
@property (nonatomic,assign) BOOL flagToStopUpdateLocation;

@end
