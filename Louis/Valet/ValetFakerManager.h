//
//  ValetFakerManager.h
//  Louis
//
//  Created by François Juteau on 16/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ValetFaker.h"


typedef void(^valetGetCompletion)(BOOL isAvailable);

@interface ValetFakerManager : NSObject

@property (nonatomic, strong) NSArray <ValetFaker *> __block *valetFakers;
@property (nonatomic, strong) ValetFaker *currentFaker;


+(instancetype)sharedInstance;
+(void)requestAValetWithLocation:(CLLocationCoordinate2D)userLocation completion:(valetGetCompletion)compbloc;
+(NSArray *)getAllValetsCoords;

@end
