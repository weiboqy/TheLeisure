//
//  RadioPlayViewController.h
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RadioPlayInfo.h"
#import "RadioDetailListModel.h"

@interface RadioPlayViewController : BaseViewController

@property (strong, nonatomic)NSMutableArray *playListArr;  //传入模型数组
@property (assign, nonatomic)NSInteger seleteIndex;  //传入位置信息
@end
