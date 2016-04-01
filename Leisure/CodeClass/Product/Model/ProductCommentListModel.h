//
//  ProductCommentListModel.h
//  Leisure
//
//  Created by lanou on 16/3/30.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"
#import "ProductUserInfoModel.h"

@interface ProductCommentListModel : BaseModel


/**评论的时间*/
@property (copy, nonatomic)NSString *addtime_f;
/**评论内容*/
@property (copy, nonatomic)NSString *content;
/**评论的ID*/
@property (copy, nonatomic)NSString *contentid;

/**用户信息*/
@property (strong, nonatomic)ProductUserInfoModel *userinfo;


@end
