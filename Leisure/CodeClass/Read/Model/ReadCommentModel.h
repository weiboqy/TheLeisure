//
//  ReadCommentModel.h
//  Leisure
//
//  Created by lanou on 16/4/9.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadUserInfo.h"

@interface ReadCommentModel : NSObject

/** 内容 */
@property (copy, nonatomic)NSString *content;
/** 时间间隔 */
@property (copy, nonatomic)NSString *addtime_f;

@property (strong, nonatomic)ReadUserInfo *userinfo;


@end
