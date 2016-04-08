//
//  RadioInfoModel.h
//  Leisure
//
//  Created by lanou on 16/4/3.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"
#import "RadioUserInfoModel.h"
@interface RadioInfoModel : BaseModel

/** 收听总数 */
@property (copy, nonatomic)NSString *musicvisitnum;
/** 图片 */
@property (copy, nonatomic)NSString *coverimg;
/** 描述 */
@property (copy, nonatomic)NSString *desc;
/** 标题 */
@property (copy, nonatomic)NSString *title;

/** 用户信息 */
@property (strong, nonatomic)RadioUserInfoModel *userInfoModel;
@end
