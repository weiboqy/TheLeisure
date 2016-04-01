//
//  TopicCounterListModel.h
//  Leisure
//
//  Created by lanou on 16/3/30.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"

@interface TopicCounterListModel : BaseModel

/**评论次数*/
@property (copy, nonatomic)NSString *comment;
/**喜欢次数*/
@property (copy, nonatomic)NSString *like;
/**查看的次数*/
@property (copy, nonatomic)NSString *view;
@end
