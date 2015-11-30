//
//  MapAnnotation.m
//  
//
//  Created by Aditya Narayan on 11/24/15.
//
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (instancetype)init:(NSString *)name withAddress:(NSString*)address{
  self = [super init];
  
  self.locationName = name;
  self.locationAddress = address;
  
  return self;
}

- (id)init:(NSString *)name withAddress:(NSString*)address withSubtitle:(NSString*)subtitle withCoordinateCenter:(CLLocationCoordinate2D)coordinate{
  self = [self init:name withAddress:address];
  
  self.locationSubtitle = subtitle;
  self.locationCoordinate = coordinate;
  
  return self;
}

- (id)init{
  self = [self init:@"NA" withAddress:@"NA"];
  return self;
}

@end


