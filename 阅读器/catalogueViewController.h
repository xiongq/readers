//
//  catalogueViewController.h
//  阅读器
//
//  Created by xiong on 16/8/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol backChapterDelegate
-(void)backChapter:(Chapter *)chapter;
@end
@interface catalogueViewController : UIViewController
@property(copy, nonatomic)  NSArray *catalogueArray;
@property(assign, nonatomic)  NSUInteger  index;
@property(strong, nonatomic) id<backChapterDelegate>delegate;
@end
