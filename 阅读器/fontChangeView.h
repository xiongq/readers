//
//  fontChangeView.h
//  阅读器
//
//  Created by xiong on 2016/9/9.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, changeFont) {
    big = 0,
    restore,
    small
};
@protocol changeFontDelegate
-(void)changeFont:(changeFont)change;
@end
@interface fontChangeView : UIView
@property(strong, nonatomic) id<changeFontDelegate>delegate;
@end
