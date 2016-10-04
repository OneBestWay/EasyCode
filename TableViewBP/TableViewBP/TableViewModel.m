//
//  tableViewModel.m
//  TableViewBP
//
//  Created by GK on 16/10/3.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "TableViewModel.h"

@implementation CustomModel



@end

@implementation TableViewModel

- (void)headerRefreshRequestWithCallback:(Callback)callback
{
    //模拟网络请求得到数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(2);
        //模拟解析数据
        NSMutableArray *arr=[NSMutableArray array];
        for (int i=0; i<16; i++) {
            int x = arc4random() % 100;
            NSString *string=[NSString stringWithFormat:@"(random%d)任何值得去的地方，都没有捷径。",x];
            CustomModel *model=[[CustomModel alloc] init];
            model.title=string;
            [arr addObject:model];
        }
        //在主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(arr,YES);
        });
    });
}

- (void)footerRefreshRequestWithCallback:(Callback)callback
{
        //模拟网络请求得到数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(2);
        //模拟解析数据
        NSMutableArray *arr=[NSMutableArray array];
        for (int i=0; i<16; i++) {
            int x = arc4random() % 1000;
            NSString *string=[NSString stringWithFormat:@"(random%d)任何值得去的地方，都没有捷径！",x];
            CustomModel *model=[[CustomModel alloc] init];
            model.title=string;
            [arr addObject:model];
            
        }
        //在主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(arr,YES);
        });
    });
}

@end
