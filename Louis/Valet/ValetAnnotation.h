//
//  ValetAnnotation.h
//  Louis
//
//  Created by François Juteau on 16/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface ValetAnnotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
