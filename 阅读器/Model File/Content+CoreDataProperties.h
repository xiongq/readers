//
//  Content+CoreDataProperties.h
//  CoreData-Demo
//
//  Created by xiong on 16/9/1.
//  Copyright © 2016年 刘小壮. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Content.h"

NS_ASSUME_NONNULL_BEGIN

@interface Content (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *contentString;
@property (nullable, nonatomic, retain) Chapter *chapter;

@end

NS_ASSUME_NONNULL_END
