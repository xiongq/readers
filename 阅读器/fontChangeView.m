//
//  fontChangeView.m
//  阅读器
//
//  Created by xiong on 2016/9/9.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "fontChangeView.h"

@implementation fontChangeView


- (IBAction)restore:(id)sender {
    [self.delegate  changeFont:restore];
}

- (IBAction)small:(id)sender {
    [self.delegate  changeFont:small];
}

- (IBAction)bigss:(id)sender {
    [self.delegate  changeFont:big];

}

@end
