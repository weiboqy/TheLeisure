//
//  RadioDetailHeader.h
//  Leisure
//
//  Created by lanou on 16/4/3.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioInfoModel.h"
#import "RadioUserInfoModel.h"

@interface RadioDetailHeader : UIView

@property (strong, nonatomic)RadioInfoModel *model;

@property (strong, nonatomic)RadioUserInfoModel *userModel;

@end
