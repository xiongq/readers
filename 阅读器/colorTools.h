//
//  colorTools.h
//  阅读器
//
//  Created by xiong on 2016/9/9.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol colorSelectDelegate

-(void)selectColor:(UIColor *)color;

@end

@interface colorTools : UIView
@property(strong,nonatomic) id<colorSelectDelegate>delegate;
@end
