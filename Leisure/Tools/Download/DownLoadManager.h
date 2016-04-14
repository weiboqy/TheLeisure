//
//  DownLoadManager.h
//  Leisure
//
//  Created by lanou on 16/4/13.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Download.h"

@interface DownLoadManager : NSObject

/** 单例 */
+ (instancetype)defaultManager;

/** 添加下载对象 */
- (Download *)addDownloadWithUrl:(NSString *)url;

/** 移除完成的下载对象 */
- (void)removeDownloadWithUrl:(NSString *)url;

/** 获取所有的下载对象 */
- (NSArray *)findAllDownloads;

@end
