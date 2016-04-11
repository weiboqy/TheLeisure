//
//  TopicInfoViewController.h
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TopicDetailModel.h"

@interface TopicInfoViewController : BaseViewController

@property (assign, nonatomic)NSInteger selecteIndex;
/**话题ID*/
@property (copy, nonatomic)NSString *contentid;

@end
