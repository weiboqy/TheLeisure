//
//  ReadInfoModel.h
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadShareInfo.h"
#import "ReadInfoCounter.h"

@interface ReadInfoModel : NSObject

/** 文件id */
@property (copy, nonatomic)NSString *contentid;
/** html */
@property (copy, nonatomic)NSString *html;

@property (strong, nonatomic)ReadShareInfo *shareInfo;
@property (strong, nonatomic)ReadInfoCounter *counter;

@end
