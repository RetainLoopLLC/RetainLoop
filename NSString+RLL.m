//
//  NSString+RLL.m
//  Fovo
//
//  Created by Corey Earwood on 9/3/13.
//  Copyright (c) 2013 Seedbar, LLC. All rights reserved.
//

#import "NSString+RLL.h"

@implementation NSString (RLL)

/**
 -[sizeWithFont:constrainedToSize:] was deprecated in iOS 7 and I want to keep it around
 */
- (CGSize)RLL_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
  return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}

@end
