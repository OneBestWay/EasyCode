//
//  ViewDataSource.h
//  TableViewBP
//
//  Created by GK on 16/10/3.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ViewDataSourceDelegate <NSObject>
- (void)selectedInTableView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath;
@end

@interface ViewDataSource : NSObject <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@property (nonatomic,weak) id<ViewDataSourceDelegate> delegate;

@property (nonatomic, strong) NSArray *keyArray;
@end
