//
//  RLLCollectionViewDelegate.m
//  Fovo
//
//  Created by Corey Earwood on 7/29/13.
//  Copyright (c) 2013 Corey Earwood. All rights reserved.
//

#import "RLLCollectionViewDelegate.h"

@interface RLLCollectionViewDelegate ()

@property (nonatomic, strong) NSString *cellClassString;
@property (nonatomic, strong) NSString *cellSelectorString;

@end

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

- (void)updatePageControllerCurrentPage {
  NSInteger numPages = ceilf(_collectionView.contentSize.width / _collectionView.bounds.size.width);
  NSInteger curPage = floor((_collectionView.contentOffset.x - _collectionView.bounds.size.width / 2) / _collectionView.bounds.size.width) + 1;
  
  self.pageController.numberOfPages = numPages;
  self.pageController.currentPage = curPage;
}

- (void)registerCellClass:(Class)cellClass andConfigureSelector:(SEL)configureSelector {
  self.cellClassString = NSStringFromClass(cellClass);
  self.cellSelectorString = NSStringFromSelector(configureSelector);
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
  if ([_delegate respondsToSelector:_cmd]) {
    return [_delegate collectionView:collectionView cellForItemAtIndexPath:indexPath];
  }
  
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellClassString forIndexPath:indexPath];
  
  SEL selector = NSSelectorFromString(self.cellSelectorString);
  if ([cell respondsToSelector:selector]) {
    IMP method = [cell methodForSelector:selector];
    void (* methodFunction)(id, SEL, id) = (void *)method;
    methodFunction(cell, selector, self.dataSource[indexPath.item]);
  }
  
  return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (self.pageController) {
    [self updatePageControllerCurrentPage];
  }
  
  if ([_delegate respondsToSelector:_cmd]) {
    [_delegate scrollViewDidScroll:scrollView];
  }
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
