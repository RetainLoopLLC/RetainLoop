//
//  RLLMutableDictionary.m
//  Fovo
//
//  Created by Corey Earwood on 9/12/13.
//  Copyright (c) 2013 Seedbar, LLC. All rights reserved.
//

#import "RLLMutableDictionary.h"
#import <objc/runtime.h>

@interface RLLMutableDictionary ()

@property (nonatomic, strong) NSMutableDictionary *proxy;

@end

@implementation RLLMutableDictionary

- (id)init {
  _proxy = [NSMutableDictionary new];
  return self;
}

//Prevent exception caused by attempting to add nil object.  This way we don't have to add a conditional for every key that may not exist from a remote API
- (void)forwardInvocation:(NSInvocation *)invocation {
  void *obj = NULL;
  
  NSMethodSignature *methodSignature = [_proxy methodSignatureForSelector:invocation.selector];
  
  if ([methodSignature numberOfArguments] > 2) {
    [invocation getArgument:&obj atIndex:2];
    
    if ((invocation.selector == @selector(setObject:forKeyedSubscript:) || invocation.selector == @selector(setObject:forKey:)) &&
        (obj == NULL || [(__bridge id)obj isKindOfClass:[NSNull class]])) {
      return;
    }
  }
  
  [invocation invokeWithTarget:_proxy];
  
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  return [_proxy methodSignatureForSelector:aSelector];
}

- (NSString *)description {
  return [_proxy description];
}

@end
