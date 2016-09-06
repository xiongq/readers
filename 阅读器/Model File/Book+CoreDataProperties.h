//
//  Book+CoreDataProperties.h
//  阅读器
//
//  Created by xiong on 16/9/2.
//  Copyright © 2016年 xiong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) id bookmake;
@property (nullable, nonatomic, retain) NSString *booksName;
@property (nullable, nonatomic, retain) NSString *booksUrl;
@property (nonatomic) BOOL haveUP;
@property (nullable, nonatomic, retain) NSString *lastChapter;
@property (nullable, nonatomic, retain) NSSet<Chapter *> *chapter;

@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addChapterObject:(Chapter *)value;
- (void)removeChapterObject:(Chapter *)value;
- (void)addChapter:(NSSet<Chapter *> *)values;
- (void)removeChapter:(NSSet<Chapter *> *)values;

@end

NS_ASSUME_NONNULL_END
