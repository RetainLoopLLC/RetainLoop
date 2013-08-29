//
//  RLLCollectionViewDelegate.h
//  Fovo
//
//  Created by Corey Earwood on 7/29/13.
//  Copyright (c) 2013 Corey Earwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLLTableViewDelegate : NSObject <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet id delegate;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageController;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL topArrayContainsSections;

- (void)updatePageControllerCurrentPage;

@end
