//
//  ReadUserInfo.h
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadUserInfo : NSObject

/** 头像 */
@property (copy, nonatomic)NSString *icon;
/** uid */
@property (assign, nonatomic)NSInteger *uid;
/** 昵称 */
@property (copy, nonatomic)NSString *uname;
/** 描述 */
@property (copy, nonatomic)NSString *desc;


@end
