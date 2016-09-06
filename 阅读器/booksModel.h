//
//  booksModel.h
//  阅读器
//
//  Created by xiong on 16/8/29.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface booksModel : NSObject
@property (strong, nonatomic) NSString *booksName;
@property (strong, nonatomic) NSString *booksURL;
@property (strong, nonatomic) NSString *updateChapter;
@property (assign, nonatomic) BOOL haveUP;
@end
