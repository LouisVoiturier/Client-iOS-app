//
//  Tools.h
//  Louis
//
//  Created by François Juteau on 28/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Tools : NSObject

+(void)rotateLayerInfinite:(CALayer *)layer;

+(void)rotateLayer:(CALayer *)layer
fromStartingDegree:(CGFloat)startingDegree
   toArrivalDegree:(CGFloat)arrivalDegree
         inSeconds:(CGFloat)seconds;
@end
