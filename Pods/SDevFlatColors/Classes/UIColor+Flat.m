//
//  UIColor+Flat.m
//  SDevFlatColorsObj
//
//  Created by Sedat Ciftci on 23/05/15.
//  Copyright (c) 2015 Sedat Ciftci. All rights reserved.
//

#import "UIColor+Flat.h"

@implementation UIColor (Flat)
+ (UIColor *) flat:(Colors) color {
    return UIColorFromRGB(color);
}
@end
