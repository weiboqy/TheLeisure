//
//  TopicUserInfoModel.h
//  Leisure
//
//  Created by lanou on 16/3/30.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"

@interface TopicUserInfoModel : BaseModel

/**头像*/
@property (copy, nonatomic)NSString *icon;
/**作者id*/
@property (copy, nonatomic)NSString *uid;
/**作者名称*/
@property (copy, nonatomic)NSString *uname;

@end
