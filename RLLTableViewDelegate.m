//
//  RLLTableViewDelegate.m
//  Fovo
//
//  Created by Corey Earwood on 7/29/13.
//  Copyright (c) 2013 Corey Earwood. All rights reserved.
//

#import "RLLTableViewDelegate.h"

@implementation RLLTableViewDelegate

- (void)setDelegate:(id)delegate {
  _delegate = delegate;
  
  //If _delegate isn't set first the surrogate setup breaks for some methods like scrollViewDidScroll: which only check once and cache the results
  if (self.tableView) {
    self.tableView = self.tableView;
  }
}

- (void)setTableView:(UITableView *)tableView {
  _tableView.delegate = nil;
  _tableView.dataSource = nil;
  
  _tableView = tableView;
  
  _tableView.delegate = (id<UITableViewDelegate>)self;
  _tableView.dataSource = (id<UITableViewDataSource>)self;
}

- (void)setDataSource:(NSArray *)dataSource {
  _dataSource = dataSource;
  
  [self.tableView reloadData];
}

- (void)updatePageControllerCurrentPage {
  NSInteger numPages = ceilf(_tableView.contentSize.width / _tableView.bounds.size.width);
  NSInteger curPage = floor((_tableView.contentOffset.x - _tableView.bounds.size.width / 2) / _tableView.bounds.size.width) + 1;
  
  self.pageController.numberOfPages = numPages;
  self.pageController.currentPage = curPage;
}

#pragma mark - UItableView

- (NSInteger)numberOfSectionsIntableView:(UITableView *)tableView {
  if ([_delegate respondsToSelector:_cmd]) {
    return [_delegate numberOfSectionsIntableView:tableView];
  }
  
  return self.topArrayContainsSections ? [self.dataSource count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([_delegate respondsToSelector:_cmd]) {
    return [_delegate tableView:tableView numberOfRowsInSection:section];
  }
  
  return self.topArrayContainsSections ? [self.dataSource[section] count] : [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([_delegate respondsToSelector:_cmd]) {
    return [_delegate tableView:tableView cellForRowAtIndexPath:indexPath];
  }
  return nil;
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
