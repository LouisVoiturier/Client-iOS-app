//
//  Tools.m
//  Louis
//
//  Created by François Juteau on 28/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+(void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 0.85f; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
}


+(void)rotateLayer:(CALayer *)layer
fromStartingDegree:(CGFloat)startingDegree
   toArrivalDegree:(CGFloat)arrivalDegree
         inSeconds:(CGFloat)seconds
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:startingDegree];
    rotation.toValue = [NSNumber numberWithFloat:(arrivalDegree)];
    rotation.duration = seconds; // Speed
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
    layer.transform = CATransform3DMakeRotation(arrivalDegree, 0, 0.0, 1.0);
}

@end
