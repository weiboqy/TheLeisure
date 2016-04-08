//
//  RadioPlayInfo.h
//  Leisure
//
//  Created by lanou on 16/4/6.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadioUserInfoModel.h"
#import "RadioShareInfo.h"

@interface RadioPlayInfo : NSObject

@property (copy, nonatomic)NSString *tingid;
@property (copy, nonatomic)NSString *musicVisit;
@property (assign, nonatomic)BOOL isnew;
@property (copy, nonatomic)NSString *title;
@property (copy, nonatomic)NSString *coverimg;
@property (copy, nonatomic)NSString *sharepic;
@property (copy, nonatomic)NSString *imgUrl;
@property (copy, nonatomic)NSString *musicUrl;
@property (copy, nonatomic)NSString *shareurl;
@property (copy, nonatomic)NSString *webview_url;

/** ting_contentid */
@property (copy, nonatomic)NSString *ting_contentid;

@property (strong, nonatomic)RadioUserInfoModel *userInfo;
@property (strong, nonatomic)RadioUserInfoModel *authorinfo;
@property (strong, nonatomic)RadioShareInfo *shareinfo;



@end
