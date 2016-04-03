//
//  Coords.h
//  Louis
//
//  Created by François Juteau on 16/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Coords : NSObject

@property (nonatomic) CGFloat lattitude;
@property (nonatomic) CGFloat longitude;


-(instancetype)initWithCLLocation2D:(CLLocationCoordinate2D)location;
-(instancetype)initWithArrayofCoordinates:(NSArray *)location;
-(CLLocationCoordinate2D)location;
-(NSArray *)getArrayValue;
-(NSDictionary *)dictionary;

@end
