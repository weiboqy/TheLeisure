//
//  RadioDetailListModel.h
//  Leisure
//
//  Created by lanou on 16/4/3.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"

@interface RadioDetailListModel : BaseModel

/** 收听量 */
@property (copy, nonatomic)NSString *musicVisit;
/** 标题 */
@property (copy, nonatomic)NSString *title;
/** 歌曲地址 */
@property (copy, nonatomic)NSString *musicUrl;
/** 图片 */
@property (copy, nonatomic)NSString *coverimg;


@end
