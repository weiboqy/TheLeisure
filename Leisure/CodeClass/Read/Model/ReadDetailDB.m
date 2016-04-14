//
//  ReadDetailDB.m
//  Leisure
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadDetailDB.h"

@implementation ReadDetailDB

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataBase = [DBManager defaultDBManager:@"leisure.sqlite"].dataBase;
    }
    return self;
}

//创建数据表
- (void)createDataTable{
    //查询数据表中的元素个数
    FMResultSet *set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'", READDETAILTABLE]];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        QYLog(@"数据表已经存在");
    }else {
        //创建新的数据表
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (readID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, userID text, title text, contentID text, content text, name  text, coverimg text)", READDETAILTABLE];
        BOOL res = [_dataBase executeUpdate:sql];
        if (!res) {
            QYLog(@"数据库创建成功");
        }else {
            QYLog(@"数据表创建成功");
        }
    }
}

//插入一条数据
- (void)saveDetailModel:(ReadDetailModel *)detailModel{
    //创建插入语句
    NSMutableString *query = [NSMutableString stringWithFormat:@"INSERT INTO %@ (userID, title, contentid, content, name, coverimg) values (?,?,?,?,?,?)",READDETAILTABLE];
    //创建插入内容
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:0];
    if (![[UserInfoManager getUserID] isEqualToString:@" "]) {
        [arguments addObject:[UserInfoManager getUserID]];
    }
    if (detailModel.title) {
        [arguments addObject:detailModel.title];
    }
    if (detailModel.contentID) {
        [arguments addObject:detailModel.contentID];
    }
    if (detailModel.content) {
        [arguments addObject:detailModel.content];
    }
    if (detailModel.name) {
        [arguments addObject:detailModel.name];
    }
    if (detailModel.coverimg) {
        [arguments addObject:detailModel.coverimg];
    }
    QYLog(@"%@", query);
    QYLog(@"收藏成功一条数据");
    
    //执行语句
    [_dataBase executeUpdate:query withArgumentsInArray:arguments];
}

//删除一条数据
- (void)deleteDetailWithTitle:(NSString *)detailTitle{
    NSString *query = [NSString stringWithFormat:@"DELETE FROm %@ WHERE title = '%@'", READDETAILTABLE, detailTitle];
   [_dataBase executeUpdate:query];
    QYLog(@"删除成功");
}

//查询所有数据
- (NSArray *)findWithUserID:(NSString *)userID{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userID = '%@'",READDETAILTABLE, userID];
    FMResultSet *set = [_dataBase executeQuery:query];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[set columnCount]];
    while ([set next]) {
        ReadDetailModel *detailModel = [[ReadDetailModel alloc]init];
        detailModel.title = [set stringForColumn:@"title"];
        detailModel.content = [set stringForColumn:@"content"];
        detailModel.contentID = [set stringForColumn:@"contentid"];
        detailModel.coverimg = [set stringForColumn:@"coverimg"];
        detailModel.name = [set stringForColumn:@"name"];
        [array addObject:detailModel];
    }
    [set close];
    return array;
}

@end
