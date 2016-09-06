//
//  NetWorkTools.h
//  阅读器
//
//  Created by xiong on 16/8/31.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
//成功之后返回值
typedef void(^success)(id books);
//成功之后返回值
typedef void(^error)(NSError *error);

@interface NetWorkTools : NSObject
@property (strong, nonatomic) NSString *currChaperString;
/**返回单例*/
+(instancetype)shareNetWorkTools;
/**
 *  章节内容请求->block->NSString
 *
 *  @param url     链接
 *  @param Success 返回章节内容
 *  @param Error   错误
 */
-(void)bookChapterContentGET:(NSString *)url Succees:(success)Success Error:(error)Error;
/**
 *  缓存章节内容请求->block->NSString
 *
 *  @param url     链接
 *  @param Success 返回章节内容
 *  @param Error   错误
 */
-(void)bookChapterContentGETwithArray:(NSMutableArray *)arrry bookUrl:(NSString *)bookURL Succees:(success)Success Error:(error)Error;

/**
 *  书籍列表请求->block->NSMutableArray
 *
 *  @param url     链接
 *  @param Success 返回书籍列表模型
 *  @param Error   错误
 */
-(void)booksListGET:(NSString *)url Succees:(success)Success Error:(error)Error;
/**
 *  全部章节
 */
-(void)booksAllChapterGET:(NSString *)url Succees:(success)Success Error:(error)Error;

/**
 *  最后一章节名字
 */
-(void)booksLastChapterGET:(NSString *)url Succees:(success)Success Error:(error)Error;
/**
 *  首页更新
 */
-(void)booksLastChapterSuccees:(success)Success Error:(error)Error;

/**
 *  首次阅读章节目录
 */
-(void)booksFirstReadChapterWithBookurl:(NSString *)bookurl GET:(NSString *)url Succees:(success)Success Error:(error)Error;
@end
