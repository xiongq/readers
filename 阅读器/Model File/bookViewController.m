//
//  bookViewController.m
//  CoreData-Demo
//
//  Created by xiong on 16/9/1.
//  Copyright © 2016年 刘小壮. All rights reserved.
//

#import "bookViewController.h"
#import <CoreData/CoreData.h>
#import "Book.h"
#import "Chapter.h"
#import "Content.h"

@interface bookViewController ()
@property (nonatomic, strong) NSManagedObjectContext *bookMOC;
@end

@implementation bookViewController
- (NSManagedObjectContext *)bookMOC {
    if (!_bookMOC) {
        _bookMOC = [self contextWithModelName:@"bookCoredata"];
    }
    return _bookMOC;
}
- (NSManagedObjectContext *)contextWithModelName:(NSString *)modelName {
    // 创建上下文对象，并发队列设置为主队列
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

    // 创建托管对象模型，并使用Company.momd路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];

    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", modelName];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];

    // 上下文对象设置属性为持久化存储器
    context.persistentStoreCoordinator = coordinator;

    return context;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)add:(id)sender {
    Chapter *chapter = [NSEntityDescription insertNewObjectForEntityForName:@"Chapter" inManagedObjectContext:self.bookMOC] ;
    chapter.chapterUrl =  @"make1123";
    chapter.chapterString = @"第一章";
    Chapter *chapter1 = [NSEntityDescription insertNewObjectForEntityForName:@"Chapter" inManagedObjectContext:self.bookMOC] ;
    chapter1.chapterUrl =  @"mak121222222233";
    chapter1.chapterString = @"第2章";

    Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.bookMOC];
    book.booksName = @"xuxuxuux";
    book.booksUrl = @"http";
    book.bookmake = @{@"ma":@"dads"};
    [book addChapterObject:chapter];
    [book addChapterObject:chapter1];

    Content *content = [NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:self.bookMOC];
    content.contentString = @"duhaiuhsdioajsdadioahfiuajdiojaiodhaoisdujp;alosdiaopsdiaposdipaoisdap[sjdkmnfkjyfaiojdoiakdsak;dk;akd;akd;ka;dka;kda;kd;aknmnkmnkshdiah大hi殴打奇偶肯德基点击京东卡骄傲的骄傲了扩大 看大家考虑到是巨大就打了的矫情无二亲朋的；  的奇偶奥就看到了；奥迪 欺骗我破口跑去问麂皮绒去委屈就问了句冷酷的期望好看";
    chapter.content = content;

    Content *content1 = [NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:self.bookMOC];
    content1.contentString = @"实体可以在实体中创建继承关系，在一个实体的菜单栏中通过Parent Entity可以设置父实体，这样就存在了实体的继承关系，最后创建出来的托管模型类也是具有继承关系的。注意继承关系中属性名不要相同使用了这样的继承关系后，系统会将子类继承父类的数据，存在父类的表中，所有继承自同一父类的子类都会将父类部分存放在父类的表中。这样可能会导致父类的表中数据量过多，造成性能问题";
    chapter1.content = content1;


//    chapter.book = book;

    NSError *error = nil;
    if (self.bookMOC.hasChanges) {
        [self.bookMOC save:&error];
    }
//        NSLog(@"book %@  ---- book.chapter%@",book,book.chapter);
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
    }

}
- (IBAction)delete:(id)sender {

    // 创建请求对象，并指明对Student表做操作
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
//    // 通过谓词设置过滤条件，设置条件为age小于20
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age < %ld", 20];
//    fetchRequest.predicate = predicate;

    // 创建批量删除请求，并使用上面创建的请求对象当做参数进行初始化
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    // 设置请求结果类型，设置为受影响对象的Count
    deleteRequest.resultType = NSBatchDeleteResultTypeCount;

    // 使用NSBatchDeleteResult对象来接受返回结果，通过id类型的属性result获取结果
    NSError *error = nil;
    NSBatchDeleteResult *result = [self.bookMOC executeRequest:deleteRequest error:&error];
    NSLog(@"batch delete request result count is %ld", [result.result integerValue]);

    // 错误处理
    if (error) {
        NSLog(@"batch delete request error : %@", error);
    }

    // 更新MOC中的托管对象，使MOC和本地持久化区数据同步
    [self.bookMOC refreshAllObjects];
}
- (IBAction)change:(id)sender {
}
- (IBAction)cha:(id)sender {
}

- (IBAction)result:(id)sender {
    // 建立获取数据的请求对象，指明操作的实体为Student
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"booksName = %@", @"xuxuxuux"];
        request.predicate = predicate;

    NSError *error = nil;
    NSArray<Book *> *students = [self.bookMOC executeFetchRequest:request error:&error];
//    Chapter *chapter = [NSEntityDescription insertNewObjectForEntityForName:@"Chapter" inManagedObjectContext:self.bookMOC] ;

    // 遍历输出查询结果
    [students enumerateObjectsUsingBlock:^(Book * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"book Name : %@, url : %@ --%lu ",obj.booksName, obj.chapter, obj.chapter.count);
//        NSLog(@"book chap : %@ ", obj.chapter);
    }];

    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
}
@end
