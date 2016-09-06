//
//  Chapter+CoreDataProperties.h
//  CoreData-Demo
//
//  Created by xiong on 16/9/1.
//  Copyright © 2016年 刘小壮. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chapter (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chapterString;
@property (nullable, nonatomic, retain) NSString *chapterUrl;
@property (nullable, nonatomic, retain) Content *content;
@property (nullable, nonatomic, retain) Book *book;

@end

NS_ASSUME_NONNULL_END
