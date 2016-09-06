//
//  catalogueTableViewCell.m
//  阅读器
//
//  Created by xiong on 16/8/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "catalogueTableViewCell.h"

@implementation catalogueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.backgroundColor = [UIColor yellowColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(Chapter *)model{
    _model = model;
    self.catalogueLabei.text = [model.chapterString stringByReplacingOccurrencesOfString:@"\n\t" withString:@""];

}
@end
