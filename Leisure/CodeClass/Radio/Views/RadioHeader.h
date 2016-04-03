//
//  RadioHeader.h
//  Leisure
//
//  Created by lanou on 16/4/2.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioListModel.h"
#import "RadioCarouseModel.h"

@interface RadioHeader :UIView

/** 轮播图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 左按钮 */
@property (nonatomic, strong) UIButton *leftBtn;
/** 中间按钮 */
@property (nonatomic, strong) UIButton *midBtn;
/** 右按钮 */
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) RadioListModel *allModel;
@property (nonatomic, strong) RadioCarouseModel *carouseModel;

@end
