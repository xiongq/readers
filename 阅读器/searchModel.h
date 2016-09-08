//
//  searchModel.h
//  阅读器
//
//  Created by xiong on 2016/9/8.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface searchModel : NSObject
@property (strong, nonatomic) NSString *bookName;
@property (strong, nonatomic) NSString *bookURL;
@property (strong, nonatomic) NSString *bookAuthor;
@property (strong, nonatomic) NSString *booksCage;

@end
