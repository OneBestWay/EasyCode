//
//  ViewDataSource.m
//  TableViewBP
//
//  Created by GK on 16/10/3.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "ViewDataSource.h"
#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "TableViewModel.h"


@implementation ViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:[CustomCell cellIdentifier]];
    CustomModel *model = (CustomModel*)self.dataSourceArray[indexPath.row];
    cell.titleLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(selectedInTableView:atIndex:)]) {
        [self.delegate selectedInTableView:tableView atIndex:indexPath];
    }
}
@end
