//
//  BaseTableViewCell.h
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface BaseTableViewCell : UITableViewCell


/** 赋值方法 */
- (void) setDataWithModel:(BaseModel *)model;

@end
