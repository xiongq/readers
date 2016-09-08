//
//  searchBookCell.m
//  阅读器
//
//  Created by xiong on 16/9/7.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "searchBookCell.h"

@implementation searchBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(searchModel *)model{
    _model = model;
    self.author.text = model.bookAuthor;
    self.bookName.text = model.bookName;
    if (model.booksCage) {
        self.info.text = model.booksCage;
    }else{
        self.info.text = @"";
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
