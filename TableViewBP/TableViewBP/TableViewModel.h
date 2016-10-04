//
//  tableViewModel.h
//  TableViewBP
//
//  Created by GK on 16/10/3.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Callback)(NSArray*,BOOL);

@interface CustomModel : NSObject
@property (nonatomic,strong) NSString *title;
@end

@interface TableViewModel : NSObject

//header refresh
- (void)headerRefreshRequestWithCallback:(Callback)callback;

//footer refresh
- (void)footerRefreshRequestWithCallback:(Callback)callback;
@end
