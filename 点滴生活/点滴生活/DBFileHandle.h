//
//  DBFileHandle.h
//  点滴生活
//
//  Created by qingyun on 16/2/25.
//  Copyright © 2016年 lily. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DetailModel;

@interface DBFileHandle : NSObject

//单例
+ (instancetype)shareHandle;

/**
 *插入数据
 */
- (BOOL)insertData2detailTable:(DetailModel *)model;

/*
 *查询所有数据
 */
-(NSMutableArray *)selectValueAllfromdetailTable;

/**
 *删除所有的数据
 */
- (BOOL)deleteAllData:(NSString *)tableName;

@end
