//
//  booksCell.m
//  阅读器
//
//  Created by xiong on 16/8/29.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "booksCell.h"

@implementation booksCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(Book *)model{
    _model = model;
    self.bookNameLabei.text = model.booksName;
//    if (model.haveUP) {
//        self.backgroundColor = [UIColor redColor];
//    }else{
//        self.backgroundColor = [UIColor whiteColor];
//    }
//    NSLog(@"%@",model.booksURL);
    self.authorLabei.text = model.lastChapter;
    if (model.haveUP) {
        self.authorLabei.textColor = [UIColor redColor];
    }else{
        self.authorLabei.textColor = [UIColor blackColor];
    }


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
