//
//  RLLCollectionViewDelegate.m
//  Fovo
//
//  Created by Corey Earwood on 7/29/13.
//  Copyright (c) 2013 Corey Earwood. All rights reserved.
//

#import "RLLCollectionViewDelegate.h"

@implementation RLLCollectionViewDelegate

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    
    //If _delegate isn't set first the surrogate setup breaks for some methods like scrollViewDidScroll: which only check once and cache the results
    if (self.collectionView) {
        self.collectionView = self.collectionView;
    }
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    
    _collectionView = collectionView;
    
    _collectionView.delegate = (id<UICollectionViewDelegate>)self;
    _collectionView.dataSource = (id<UICollectionViewDataSource>)self;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([_delegate respondsToSelector:_cmd]) {
        return [_delegate numberOfSectionsInCollectionView:collectionView];
    }
    
    return self.topArrayContainsSections ? [self.dataSource count] : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_delegate respondsToSelector:_cmd]) {
        return [_delegate collectionView:collectionView numberOfItemsInSection:section];
    }
    
    return self.topArrayContainsSections ? [self.dataSource[section] count] : [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Setup _delegate as surrogate object

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([_delegate respondsToSelector:aSelector]) {
        return YES;
    } else {
        return [super respondsToSelector:aSelector];
    }
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_delegate conformsToProtocol:aProtocol];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([_delegate respondsToSelector:aSelector]) {
        return [_delegate methodSignatureForSelector:aSelector];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([_delegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_delegate];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end
