//
//  TopicListModel.h
//  Leisure
//
//  Created by lanou on 16/3/30.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"
#import "TopicCounterListModel.h"
#import "TopicUserInfoModel.h"

@interface TopicListModel : BaseModel

/**时间戳*/
@property (copy, nonatomic)NSString *addtime;
/**时间间隔*/
@property (copy, nonatomic)NSString *addtime_f;
/**内容*/
@property (copy, nonatomic)NSString *content;
/**话题ID*/
@property (copy, nonatomic)NSString *contentid;
/**图片地址*/
@property (copy, nonatomic)NSString *coverimg;
/**标题*/
@property (copy, nonatomic)NSString *title;

/**计数对象*/
@property (strong, nonatomic)TopicCounterListModel *counterList;
/**作者信息*/
@property (strong, nonatomic)TopicUserInfoModel *userinfo;


@end
