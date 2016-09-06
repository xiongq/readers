//
//  pageSeparationTools.h
//  阅读器
//
//  Created by xiong on 16/8/31.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

//成功之后返回值
typedef void(^success)(id books);
//成功之后返回值
typedef void(^error)(NSError *error);


@interface pageSeparationTools : NSObject
/**
 *  字体大小
 */
@property(assign, nonatomic) CGFloat fontsize;
/**
 *  行距
 */
@property(assign, nonatomic) CGFloat lineSpace;



@property (strong,nonatomic) NSMutableArray *pageArray;
+(instancetype)sharepageSeparationTools;

/**
 *  属性文字
 *
 *  @param ChapterContent 要分页的string
 *
 *  @return 分好页的string
 */
-(NSMutableArray *)pageSeparationWithSting:(NSString *)ChapterContent;
-(NSMutableArray *)upBIGFont;
-(NSMutableArray *)upSamilFont;
@end
