//
//  FactoryTableViewCell.h
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTableViewCell.h"

@interface FactoryTableViewCell : NSObject

/** 创建cell */
+ (BaseTableViewCell *)creatTableViewCell:(BaseModel *)model;


/** 注册 */
+ (BaseTableViewCell *)creatTableViewCell:(BaseModel *)model tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;



@end
