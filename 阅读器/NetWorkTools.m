//
//  NetWorkTools.m
//  阅读器
//
//  Created by xiong on 16/8/31.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "NetWorkTools.h"
#import "AFNetworking.h"
#import "Ono.h"
#import "booksModel.h"
#import "catguloModel.h"


@implementation NetWorkTools{

}
static AFHTTPSessionManager *manger = nil;
static NetWorkTools *shareInstance = nil;
static NSStringEncoding encUTF8;
+(instancetype)shareNetWorkTools{

    @synchronized (self) {
        if (!shareInstance) {
            shareInstance = [[[self class] alloc] init];
            manger = [AFHTTPSessionManager manager];
            manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            manger.responseSerializer = [AFHTTPResponseSerializer serializer];
            encUTF8 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        }
    }
    return shareInstance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    @synchronized (self) {
        if (!shareInstance) {
            shareInstance = [super allocWithZone:zone];
            manger = [AFHTTPSessionManager manager];
            manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            manger.responseSerializer = [AFHTTPResponseSerializer serializer];
            return shareInstance;
        }
    }
    return nil;
}
//获取的HTML编码UTF8
-(NSString *)UTF8encdString:(id)response{
   return [[NSString alloc] initWithData:response encoding:encUTF8];
}
//解析HTML返回模型数组-->小说列表
-(NSMutableArray *)HTMLwithString:(NSString *)str{
    NSError *error;
    NSMutableArray *bookslist = [NSMutableArray new];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:str encoding:NSUTF8StringEncoding error:&error];
    [document enumerateElementsWithCSS:@".list p" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
//        booksModel *model = [booksModel new];
        NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
        Book *temp = [Book MR_createEntityInContext:defaultContext];
        ONOXMLElement *books = element.children.firstObject;
        temp.booksName = [books stringValue];
        temp.booksUrl =  books[@"href"];
        [defaultContext MR_saveToPersistentStoreAndWait];
//        ONOXMLElement *books = element.children.firstObject;
//        model.booksName = [books stringValue];
//        model.booksURL = books[@"href"];
        [bookslist  addObject:temp];
    }];
    return bookslist;
}


/**
 *  解析章节内容
 *
 *  @param response NSDATA （html）
 *
 *  @return 章节内容string
 */
-(NSString *)analysisChapterContentWithHTML:(id)response{
     NSError *error;
    __block NSString *chapterContent;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:[[NSString alloc] initWithData:response encoding:encUTF8] encoding:NSUTF8StringEncoding error:&error];
    [document enumerateElementsWithXPath:@".//*[@id='txt']" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {

        chapterContent = [element stringValue];
    }];
    [document enumerateElementsWithXPath:@".//*[@id='nr_title']" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {

        self.currChaperString = [element stringValue];
    }];
    return chapterContent;
/*
    http://m.ybdu.com/xiaoshuo/16/16237/5501953.html
    http://www.ybdu.com/xiaoshuo/16/16237/5501953.html
 
 http://m.ybdu.com/xiaoshuo/16/16237/6342271.html
 */
}
-(NSString *)lastChapterWithHTML:(id)response{
    NSError *error;
   __block NSString *lastStr;
//    NSMutableArray *bookslist = [NSMutableArray new];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:[[NSString alloc] initWithData:response encoding:encUTF8] encoding:NSUTF8StringEncoding error:&error];
    [document enumerateElementsWithCSS:@".mulu_list" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {

        ONOXMLElement *temp = element.children.lastObject;

        lastStr = [temp stringValue];

    }];
    return lastStr;
    
}
-(NSMutableArray *)allChaptercontentWithHTML:(id)response{
     NSError *error;
    NSMutableArray *bookslist = [NSMutableArray new];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:[[NSString alloc] initWithData:response encoding:encUTF8] encoding:NSUTF8StringEncoding error:&error];
    [document enumerateElementsWithCSS:@".mulu_list" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        for (ONOXMLElement *temp in element.children) {
//            catguloModel *model = [catguloModel new];
            Chapter *chaper = [Chapter MR_createEntity];
            chaper.chapterUrl = temp.children.firstObject[@"href"];
            chaper.chapterString = [temp stringValue];
            [bookslist addObject:chaper];
        }
    }];
    return bookslist;

}
//第一次阅读章节解析
-(NSArray *)FirstReadChaptercontentWithHTML:(id)response withBooksurl:(NSString *)url{
    NSError *error;
//    NSMutableArray *bookslist = [NSMutableArray new];
//    NSLog(@"%@",[[NSString alloc] initWithData:response encoding:encUTF8]);
    Book *booksCoreDate = [Book MR_findFirstByAttribute:@"booksUrl" withValue:url];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:[[NSString alloc] initWithData:response encoding:encUTF8] encoding:NSUTF8StringEncoding error:&error];
    [document enumerateElementsWithCSS:@".chapter li" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSLog(@"elem%@--",element.children.firstObject[@"href"]);
         NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];

            Chapter *chap = [Chapter MR_createEntityInContext:defaultContext];
            chap.chapterUrl = element.children.firstObject[@"href"];
            chap.chapterString = [element stringValue];
            [booksCoreDate addChapterObject:chap];

        [defaultContext MR_saveToPersistentStoreAndWait];
    }];
    return [Chapter MR_findByAttribute:@"book.booksUrl" withValue:url andOrderBy:@"chapterUrl" ascending:YES];;
    
}
/*书籍列表请求*/
-(void)booksListGET:(NSString *)url Succees:(success)Success Error:(error)Error{
    [manger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSLog(@"newworktools->booksListGET-success WITH URL%@",url);
            Success([self HTMLwithString:[self UTF8encdString:responseObject]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            NSLog(@"newworktools->booksListGET--Error WITH URL%@ \n\t error%@",url,error.description);
            Error(error);
        }
    }];

}

//章节内容请求
-(void)bookChapterContentGET:(NSString *)url Succees:(success)Success Error:(error)Error{
    [manger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         if (responseObject) {
             NSLog(@"newworktools->bookChapterContentGET-success WITH URL%@",url);
               Success([self analysisChapterContentWithHTML:responseObject]);
             }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (Error) {
              NSLog(@"newworktools->bookChapterContentGET-Error WITH URL%@ \n\t error%@",url,error.description);
             Error(error);
         }
    }];

}
//章节内容请求
-(void)bookChapterContentGETwithArray:(NSMutableArray *)arrry bookUrl:(NSString *)bookURL Succees:(success)Success Error:(error)Error{
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    [arrry enumerateObjectsUsingBlock:^(Chapter *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = [[@"http://m.ybdu.com"  stringByAppendingString:[bookURL stringByReplacingOccurrencesOfString:@"xiazai" withString:@"xiaoshuo"] ] stringByAppendingString:obj.chapterUrl];
        
        [manger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *str = [self analysisChapterContentWithHTML:responseObject];
//            obj.chapterString = str;
            Content *content = [Content MR_createEntityInContext:defaultContext];
            content.contentString = str;
            obj.content = content;
            [defaultContext MR_saveToPersistentStoreAndWait];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
    }];

}
//全部章节
-(void)booksAllChapterGET:(NSString *)url Succees:(success)Success Error:(error)Error{
    [manger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSLog(@"newworktools->全部章节-success WITH URL%@",url);
            Success([self allChaptercontentWithHTML:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            NSLog(@"newworktools->全部章节-Error WITH URL%@ \n\t error%@",url,error.description);
            Error(error);
        }
    }];


}
//最后章节
-(void)booksLastChapterGET:(NSString *)url Succees:(success)Success Error:(error)Error{
    [manger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSLog(@"newworktools->booksAllChapterGET-success WITH URL%@",url);
            Success([self lastChapterWithHTML:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            NSLog(@"newworktools->booksAllChapterGET-Error WITH URL%@ \n\t error%@",url,error.description);
            Error(error);
        }
    }];

    
}
//首页更新
-(void)booksLastChapterSuccees:(success)Success Error:(error)Error{
    NSLog(@"start---------------------------%@",[NSDate new]);
    NSArray *books = [Book MR_findAll];
    if (books.count == 0) return;
   __block NSUInteger index;
    for (Book *temp in books) {

        [self booksLastChapterGET:[@"http://www.ybdu.com/" stringByAppendingString:[temp.booksUrl stringByReplacingOccurrencesOfString:@"xiazai" withString:@"xiaoshuo"]] Succees:^(NSString *ChapterName) {
            index++;
//             NSArray *tt = [Chapter MR_findByAttribute:@"book.booksUrl" withValue:temp.booksUrl  andOrderBy:@"chapterUrl" ascending:YES];
//             Chapter *old = [tt lastObject];
                        if ( [ChapterName isEqualToString: temp.lastChapter]) {
                            Book *books = [Book MR_findFirstByAttribute:@"booksUrl" withValue:temp.booksUrl];
                            books.haveUP = NO;
                            books.lastChapter = ChapterName;
                            [[NSManagedObjectContext MR_context] MR_saveToPersistentStoreAndWait];
                        }else{
                            Book *books = [Book MR_findFirstByAttribute:@"booksUrl" withValue:temp.booksUrl];
                            books.haveUP = YES;
                            books.lastChapter = ChapterName;
                            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                        }

                if (Success) {
                    Success([Book MR_findAll]);
                }
            NSLog(@"stop---------------------------%@",[NSDate new]);
        } Error:^(NSError *error) {

        }];
    }
}
//首次阅读章节目录
-(void)booksFirstReadChapterWithBookurl:(NSString *)bookurl GET:(NSString *)url Succees:(success)Success Error:(error)Error{
    [manger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSLog(@"newworktools->首次阅读章节目录-success WITH URL%@",url);
            Success([self FirstReadChaptercontentWithHTML:responseObject withBooksurl:bookurl]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            NSLog(@"newworktools->首次阅读章节目录-Error WITH URL%@ \n\t error%@",url,error.description);
            Error(error);
        }
    }];


}
@end
