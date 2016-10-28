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
#import "ContactsPeople.h"
#define COLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ViewDataSource

- (void)setDataSourceArray:(NSMutableArray *)dataSourceArray
{
    _dataSourceArray = dataSourceArray;
    
    NSMutableArray *tempKeyArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in _dataSourceArray) {
        NSString *keyString = dic.allKeys[0];
        [tempKeyArray addObject:keyString];
    }
    self.keyArray = [tempKeyArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataSourceArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataSourceArray[section];
    NSString *keyString = dic.allKeys[0];
    NSArray *contactArray = dic[keyString];
    return contactArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:[CustomCell cellIdentifier]];
    //CustomModel *model = (CustomModel*)self.dataSourceArray[indexPath.row];
    NSDictionary *dic = self.dataSourceArray[indexPath.section];
    NSString *keyString = dic.allKeys[0];
    NSArray *contactArray = dic[keyString];
    
    ContactPeopleInfoDTO *dto = contactArray[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@%@",dto.name,dto.phone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(selectedInTableView:atIndex:)]) {
        [self.delegate selectedInTableView:tableView atIndex:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat KTableViewWidth = [[UIScreen mainScreen] bounds].size.width;
    UIView *secBacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KTableViewWidth-10.0, 20)];
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KTableViewWidth-10.0, 20)];
    indexLabel.text = [NSString stringWithFormat:@"  %@",[[self.dataSourceArray objectAtIndex:section]allKeys][0]];
    indexLabel.textColor = COLOR_HEX(0x0b0b0b);
    indexLabel.font = [UIFont systemFontOfSize:14];
    [secBacView addSubview:indexLabel];
    return secBacView;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger keyIndex = 0;
    for (NSString *keyString in self.keyArray) {
        if ([keyString isEqualToString:title]) {
            keyIndex = [self.keyArray indexOfObject:keyString];
            break;
        }
    }
    return keyIndex;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keyArray;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.keyArray[section];
}
@end
