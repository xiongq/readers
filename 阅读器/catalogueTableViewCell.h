//
//  catalogueTableViewCell.h
//  阅读器
//
//  Created by xiong on 16/8/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Ono/Ono.h>
#import "catguloModel.h"

@interface catalogueTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *catalogueLabei;
@property(strong, nonatomic)  Chapter *model;
@end
