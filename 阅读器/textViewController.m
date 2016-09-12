//
//  textViewController.m
//  阅读器
//
//  Created by xiong on 16/8/29.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "textViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Ono/Ono.h>
#import "catalogueViewController.h"
#import "catguloModel.h"
#import "NetWorkTools.h"
#import "pageSeparationTools.h"

#import "fontChangeView.h"
#import "colorTools.h"

@interface textViewController ()<UIScrollViewDelegate,backChapterDelegate,colorSelectDelegate,changeFontDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *textsScroller;
@property (weak, nonatomic) IBOutlet UILabel *booksName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolsBottomLayout;
@property (weak, nonatomic) IBOutlet UIView *topViews;
@property (weak, nonatomic) IBOutlet UIView *toolsView;
@property (strong,nonatomic) NSMutableArray *capArray;
@property (strong,nonatomic) NSMutableArray *pageArray;
@property (strong,nonatomic) UITextView *txtView;
@property (strong, nonatomic) UILabel *chapterLabei;
@property (strong, nonatomic) UILabel *pageNumber;
@property (strong, nonatomic) fontChangeView *fontView;
@property (strong, nonatomic) colorTools *colortView;
@property (strong, nonatomic) MBProgressHUD *hub;

@end

@implementation textViewController{
    NSUInteger indexs;
    NSUInteger pageIndexs;
    NSString *currString;
    BOOL  allowEnable;
    uint64_t lastDate;
    uint64_t nowDate;
}
#pragma mark - 懒加载
-(MBProgressHUD *)hub{
    if (!_hub) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _hub = [[MBProgressHUD alloc] initWithWindow:window];
        _hub.mode = MBProgressHUDModeIndeterminate;
        [window addSubview:_hub];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hub show:YES];
//        });
    }
    return _hub;

}
-(colorTools *)colortView{
    if (!_colortView) {
        _colortView = [[NSBundle mainBundle] loadNibNamed:@"colorTools" owner:self options:nil][0];

        _colortView.frame = CGRectMake(0, screenH, screenW, 80);

    }
    return _colortView;

}
-(fontChangeView *)fontView{
    if (!_fontView) {
        _fontView = [[NSBundle mainBundle] loadNibNamed:@"fontChangeView" owner:self options:nil][0];
        _fontView.frame = CGRectMake(0, screenH, screenW, 80);

    }
    return _fontView;
}
-(UILabel *)chapterLabei{
    if (!_chapterLabei) {
        _chapterLabei = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenW-10, 20)];
        _chapterLabei.backgroundColor = [UIColor clearColor];
        _chapterLabei.textColor = [UIColor blackColor];
        _chapterLabei.font = [UIFont systemFontOfSize:10];

    }
    return _chapterLabei;
}
-(UILabel *)pageNumber{
    if (!_pageNumber) {
        _pageNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH -20, screenW - 10, 20)];
        _pageNumber.backgroundColor = [UIColor clearColor];
        _pageNumber.textColor = [UIColor blackColor];
        _pageNumber.font = [UIFont systemFontOfSize:10];
        _pageNumber.textAlignment = NSTextAlignmentRight;

    }
    return _pageNumber;

}
/**
 *  初始化scrollview
 */
-(void)allocScrollview{
    self.booksName.text = _model.booksName;
    self.textsScroller.pagingEnabled = YES;
    self.textsScroller.delegate = self;
    self.textsScroller.decelerationRate = 0.1f;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPage:)];
    [self.textsScroller addGestureRecognizer:tap];

    [self.view bringSubviewToFront:self.topViews];
    [self.view bringSubviewToFront:self.toolsView];



    NSUserDefaults *deful = [NSUserDefaults standardUserDefaults];
    NSLog(@"dic%@",deful);
    NSString *str = [deful valueForKey:@"colors"];
    if (str) {

        UIColor *colors = [UIColor whiteColor];
        if ([str isEqualToString:@"gray"]) {
            colors = [UIColor grayColor];
        }else if ([str isEqualToString:@"yellow"]){
            colors =  [UIColor colorWithRed:223.0f/255.0 green:208.0f/255.0 blue:175.0f/255.0 alpha:1];
        }
        self.textsScroller.backgroundColor = colors;
    }
}

#pragma mark - 工具按键点击
//关闭阅读界面
- (IBAction)close:(id)sender {
    [self saveMark];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//设置字体
- (IBAction)font:(id)sender {

    self.colortView.y = screenH;
    self.fontView.y = screenH -122;

}

//设置背景色
- (IBAction)background:(id)sender {
    self.colortView.y = screenH-122;
    self.fontView.y = screenH;
}
//缓存
- (IBAction)download:(id)sender {
    [self chapterCacheAlert];
}
//目录
- (IBAction)catalogue:(id)sender {
}
//夜间
- (IBAction)night:(id)sender {

}
-(BOOL)allowTouch{
    BOOL allow;

    nowDate = [[NSDate date] timeIntervalSince1970]*1000;
    if (nowDate - lastDate > 400) {
        allow = YES;
        lastDate = nowDate;
    }
    return allow;
}
-(void)touchPage:(UITapGestureRecognizer *)tap{
    // 获取点击位置
    CGPoint tapPoint = [tap locationInView:self.textsScroller];
    tapPoint.x = (NSUInteger)tapPoint.x%(NSUInteger)screenW;
    // 创建3个点击区域
    //  左边
    CGRect leftTap   = CGRectMake(0, 0, screenW/5*2, screenH);
    // 中间
    CGRect centerTap = CGRectMake(screenW/5*2, 0, screenW/5, screenH);
    // 右边
    CGRect rightTap  = CGRectMake(screenW/5*3, 0, screenW/5*2, screenH);


    CGFloat offsetx = self.textsScroller.contentOffset.x;

    if (CGRectContainsPoint(rightTap, tapPoint) ) {

        NSLog(@"右");
        [self hidenTools];
        if (offsetx + screenW > ([pageSeparationTools sharepageSeparationTools].pageArray.count -1) *screenW) {
            [self newChapterContent];
        }else{
            //                        [UIView animateWithDuration:0.2 animations:^{
            //                            [self.textsScroller setContentOffset:CGPointMake(offsetx + screenW, 0)];
            //                        }];
            [self.textsScroller setContentOffset:CGPointMake(offsetx + screenW, 0)];
        }
    }else if (CGRectContainsPoint(leftTap, tapPoint)){
        NSLog(@"左");
        [self hidenTools];
        if (offsetx - screenW >= 0) {
            [self.textsScroller setContentOffset:CGPointMake(offsetx - screenW, 0)];
            //                [UIView animateWithDuration:0.2 animations:^{
            //                 [self.textsScroller setContentOffset:CGPointMake(offsetx - screenW, 0)];
            //          }];
        }else{
            [self upChapterContent];
        }

    }else if (CGRectContainsPoint(centerTap, tapPoint)){
        NSLog(@"中");
        [self showTools];
        
    }
    
    
}
//字体大小判断
-(BOOL)fontChange{
    pageSeparationTools *tools = [pageSeparationTools sharepageSeparationTools];
    if (tools.fontsize >=20 || tools.fontsize <10){
        return NO;
    }else{
        return YES;
    }
}

//显示或者隐藏菜单
-(void)showTools{

    if (self.topView.constant == -84) {

        self.topView.constant = -20;
        self.toolsBottomLayout.constant = 0;
//        self.fontView.y = screenH;
        [UIView animateWithDuration:0.3 animations:^{
             self.fontView.y = screenH -80-44;
            self.colortView.y = screenH;
//            self.fontView.y = screenH -122;
        }];
    }else{

        self.topView.constant = -84;
        self.toolsBottomLayout.constant = -44;
        [UIView animateWithDuration:0.3 animations:^{
            self.fontView.y = screenH;
            self.colortView.y = screenH;
//            self.fontView.y = screenH -122;
        }];

    }

    [UIView animateWithDuration:0.3 animations:^{
//        self.fontView.y = 0;
        [self.view layoutIfNeeded];
    }];

}
-(void)hidenTools{
    if (self.toolsBottomLayout.constant == 0) {
        self.topView.constant = -84;
        self.toolsBottomLayout.constant = -44;

    }
    [UIView animateWithDuration:0.3 animations:^{
        self.fontView.y   = screenH;
        self.colortView.y = screenH;
        [self.view layoutIfNeeded];
    }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self showTools];
    catalogueViewController *vc = segue.destinationViewController;
    vc.delegate = self;
    vc.catalogueArray = self.capArray;
    vc.index = indexs;

}
#pragma mark - 一些委托
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSUInteger offsex = scrollView.contentOffset.x;

    if (offsex%(NSUInteger)screenW ==0) {
        pageIndexs = offsex/(NSUInteger)screenW;
        self.pageNumber.text = [NSString stringWithFormat:@"%lu/%lu",pageIndexs +1,(unsigned long)[pageSeparationTools sharepageSeparationTools].pageArray.count];
    }
    
}
//目录点击回调
-(void)backChapter:(Chapter *)chapter{
    [self backChapterContent:chapter];

}

-(void)selectColor:(UIColor *)color{
    self.textsScroller.backgroundColor = color;
    NSUserDefaults *deful = [NSUserDefaults standardUserDefaults];

    if (color == [UIColor grayColor]) {
        [deful setValue:@"gray" forKey:@"colors"];
    }else if (color == [UIColor whiteColor]){
        [deful setValue:@"white" forKey:@"colors"];
    }else{
        [deful setValue:@"yellow" forKey:@"colors"];
    }


}
-(void)changeFont:(changeFont)change{
    NSMutableArray *arr = [NSMutableArray new];
    switch (change) {
        case big:
          arr = [[pageSeparationTools sharepageSeparationTools] upBIGFont];
            break;
        case small:
          arr = [[pageSeparationTools sharepageSeparationTools] upSamilFont];
            break;
        case restore:
          arr = [[pageSeparationTools sharepageSeparationTools] upRestoreFont];
            break;
        default:
            break;
    }
    if ([self fontChange]) {
        [self textViewChangeWithArray:arr];
        self.pageNumber.text = [NSString stringWithFormat:@"%lu/%lu" ,(NSUInteger)self.textsScroller.contentOffset.x/(NSUInteger)screenW +1,[pageSeparationTools sharepageSeparationTools].pageArray.count];
    }
    

}
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.colortView.delegate = self;
    self.fontView.delegate = self;
    [self.view addSubview:self.fontView];
    [self.view addSubview:self.colortView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMark) name:@"background" object:nil];
//    初始化scroll

    [self allocScrollview];
    [self loadLastTime];
    allowEnable = YES;
    [self.view insertSubview:self.chapterLabei aboveSubview:self.textsScroller];
    [self.view insertSubview:self.pageNumber aboveSubview:self.textsScroller];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 一些方法
/**
 *  保存书签
 */

-(void)saveMark{
//    放置数组为空
    if (!self.capArray) return;
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
//    取出当前目录位置
    Chapter *temp;
    Book *bookMake = [Book MR_findFirstByAttribute:@"booksUrl" withValue:self.model.booksUrl];
    if (indexs < self.capArray.count -1) {
        temp = self.capArray[indexs];
    }else{
        NSLog(@"数据不同步");
        temp = self.capArray.lastObject;
    }

//    当前页面
    pageIndexs = pageIndexs?pageIndexs:1;
    NSNumber *nub = [NSNumber numberWithInteger:pageIndexs];
//    NSLog(@"Chapter-save%@",temp.chapterString);
//    字体大小
    CGFloat font = [pageSeparationTools sharepageSeparationTools].fontsize;
    font  =  font?font:14;
//    当前文字
    currString = currString?currString:@"网络错误";
    NSDictionary *dic = @{@"url":temp.chapterUrl,@"string":currString,@"index":nub,@"fontsize":@(font)};
    bookMake.bookmake = dic;
    [defaultContext MR_saveToPersistentStoreAndWait];
//    NSLog(@"save");

}

-(void)textViewChangeWithArray:(NSMutableArray *)stringArray{
    for (UITextView *remo in self.textsScroller.subviews) {
        [remo removeFromSuperview];
    }
    [self allocTxtViewWith:stringArray];
}
/**
 *  添加textview
 */
-(void)allocTxtViewWith:(NSMutableArray *)arr{
    NSUInteger index = arr.count;
    self.textsScroller.contentSize = CGSizeMake(screenW *index, screenH);
    for (int i = 0; i < index; i++) {
            self.txtView = [[UITextView alloc] initWithFrame:CGRectMake(i*screenW+20, 20, screenW -40, screenH -20)];
            self.txtView.editable = NO;
            self.txtView.backgroundColor = [UIColor clearColor];
            self.txtView.attributedText = arr[i];
            self.txtView.scrollEnabled = NO;
            self.txtView.userInteractionEnabled = NO;
            [self.textsScroller addSubview:self.txtView];
    }
}

/**
 *  阅读界面启动操作
 */
-(void)loadLastTime{
    [self.hub show:YES];
    /*
     1.判断书签存不存在


     1.1存在 读取书签


     1.2不存在 请求第一章

     */
//    Book *bookMake = [Book MR_findFirstByAttribute:@"booksUrl" withValue:self.model.booksUrl];
    if (self.model.bookmake) {
//        书签存在
        NSDictionary *mark = self.model.bookmake;
        NSString *url      = [mark valueForKey:@"url"];
        NSString *string   = [mark valueForKey:@"string"];
        NSUInteger pageNum =[[mark valueForKey:@"index"] integerValue];
        NSUInteger fontsize = [[mark valueForKey:@"fontsize"] integerValue];
        NSLog(@"mark \n url%@ \n string \n pageNum%lu",url,(unsigned long)pageNum);
        [self startMark:string index:pageNum chapterUrl:url fontsize:fontsize];
        self.capArray = (NSMutableArray *)[Chapter MR_findByAttribute:@"book.booksUrl" withValue:self.model.booksUrl andOrderBy:@"chapterUrl" ascending:YES];
        if (self.capArray) {
            Chapter *chapter = [Chapter MR_findFirstByAttribute:@"chapterUrl" withValue:url];
            [self.capArray enumerateObjectsUsingBlock:^(Chapter *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([chapter.chapterUrl isEqualToString:obj.chapterUrl]) {

                    indexs = idx;

                    
                }
            }];
        }
        [self.hub hide:YES];
    }else{
        if (self.model.booksUrl == nil) {
            return;
        }
        [[NetWorkTools shareNetWorkTools] booksFirstReadChapterWithBookurl:self.model.booksUrl GET: [@"http://m.ybdu.com"  stringByAppendingString:[self.model.booksUrl stringByReplacingOccurrencesOfString:@"xiazai" withString:@"xiaoshuo"] ] Succees:^(NSArray *books) {
            NSArray *tt = books;
            for (Chapter *res in tt) {
                NSLog(@"%@%@",res.chapterUrl,res.chapterString);
            }
            Chapter  *model = books.firstObject;
            indexs = [books indexOfObject:model];
            self.capArray = (NSMutableArray *)books;
            NSLog(@"%@%@",self.model.booksUrl,model.chapterUrl);
            NSString *chap = [[@"http://m.ybdu.com"  stringByAppendingString:[self.model.booksUrl stringByReplacingOccurrencesOfString:@"xiazai" withString:@"xiaoshuo"] ] stringByAppendingString:model.chapterUrl];

            [[NetWorkTools shareNetWorkTools] bookChapterContentGET:chap Succees:^(id books) {
                currString = books;
                NSMutableArray *arr = [[pageSeparationTools sharepageSeparationTools] pageSeparationWithSting:books];
                [self allocTxtViewWith:arr];
                self.chapterLabei.text = [NetWorkTools shareNetWorkTools].currChaperString;
                self.pageNumber.text = [NSString stringWithFormat:@"1/%lu",arr.count];
                [self.hub hide:YES];
            } Error:^(NSError *error) {

            }];

        } Error:^(NSError *error) {

        }];
    }




    [[NetWorkTools shareNetWorkTools] booksAllChapterGET:[@"http://www.ybdu.com" stringByAppendingString:[self.model.booksUrl stringByReplacingOccurrencesOfString:@"xiazai" withString:@"xiaoshuo"]] Succees:^(NSMutableArray *books) {

        Book *booksCoreDate = [Book MR_findFirstByAttribute:@"booksUrl" withValue:self.model.booksUrl];
        if (booksCoreDate.chapter.count != books.count) {
            NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
            NSArray *tm =[Chapter MR_findByAttribute:@"book.booksUrl" withValue:self.model.booksUrl andOrderBy:@"chapterUrl" ascending:YES];
            [booksCoreDate removeChapter:[NSSet setWithArray:tm]];
            [booksCoreDate addChapter:[NSSet setWithArray:books]];
            [defaultContext MR_saveToPersistentStoreAndWait];
        }else{
            NSLog(@"没变化");
        }

        self.capArray = (NSMutableArray *)[Chapter MR_findByAttribute:@"book.booksUrl" withValue:self.model.booksUrl andOrderBy:@"chapterUrl" ascending:YES];


    } Error:^(NSError *error) {

    }];



}
-(void)loadCacheModel:(Chapter *)chapter{
    for (UITextView *remo in self.textsScroller.subviews) {
        [remo removeFromSuperview];
    }
    currString = chapter.content.contentString;
    NSMutableArray *arr = [[pageSeparationTools sharepageSeparationTools] pageSeparationWithSting:currString];
    [self allocTxtViewWith:arr];
    [self.textsScroller setContentOffset:CGPointMake(0, 0)];
    pageIndexs = 1;
    self.chapterLabei.text = [chapter.chapterString stringByReplacingOccurrencesOfString:@"\n\t" withString:@""];
    self.pageNumber.text = [NSString stringWithFormat:@"1/%lu",arr.count];
}
-(void)loadCacheString:(NSString *)stt{
    for (UITextView *remo in self.textsScroller.subviews) {
        [remo removeFromSuperview];
    }
    currString = stt;
    NSMutableArray *arr = [[pageSeparationTools sharepageSeparationTools] pageSeparationWithSting:currString];
    [self allocTxtViewWith:arr];
    [self.textsScroller setContentOffset:CGPointMake(0, 0)];
    pageIndexs = 1;
    self.chapterLabei.text = [NetWorkTools shareNetWorkTools].currChaperString;
    self.pageNumber.text = [NSString stringWithFormat:@"1/%lu",arr.count];
}
//下一章
-(void)newChapterContent{
    [self.hub show:YES];
    self.capArray = (NSMutableArray *)[Chapter MR_findByAttribute:@"book.booksUrl" withValue:self.model.booksUrl andOrderBy:@"chapterUrl" ascending:YES];

    if (indexs+1 >= self.capArray.count) return;
    indexs++;
    Chapter  *modelss = self.capArray[indexs];
    if (modelss.content.contentString) {
        [self loadCacheModel:modelss];
        [self.hub hide:YES];
    }else{

    NSString *url = [[@"http://m.ybdu.com"  stringByAppendingString:[self.model.booksUrl stringByReplacingOccurrencesOfString:@"xiazai" withString:@"xiaoshuo"] ] stringByAppendingString:modelss.chapterUrl];
    [[NetWorkTools shareNetWorkTools] bookChapterContentGET:url Succees:^(id books) {
        [self loadCacheString:books];
        [self.hub hide:YES];
    } Error:^(NSError *error) {

    }];
    }

}
//上一章
-(void)upChapterContent{
    [self.hub show:YES];
    self.capArray = (NSMutableArray *)[Chapter MR_findByAttribute:@"book.booksUrl" withValue:self.model.booksUrl andOrderBy:@"chapterUrl" ascending:YES];
    indexs--;
    if (indexs  == -1){
        indexs = 0;
        return;
    };
    Chapter  *modelss = self.capArray[indexs];
    NSString *url = [[@"http://m.ybdu.com"  stringByAppendingString:[self.model.booksUrl stringByReplacingOccurrencesOfString:@"xiazai" withString:@"xiaoshuo"] ] stringByAppendingString:modelss.chapterUrl];
    [[NetWorkTools shareNetWorkTools] bookChapterContentGET:url Succees:^(id books) {
        for (UITextView *remo in self.textsScroller.subviews) {
            [remo removeFromSuperview];
        }
        currString = books;
        NSMutableArray *arr = [[pageSeparationTools sharepageSeparationTools] pageSeparationWithSting:books];
//        self.textsScroller.contentSize = CGSizeMake(screenW *arr.count, screenH);
        [self allocTxtViewWith:arr];
        [self.textsScroller setContentOffset:CGPointMake(screenW *(arr.count -1), 0)];
        pageIndexs = arr.count;
        self.chapterLabei.text = [NetWorkTools shareNetWorkTools].currChaperString;
        self.pageNumber.text = [NSString stringWithFormat:@"%lu/%lu",arr.count,arr.count];

        [self.hub hide:YES];
    } Error:^(NSError *error) {

    }];
}
//目录点击回调解析
-(void)backChapterContent:(Chapter *)model{
    [self.hub show:YES];
    self.capArray = (NSMutableArray *)[Chapter MR_findByAttribute:@"book.booksUrl" withValue:self.model.booksUrl andOrderBy:@"chapterUrl" ascending:YES];
    [self.capArray enumerateObjectsUsingBlock:^(Chapter *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.chapterUrl isEqualToString:obj.chapterUrl]) {
            indexs = idx;
            if (obj.content.contentString) {
                [self loadCacheModel:obj];
                return ;
            }else{
                NSString *url = [[@"http://m.ybdu.com"  stringByAppendingString:[self.model.booksUrl stringByReplacingOccurrencesOfString:@"xiazai" withString:@"xiaoshuo"] ] stringByAppendingString:model.chapterUrl];
                [[NetWorkTools shareNetWorkTools] bookChapterContentGET:url Succees:^(id books) {
                    [self loadCacheString:books];
                    } Error:^(NSError *error) {
                    
                }];

            }
        }
    }];
    [self.hub hide:YES];

}
//解析书签
-(void)startMark:(NSString *)text index:(NSUInteger)currNumber chapterUrl:(NSString *)string fontsize:(CGFloat)size{
    if (self.txtView) {
        NSLog(@"还在");
        return;
    }
    if (size) {
        [pageSeparationTools sharepageSeparationTools].fontsize = size;
    }
    NSMutableArray *arr = [[pageSeparationTools sharepageSeparationTools] pageSeparationWithSting:text];
//    self.textsScroller.contentSize = CGSizeMake(screenW *arr.count, screenH);
    [self allocTxtViewWith:arr];
    [self.textsScroller setContentOffset:CGPointMake(screenW * currNumber, 0)];
    pageIndexs = currNumber;
    currString = text;
    Chapter *cs = [Chapter MR_findFirstByAttribute:@"chapterUrl" withValue:string];
    self.chapterLabei.text = [cs.chapterString stringByReplacingOccurrencesOfString:@"\n\t" withString:@""];
    self.pageNumber.text = [NSString stringWithFormat:@"%lu/%lu",currNumber+1,arr.count];
    self.capArray = (NSMutableArray *)[Chapter MR_findByAttribute:@"book.booksUrl" withValue:self.model.booksUrl andOrderBy:@"chapterUrl" ascending:YES];

}


/**
 *  缓存alert
 */
-(void)chapterCacheAlert{
    UIAlertController *cache = [UIAlertController alertControllerWithTitle:@"缓存" message:@"123" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *nextFiveChaptr = [UIAlertAction actionWithTitle:@"缓存5章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cacheContentStringWithCount:5];
    }];
    UIAlertAction *nextTenChaptr = [UIAlertAction actionWithTitle:@"缓存10章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cacheContentStringWithCount:10];
    }];
    UIAlertAction *nextAllChaptr = [UIAlertAction actionWithTitle:@"缓存全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cacheContentStringWithCount:0];
    }];
    UIAlertAction *cancl = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

    }];
    [cache addAction:nextFiveChaptr];
    [cache addAction:nextTenChaptr];
    [cache addAction:nextAllChaptr];
    [cache addAction:cancl];
    [self presentViewController:cache animated:YES completion:^{

    }];
}
-(void)cacheContentStringWithCount:(NSUInteger)count{
    NSUInteger arrCount = self.capArray.count;
    NSUInteger cacheIndex = count + indexs;
    NSRange range;
    if (count) {
//        1.判断当前章节之后是否有足够章节
        if (cacheIndex < arrCount) {
            range = NSMakeRange(indexs+1, count);

        }else{
//             2.没有有足够章节，缓存后续全部
             range = NSMakeRange(indexs+1, arrCount -1 - indexs);
        }

    }else{
//缓存全部
        range = NSMakeRange(indexs+1, arrCount -1 - indexs);
    }
    if (self.capArray) {
        NSMutableArray *temp = (NSMutableArray *)[self.capArray subarrayWithRange:range];
        [[NetWorkTools shareNetWorkTools] bookChapterContentGETwithArray:temp bookUrl:self.model.booksUrl Succees:^(id books) {

        } Error:^(NSError *error) {

        }];
    }
    

}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
