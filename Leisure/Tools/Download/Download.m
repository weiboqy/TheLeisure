 //
//  Download.m
//  Leisure
//
//  Created by lanou on 16/4/13.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "Download.h"

@interface Download ()<NSURLSessionDownloadDelegate>
@property (strong, nonatomic)NSURLSession *session;
@property (strong, nonatomic)NSURLSessionDownloadTask *downloadTask;
/** 保存断点数据 */
@property (strong, nonatomic)NSData *reData;
/** 保存下载地址 */
@property (copy, nonatomic)NSString *url;

@end

@implementation Download


- (instancetype)initWithUrl:(NSString *)urlPath {
    self = [super init];
    if (self) {
        // defaultSessionConfiguration默认配置,系统具有自动缓存功能
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self.url = urlPath;
        // 当使用断点下载时 不需要这个
        //        self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:urlPath]];
        
    }
    return self;
}

/** 开始下载 */
- (void)start {
    // 断点
    if (!self.downloadTask) {
        // 从文件中读取断点数据 赋值给self.reData
        self.reData = [NSData dataWithContentsOfFile:[self createFilePath]];
        QYLog(@"%@", [self createFilePath]);
        if (!self.reData) {
            QYLog(@"start");
            self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:self.url]];
        }else {
            self.downloadTask = [self.session downloadTaskWithResumeData:self.reData];
        }
    }
    [self.downloadTask resume];
}

/** 暂停方法 */
- (void)pause {
    // 如果暂停的话,不能调用cancel,cancel是取消的任务
    //    [self.downloadTask suspend];
    
    // 断点下载
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        // 获取新的断点数据
        self.reData = resumeData;
        // 将task置空,因为再次开始时,需要用新的断点数据来创建task
        self.downloadTask = nil;
        
        //将data保存到本地, 防止用户退出应用内存数据被回收了
        [self.reData writeToFile:[self createFilePath] atomically:YES];
    }];
}


// 创建文件路径, 第一个作用用来保存断点数据,第二个作用是用来保存最后下载完成的文件(下载完成后,会讲保存的断点数据进行覆盖)
- (NSString *)createFilePath {
    // 获取caches文件夹
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // 创建缓存数据文件夹
    NSString *downLoadPath = [caches stringByAppendingPathComponent:@"filePath"];
    // 创建文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    // 判断文件路径是否存在,不存在就创建
    if (![manager fileExistsAtPath:downLoadPath]) {
        [manager createDirectoryAtPath:downLoadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 在缓存数据文件夹中创建文件路径
    //    NSString *filePath = [downLoadPath stringByAppendingPathComponent:self.downloadTask.response.suggestedFilename];
    // 在创建task时,因为task还为空,找不到建议的文件名
    NSArray *arr = [self.url componentsSeparatedByString:@"/"]; //以/隔开
    NSString *filePath = [downLoadPath stringByAppendingPathComponent:[arr lastObject]];
    
    return filePath;
}


#pragma mark ----协议方法
// 当下载完成时 调用, 将缓存数据保存在caches文件夹
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    // 创建文件路径
    NSString *filePath = [self createFilePath];
    
    
    // 先删除缓存的数据,再将下载的内容移动到文件路径下
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    // 将数据移到文件路径下
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
    
    // 打印文件路径
    QYLog(@"filePath = %@", filePath);
    
    // 下载完成后,通过block将文件的网络路径和本地路径传到外面
    self.downloadFinish(self.url, filePath);
}

// didWriteData 本次写入的字节数
// totalBytesWritten 总共写入的字节数
// totalBytesExpectedToWrite 下载的文件的字节数
// 下载中调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    // 获取下载进度
    float progress =  totalBytesWritten * 1.0/ totalBytesExpectedToWrite;
    // 将进度值传出去
    self.downLoading(progress);
    QYLog(@"进度:%.2f%%", progress);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

// 请求完成时调用, 如果有错误,error给出错误信息,如果没有错误,error = null
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    QYLog(@"error = %@", error);
}

@end
