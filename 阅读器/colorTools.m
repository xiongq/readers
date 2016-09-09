//
//  colorTools.m
//  阅读器
//
//  Created by xiong on 2016/9/9.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "colorTools.h"

@implementation colorTools
- (IBAction)white:(id)sender {
    [self.delegate selectColor:[UIColor whiteColor]];
}
- (IBAction)gra:(id)sender {
    [self.delegate selectColor:[UIColor grayColor]];
}
- (IBAction)yellow:(id)sender {
    UIColor *make = [UIColor colorWithRed:223.0f/255.0 green:208.0f/255.0 blue:175.0f/255.0 alpha:1];
    [self.delegate selectColor:make];
}


@end
