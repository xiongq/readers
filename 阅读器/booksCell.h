//
//  booksCell.h
//  阅读器
//
//  Created by xiong on 16/8/29.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "booksModel.h"

@interface booksCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabei;
@property (weak, nonatomic) IBOutlet UILabel *authorLabei;


@property(strong, nonatomic) Book *model;
@end
