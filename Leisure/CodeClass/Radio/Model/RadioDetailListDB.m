//
//  RadioDetailListDB.m
//  Leisure
//
//  Created by lanou on 16/4/13.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioDetailListDB.h"

@implementation RadioDetailListDB

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataBase = [DBManager defaultDBManager:@"leisure.sqlite"].dataBase;
    }
    return self;
}


/** 创建数据表 */
- (void)createDataTable {
    //查询数据表中的元素个数
    FMResultSet *set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'", RADIODETAILTABLE]];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        QYLog(@"数据表已经存在");
    }else {
        //创建新的数据表
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (radioID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, userID text,coverimg text, isnew INTEGER, musicUrl text, title text, musicVisit text, path text)", RADIODETAILTABLE];
        BOOL res = [_dataBase executeUpdate:sql];
        if (!res) {
            QYLog(@"数据库创建成功");
        }else {
            QYLog(@"数据表创建成功");
        }
    }
}

/** 保存一条数据 */
/** 将模型数据和本地的音频路径保存到数据表中 */
- (void)saveDataWithModel:(RadioDetailListModel *)model andPath:(NSString *)path {
    //创建插入语句
    NSMutableString *query = [NSMutableString stringWithFormat:@"INSERT INTO %@ (userID, coverimg, isnew, musicUrl, title, musicVisit, path) values (?,?,?,?,?,?,?)",RADIODETAILTABLE];
    //创建插入内容
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:0];
    if (![[UserInfoManager getUserID] isEqualToString:@" "]) {
        [arguments addObject:[UserInfoManager getUserID]];
    }
    [arguments addObject:model.coverimg];
    [arguments addObject:@(model.isnew)];
    [arguments addObject:model.musicUrl];
    [arguments addObject:model.title];
    [arguments addObject:model.musicVisit];
    [arguments addObject:path];
    QYLog(@"query = %@", query);
    QYLog(@"成功下载一条数据");
    
    //执行语句
    [_dataBase executeUpdate:query withArgumentsInArray:arguments];
}

//删除一条数据
- (void)deleteDetailWithTitle:(NSString *)title{
    NSString *query = [NSString stringWithFormat:@"DELETE FROm %@ WHERE title = '%@'", RADIODETAILTABLE, title];
    [_dataBase executeUpdate:query];
    QYLog(@"删除成功");
}

//查询所有数据
- (NSArray *)findWithUserID:(NSString *)UserID {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserID = '%@'",RADIODETAILTABLE, UserID];
    FMResultSet *set = [_dataBase executeQuery:query];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[set columnCount]];
    while ([set next]) {
        RadioDetailListModel *model = [[RadioDetailListModel alloc]init];
        model.coverimg = [set stringForColumn:@"coverimg"];
        model.musicUrl = [set stringForColumn:@"musicUrl"];
        model.title = [set stringForColumn:@"title"];
        model.musicVisit = [set stringForColumn:@"musicVisit"];

        [array addObject:model];
    }
    [set close];
    return array;
}
@end
