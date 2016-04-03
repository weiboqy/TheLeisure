//
//  RadioDetailViewController.h
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RadioListModel.h"


@interface RadioDetailViewController : BaseViewController

/**radioID*/
@property (copy, nonatomic)NSString *radioid;

@property (strong, nonatomic)RadioListModel *model;



@end
