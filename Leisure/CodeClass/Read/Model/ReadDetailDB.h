//
//  ReadDetailDB.h
//  Leisure
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"
#import "DBManager.h"
#import "ReadDetailModel.h"

@interface ReadDetailDB : BaseModel

@property (strong, nonatomic)FMDatabase *dataBase;

//创建数据表
- (void)createDataTable;

//插入一条数据
- (void)saveDetailModel:(ReadDetailModel *)detailModel;

//删除一条数据
- (void)deleteDetailWithTitle:(NSString *)detailTitle;

//查询所有数据
- (NSArray *)findWithUserID:(NSString *)userID;


@end
