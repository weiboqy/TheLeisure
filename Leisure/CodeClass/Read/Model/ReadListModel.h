//
//  ReadModel.h
//  Leisure
//
//  Created by lanou on 16/3/29.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"

@interface ReadListModel : BaseModel

/**图片*/
@property (copy, nonatomic)NSString *coverimg;
/**标题*/
@property (copy, nonatomic)NSString *name;
/**副标题*/
@property (copy, nonatomic)NSString *enname;
/**主题*/
@property (copy, nonatomic)NSString *type;

@end
