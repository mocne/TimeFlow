//
//  DBFileHandle.m
//  点滴生活
//
//  Created by qingyun on 16/2/25.
//  Copyright © 2016年 lily. All rights reserved.
//

#import "DBFileHandle.h"
#import "FMDB.h"
#import "DetailModel.h"
#import "LLCommon.h"

#define DBName  @"llData.db"
#define detailTable  @"detailTable"

@interface DBFileHandle ()
//创建数据库对象
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation DBFileHandle

+ (instancetype)shareHandle
{
    static DBFileHandle *handle;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handle = [[DBFileHandle alloc] init];
        //初始化调用一次
        [handle createdetailTable];
    });
    return handle;
}

- (NSString *)libaryPath
{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
}

- (FMDatabase *)db
{
    if (_db) {
        return _db;
    }
    //1.合并文件路径
    NSString *dbPath = [[self libaryPath] stringByAppendingPathComponent:DBName];
    
    _db = [FMDatabase databaseWithPath:dbPath];
    NSLog(@"%@",dbPath);
    return _db;
}


//创建详情的列表
- (BOOL)createdetailTable
{
    if (![self.db open]) {
        NSLog(@">>>%@",[self.db lastErrorMessage]);
        return NO;
    }
    
    if (![self.db executeUpdate:@"create table if not exists detailTable(textStr text ,locationStr text , imageData data, timeStr text primary key not null ,labelStr text)"]) {
        NSLog(@"><<<<%@",[self.db lastErrorMessage]);
        [self.db close];
        return NO;
    }
    [self.db close];
    return YES;
}

/**
 *插入数据
 */
//detailTable
- (BOOL)insertData2detailTable:(DetailModel *)model{
    //打开数据库
    if (![self.db open]) {
        NSLog(@"========%@",[self.db lastErrorMessage]);
        return NO;
    }
    if (![self.db executeUpdate:@"insert into detailTable values (?,?,?,?,?)",model.textStr,model.locationStr,model.imageData,model.timeStr,model.labelStr])
    {
        [self.db close];
        return NO;
    }
    
    [self.db close];
    return YES;
}

/**
 *查询所有数据
 */
//detailTable
-(NSMutableArray *)selectValueAllfromdetailTable{
    //1打开数据库
    if(![self.db open])return nil;
    //2执行sql语句
    FMResultSet *set=[self.db executeQuery:@"select *from detailTable"];
    //取出数据
    NSMutableArray *tempArr=[NSMutableArray array];
    while ([set next]) {
        //添加model
        DetailModel *model = [[DetailModel alloc] initWithDict:[set resultDictionary]];
        [tempArr addObject:model];
    }
    //关闭数据库
    [self.db close];
    return tempArr;
}

/**
 *删除操作
 */
- (BOOL)deleteAllData:(NSString *)tableName
{
    if (![self.db open]) {
        return NO;
    }
    if ([tableName isEqualToString:detailTable]){
    //详情
        if (![self.db executeUpdate:@"delete from detailTable"]) {
            [self.db close];
            return NO;
        }
    }
    [self.db close];
    return YES;
}


@end
