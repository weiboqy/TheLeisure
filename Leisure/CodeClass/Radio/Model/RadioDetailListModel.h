//
//  RadioDetailListModel.h
//  Leisure
//
//  Created by lanou on 16/4/3.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"
#import "RadioPlayInfo.h"

@interface RadioDetailListModel : BaseModel

/** 收听量 */
@property (copy, nonatomic)NSString *musicVisit;
/** 标题 */
@property (copy, nonatomic)NSString *title;
/** 歌曲地址 */
@property (copy, nonatomic)NSString *musicUrl;
/** 图片 */
@property (copy, nonatomic)NSString *coverimg;
/** 总数 */
@property (assign, nonatomic)NSInteger total;
/** 是否最新 */
@property (assign, nonatomic)BOOL isnew;

//数据库缺的字段
/** 下载保存的文件路径 */
@property (copy, nonatomic)NSString *path;
@property (copy, nonatomic)NSString *UserID;
/**用户名*/
@property (copy, nonatomic)NSString *uname;
@property (copy, nonatomic)NSString *webview_url;

@property (strong, nonatomic)RadioPlayInfo *playInfo;// 播放列表模型


@end
