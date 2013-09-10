//
//  UIView+RLL.m
//  Fovo
//
//  Created by Corey Earwood on 9/10/13.
//  Copyright (c) 2013 Seedbar, LLC. All rights reserved.
//

#import "UIView+RLL.h"

@implementation UIView (RLL)

- (void)RLL_setAlphaWithNumber:(NSNumber *)number {
  [self setAlpha:[number floatValue]];
}

@end
