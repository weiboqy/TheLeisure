//
//  ReadDetailModel.h
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"

@interface ReadDetailModel : BaseModel

/** 内容 */
@property (copy, nonatomic)NSString *content;
/** 图片 */
@property (copy, nonatomic)NSString *coverimg;
/** 设备ID */
@property (copy, nonatomic)NSString *contentID;
/** 主题 */
@property (copy, nonatomic)NSString *name;
/** 文章标题 */
@property (copy, nonatomic)NSString *title;


@end
