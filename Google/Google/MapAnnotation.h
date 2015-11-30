//
//  MapAnnotation.h
//  
//
//  Created by Aditya Narayan on 11/24/15.
//
//
//
//  MapAnnotation.h
//  Maps
//
//  Created by Aditya Narayan on 11/24/15.
//  Copyright © 2015 turntotech.io. All rights reserved.
//

@import MapKit;
#import <Foundation/Foundation.h>

@interface MapAnnotation : NSObject

@property (nonatomic, strong) NSString* locationName;
@property (nonatomic, strong) NSString* locationSubtitle;
@property (nonatomic, strong) NSString* locationAddress;
@property (nonatomic) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, strong) NSURL* locationURL;
@property (nonatomic, strong) NSString* locationPhoneNumber;
@property (nonatomic, strong) UIImage *locationImage;

- (instancetype)init:(NSString *)name withAddress:(NSString*)address NS_DESIGNATED_INITIALIZER;
- (id)init:(NSString *)name withAddress:(NSString*)address withSubtitle:(NSString*)subtitle withCoordinateCenter:(CLLocationCoordinate2D)coordinate;
- (id)init;
@end
