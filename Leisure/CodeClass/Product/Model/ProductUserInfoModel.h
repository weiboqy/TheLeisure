//
//  ProductUserInfoModel.h
//  Leisure
//
//  Created by lanou on 16/3/30.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"

@interface ProductUserInfoModel : BaseModel


/**用户ID*/
@property (copy, nonatomic)NSString *uid;
/**用户名*/
@property (copy, nonatomic)NSString *uname;
/**头像*/
@property (copy, nonatomic)NSString *icon;

@end
