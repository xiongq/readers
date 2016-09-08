//
//  searchBookCell.h
//  阅读器
//
//  Created by xiong on 16/9/7.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchModel.h"

@interface searchBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) searchModel *model;
@end
