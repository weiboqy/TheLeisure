//
//  RadioDetailListDB.h
//  Leisure
//
//  Created by lanou on 16/4/13.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "FMDB.h"
#import "RadioDetailListModel.h"


@interface RadioDetailListDB : NSObject

/** 数据库操作对象 */
@property (strong, nonatomic)FMDatabase *dataBase;

/** 创建数据表 */
- (void)createDataTable;

/** 保存一条数据 */
/** 将模型数据和本地的音频路径保存到数据表中 */
- (void)saveDataWithModel:(RadioDetailListModel *)model andPath:(NSString *)path;

/** 删除一条数据 */
- (void)deleteDetailWithTitle:(NSString *)title;

/** 查询所有数据 */
- (NSArray *)findWithUserID:(NSString *)UserID;


@end
