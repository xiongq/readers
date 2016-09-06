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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
