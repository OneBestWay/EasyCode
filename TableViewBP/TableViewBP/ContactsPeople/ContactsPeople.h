//
//  ContactsPeople.h
//  TableViewBP
//
//  Created by GK on 2016/10/27.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsPeople : NSObject
+ (NSString *)chinesePinYinAllWordFirstLetter:(NSString *)chinese;
+ (NSString *)chinesePinYinFirstLetter:(NSString *)chinese;
+ (NSArray *)allContactsPeople;
@end

@interface ContactPeopleInfoDTO : NSObject
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;

@end
