//
//  DBManager.h
//  Leisure
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"
#import "FMDB.h"

@interface DBManager : BaseModel

/** 数据库操作对象 */
@property (strong, nonatomic)FMDatabase *dataBase;

//单例模式创建数据库 操作对象
// 传入数据库名称，在方法中创建数据库
+ (DBManager *)defaultDBManager:(NSString *)dbName;

//自定义初始化方法
- (instancetype)initWithdbName:(NSString *)dbName;

//关闭数据库
- (void)closeDB;

@end
