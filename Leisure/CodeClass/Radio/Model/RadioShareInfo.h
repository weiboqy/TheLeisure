//
//  RadioShareInfo.h
//  Leisure
//
//  Created by lanou on 16/4/6.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioShareInfo : NSObject

/** 标题 */
@property (copy, nonatomic)NSString *title;
/** 分享内容 */
@property (copy, nonatomic)NSString *sharetext;
/** 图片 */
@property (copy, nonatomic)NSString *pic;
/** 地址 */
@property (copy, nonatomic)NSString *url;
/** 内容 */
@property (copy, nonatomic)NSString *text;

@end
