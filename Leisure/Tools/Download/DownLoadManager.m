//
//  DownLoadManager.m
//  Leisure
//
//  Created by lanou on 16/4/13.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "DownLoadManager.h"

@interface DownLoadManager ()

/** 保存下载对象 */
@property (strong, nonatomic)NSMutableDictionary *downloadDic;

@end


@implementation DownLoadManager

- (NSMutableDictionary *)downloadDic {
    if (!_downloadDic) {
        _downloadDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _downloadDic;
}
/** 单例 */
+ (instancetype)defaultManager {
    static DownLoadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownLoadManager alloc]init];
    });
    return manager;
}

/** 添加下载对象 */
- (Download *)addDownloadWithUrl:(NSString *)url {
    // 根据地址查找字典中的下载对象,如果不存在,要创建新的
    Download *download = self.downloadDic[url];
    // 如果不存在,则创建
    if (!download) {
        download = [[Download alloc]initWithUrl:url];
        [self.downloadDic setObject:download forKey:url];
    }
    return download;
}

/** 移除完成的下载对象 */
- (void)removeDownloadWithUrl:(NSString *)url {
    [self.downloadDic removeObjectForKey:url];
}

/** 获取所有的下载对象 */
- (NSArray *)findAllDownloads {
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    // 遍历字典中所有的下载对象,放到数组中
    for (NSString *url in self.downloadDic) {
        [arr addObject:self.downloadDic[url]];
    }
    // 返回数组
    return arr;
}

@end
