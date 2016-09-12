//
//  searchViewController.m
//  阅读器
//
//  Created by xiong on 16/9/7.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "searchViewController.h"
#import "searchBookCell.h"
#import "Ono.h"
#import "searchModel.h"
#import "textViewController.h"

@interface searchViewController ()<UISearchBarDelegate,UIBarPositioningDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (weak, nonatomic) IBOutlet UITableView *searchTableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrans;
@property (strong,nonatomic) NSMutableArray *dataSource;
@end

@implementation searchViewController{
    NSURLSessionDataTask *lastTask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray new];
    self.searchbar.delegate = self;
    [self.searchTableview registerNib:[UINib nibWithNibName:@"searchBookCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    self.searchTableview.tableFooterView = [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    searchBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    searchModel *model = self.dataSource[indexPath.row];
//    NSArray *temp = [Book MR_findAll];
/*
    1.先判断数据库中有木有
    有-》就直接跳
    没有-》保存跳
 */
    textViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"textvc"];
    Book *book = [Book MR_findFirstByAttribute:@"booksUrl" withValue:model.bookURL];
    if (book) {
        vc.model = book;
    }else{
        Book *newBook = [Book MR_createEntity];
        newBook.booksUrl = model.bookURL;
        newBook.booksName = model.bookName;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        vc.model = newBook;
    }
    [self presentViewController:vc animated:YES completion:nil];

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"DidEndEdit");
    self.searchbar.showsCancelButton = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.topConstrans.constant = 0.5;
        [self.view layoutIfNeeded];
    }];

}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"DidBeginEdit");
    self.searchbar.showsCancelButton = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.topConstrans.constant = 0;
        [self.view layoutIfNeeded];
    }];
}
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText

{
    NSLog(@"%@",searchText);
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"quxiao");
    [self.searchbar resignFirstResponder];
}
//点击搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [self startNetworkwithString:searchBar.text];
}

-(void)startNetworkwithString:(NSString *)searchText{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithWindow:window];
    hub.mode = MBProgressHUDModeIndeterminate;
    [window addSubview:hub];
    dispatch_async(dispatch_get_main_queue(), ^{
            [hub show:YES];
    });


    NSMutableArray *tempArray = [NSMutableArray new];


        NSStringEncoding enc= CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        NSData *body = [[NSString stringWithFormat:@"searchtype=articlename&searchkey=%@&submit=",searchText] dataUsingEncoding:enc];
        NSURL *url = [NSURL URLWithString:@"http://m.ybdu.com/modules/article/search.php"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:body];
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.2、 创建数据请求任务
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString * newStr = [[NSString alloc] initWithData:data  encoding:enc];
            ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:newStr encoding:NSUTF8StringEncoding error:&error];
            NSRange range = [newStr rangeOfString:@"小说简介"];
            NSRange errorRange =  [newStr rangeOfString:@"两次搜索的间隔时间不得少于"];

            if (range.location && range.location < newStr.length) {
                NSLog(@"包含单本");
                //单本
                searchModel *models = [searchModel new];
                [document enumerateElementsWithCSS:@".block p" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {


                        switch (idx) {
                            case 0:
                                models.bookName = [element stringValue];
//                                ONOXMLElement *temp = element.children.firstObject;
                                models.bookURL  = [element.children.firstObject[@"href"] stringByReplacingOccurrencesOfString:@"http://m.ybdu.com" withString:@""];

                                break;
                            case 1:
                                models.bookAuthor = [element stringValue];
                                break;
                            case 2:
                                models.booksCage = [element stringValue];
                                break;

                            default:
                                break;
                        }

                }];
                [tempArray addObject:models];


            }else if (errorRange.location &&errorRange.location < newStr.length){
                NSLog(@"搜索间隔");

            }else{
                NSLog(@"搜索结果");

                 //多本
                 [document enumerateElementsWithCSS:@".cover p" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {

                     searchModel *models = [searchModel new];
                     [element.children enumerateObjectsUsingBlock:^(ONOXMLElement *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        switch (idx) {
                            case 0:
                                models.booksCage = [obj stringValue];
                                break;
                            case 1:
                                models.bookURL = obj[@"href"];
//                                NSLog(@"url%@",models.bookURL);
                                models.bookName = [obj stringValue];
                                break;
                            case 2:
                                models.bookAuthor = [obj stringValue];
                                break;
                            default:
                                NSLog(@"ts");
                                break;
                            }
                    }];

                     if (models.bookName) {
                         [tempArray addObject:models];
                     }

                 NSLog(@"书名-%@ 作者%@  类型%@  地址%@",models.bookName,models.bookAuthor,models.booksCage,models.bookURL);
                 }];





            }
            if (tempArray.count == 0) {
                NSLog(@"无结果");
                return;
            }
            self.dataSource = tempArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchTableview  reloadData];
                 [hub hide:YES];
            });



        }];
        // 4.3、 启动任务

     [task resume];
    lastTask = task;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
