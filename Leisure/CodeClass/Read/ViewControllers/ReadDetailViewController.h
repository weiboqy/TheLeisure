//
//  ReadDetailViewController.h
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ReadDetailViewController : BaseViewController

/** 阅读主题ID */
@property (copy, nonatomic)NSString *typeID;
/** 标题 */
@property (copy, nonatomic)NSString *name;

@end
