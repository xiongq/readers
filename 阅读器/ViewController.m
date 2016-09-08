//
//  ViewController.m
//  阅读器
//
//  Created by xiong on 16/8/29.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "ViewController.h"
#import "booksModel.h"
#import "Ono.h"
#import "booksCell.h"
#import "textViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "NetWorkTools.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *booklistView;
@property (strong,nonatomic) NSMutableArray *dataSoure;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self booksUpdate];

}
- (IBAction)coredata:(id)sender {

//    NSStringEncoding enc= CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
//
//    NSData *body = [@"searchtype=articlename&searchkey=全职法师&submit=" dataUsingEncoding:enc];
//
//    NSURL *url = [NSURL URLWithString:@"http://m.ybdu.com/modules/article/search.php"];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:body];
//    NSURLSession *session = [NSURLSession sharedSession];
//    // 4.2、 创建数据请求任务
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSString * newStr = [[NSString alloc] initWithData:data  encoding:enc];
//        NSLog(@"新请求结果%@",newStr);
//        NSLog(@"%@",[NSThread currentThread]);
//    }];
//    // 4.3、 启动任务
//    [task resume];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.booklistView registerNib:[UINib nibWithNibName:@"booksCell" bundle:nil] forCellReuseIdentifier:@"bookscell"];
    self.booklistView.tableFooterView = [UIView new];
    self.dataSoure = (NSMutableArray *)[Book MR_findAllSortedBy:@"booksName:YES" ascending:NO];


  /*  if (self.dataSoure.count != 0) {
//        self.dataSoure = [NSMutableArray new];
//        [books enumerateObjectsUsingBlock:^(Book *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"books-name%@ url--%@",obj.booksName,obj.booksUrl);
//            booksModel *model = [booksModel new];
//            model.booksName = obj.booksName;
//            model.booksURL = obj.booksUrl;
//            [self.dataSoure addObject:model];
//        }];
//            [self.booklistView reloadData];
        
    }else{
        //    获取主页列表->返回主页模型数组
        [[NetWorkTools shareNetWorkTools] booksListGET:@"http://m.ybdu.com/quanben/1" Succees:^(id books) {
            self.dataSoure = books;
            [self.booklistView reloadData];
        } Error:^(NSError *error) {
            
        }];


    }*/

    [self booksUpdate];
    
}
-(void)booksUpdate{
    [[NetWorkTools shareNetWorkTools] booksLastChapterSuccees:^(NSMutableArray *books) {
        self.dataSoure = books;
        [self.booklistView reloadData];
    } Error:^(NSError *error) {

    }];


}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoure.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    booksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookscell" forIndexPath:indexPath];
    cell.model = self.dataSoure[indexPath.row];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    textViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"textvc"];
    vc.model = self.dataSoure[indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];

}
@end
