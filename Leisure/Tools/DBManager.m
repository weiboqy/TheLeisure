//
//  DBManager.m
//  Leisure
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

static DBManager *_dbManager = nil;
+ (DBManager *)defaultDBManager:(NSString *)dbName {
    //互斥锁
    @synchronized(self) {
        if (!_dbManager) {
            _dbManager = [[DBManager alloc]initWithdbName:dbName];
        }
    }
    return _dbManager;
}

- (instancetype)initWithdbName:(NSString *)dbName {
    self = [super init];
    if (self) {
        if (!dbName) {
            //数据库名不存在
            QYLog( @"创建数据库失败!");
        }else {
            //获取沙盒路径
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            //创建数据库路径
            NSString *dbPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", dbName]];
            BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
            //exist ＝＝ 0 创建路径成功 , 1路径已经存在
            if (!exist) {
                QYLog(@"数据库路径:%@",dbPath);
            }else {
                QYLog(@"数据库路径:%@",dbPath);
            }
            [self openDB:dbPath];
        }
    }
    return self;
}

//打开数据库
- (void)openDB:(NSString *)dbPath {
    if (!_dataBase) {
        self.dataBase = [FMDatabase databaseWithPath:dbPath];
    }
    if (![_dataBase open]) {
        QYLog(@"不能打开数据库");
    }
}

//关闭数据库
- (void)closeDB {
    [_dataBase close];
    _dbManager = nil;
}

//销毁数据库
- (void)dealloc {
    [self closeDB];
}
@end
