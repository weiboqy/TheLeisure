//
//  RadioListModel.h
//  Leisure
//
//  Created by lanou on 16/3/30.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"
#import "RadioUserInfoModel.h"
@interface RadioListModel : BaseModel

/**收听次数*/
@property (copy, nonatomic)NSString *count;
/**图片地址*/
@property (copy, nonatomic)NSString *coverimg;
/**内容简介*/
@property (copy, nonatomic)NSString *desc;
/**标记是否是最新*/
@property (assign, nonatomic)BOOL isNew;
/**电台ID*/
@property (copy, nonatomic)NSString *radioid;
/**标题*/
@property (copy, nonatomic)NSString *title;
/**用户信息*/
@property (strong, nonatomic)RadioUserInfoModel *userinfo;




@end
