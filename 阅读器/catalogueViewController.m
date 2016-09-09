//
//  catalogueViewController.m
//  阅读器
//
//  Created by xiong on 16/8/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "catalogueViewController.h"
#import "catalogueTableViewCell.h"
#import <Ono/Ono.h>
#import "catguloModel.h"

@interface catalogueViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *catalogueListView;

@end

@implementation catalogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.catalogueListView registerNib:[UINib nibWithNibName:@"catalogueTableViewCell" bundle:nil] forCellReuseIdentifier:@"catalogue"];
//    [self.catalogueListView setContentOffset:CGPointMake(self.catalogueListView.rowHeight * _index, 0)];
    NSUInteger currindex = self.catalogueListView.height / self.catalogueListView.rowHeight*0.7 + _index;
    [self.catalogueListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currindex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.catalogueArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    catalogueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"catalogue" forIndexPath:indexPath];
    Chapter  *element = self.catalogueArray[indexPath.row];
    if (_index == indexPath.row) {
        cell.catalogueLabei.textColor = [UIColor redColor];
    }else{
        cell.catalogueLabei.textColor = [UIColor blackColor];
    }
    cell.model = element;
    return cell;

}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    catalogueTableViewCell *cell = (catalogueTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"cell----%@",cell.catalogueLabei.text);
    [self.delegate backChapter:cell.model];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
