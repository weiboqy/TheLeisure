//
//  ReadInfoViewController.h
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ReadDetailModel.h"

@interface ReadInfoViewController : BaseViewController

@property (copy, nonatomic)NSString *contentid;
@property (strong, nonatomic)ReadDetailModel *detailModel;

@end
