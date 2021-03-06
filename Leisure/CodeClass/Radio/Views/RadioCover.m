//
//  RadioCover.m
//  Leisure
//
//  Created by lanou on 16/4/7.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioCover.h"
#import "Download.h"
#import "DownLoadManager.h"
#import "RadioDetailListDB.h"

@implementation RadioCover

- (void)setListModel:(RadioDetailListModel *)listModel {
    _listModel = listModel;
   [_picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _listModel.coverimg]] placeholderImage:PLACEHOLDERIMAGE];
    _nameLabel.text = [NSString stringWithFormat:@"%@", _listModel.title];
}


- (IBAction)downloadClick:(id)sender {
    // 创建一个下载对象,并且用下载管理器进行管理
    Download *download = [[DownLoadManager defaultManager] addDownloadWithUrl:_listModel.musicUrl];
    
    // 让下载对象开始工作
    [download start];
    
    // 监控进度
    download.downLoading = ^(float progress) {
        UIButton *button = (UIButton *)sender;
        [button setTitle:[NSString stringWithFormat:@"%.2f%%", progress] forState:UIControlStateNormal];
    };
    download.downloadFinish = ^(NSString *url, NSString *savePath) {
        // 1.UI变化
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        // 2.数据变化(数据模型、本地音频路径)
        //2.1 存电台详情列表的数据
        RadioDetailListDB *radioDetailDB = [[RadioDetailListDB alloc]init];
        [radioDetailDB createDataTable];
        [radioDetailDB saveDataWithModel:_listModel andPath:savePath];
        //2.2 存playInfo
        
        
        // 3.移除下载对象
        [[DownLoadManager defaultManager] removeDownloadWithUrl:_listModel.musicUrl];
    };
}

- (IBAction)likeClick:(id)sender {
    QYLogFunc;
}

- (IBAction)commentClick:(id)sender {
    QYLogFunc;
}

- (IBAction)shareClick:(id)sender {
    QYLogFunc;
}


//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//       
//        //封面图片
//        _picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + 45, 60, 290, 250)];
//        _picImageView.backgroundColor = [UIColor cyanColor];
//        
//        [self addSubview:_picImageView];
//        
//        //名称
//        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 +50, CGRectGetMaxY(_picImageView.frame) + 62, 275, 30)];
//        
//        _nameLabel.textAlignment = NSTextAlignmentCenter;
//        _nameLabel.font = [UIFont systemFontOfSize:18];
//        [self addSubview:_nameLabel];
//        
//        //进度条
//        _sliderView = [[UISlider alloc]initWithFrame:CGRectMake(0 +50, CGRectGetMaxY(_nameLabel.frame) + 30, 200, 30)];
//        [self addSubview:_sliderView];
//        
//        //剩余时间
//        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_sliderView.frame) + 20, CGRectGetMaxY(_nameLabel.frame) + 30, 100, 30)];
//        //默认时间为00:00
//        _timeLabel.text = @"00:00";
//        _timeLabel.font = [UIFont systemFontOfSize:15];
//        [self addSubview:_timeLabel];
//        
//        //下载按钮
//        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _downButton.frame = CGRectMake(0 +50, CGRectGetMaxY(_sliderView.frame) + 30, 30, 30);
//        [_downButton setBackgroundImage:[UIImage imageNamed:@"下载12"] forState:UIControlStateNormal];
//        [self addSubview:_downButton];
//        
//        //喜欢按钮
//        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom ];
//        _likeButton.frame = CGRectMake(CGRectGetMaxX(_downButton.frame) + 50, CGRectGetMaxY(_sliderView.frame) + 30, 30, 30);
//        [_likeButton setBackgroundImage:[UIImage imageNamed:@"喜欢12"] forState:UIControlStateNormal];
//        [self addSubview:_likeButton];
//        
//        //评论按钮
//        _comment = [UIButton buttonWithType:UIButtonTypeCustom];
//        _comment.frame = CGRectMake(CGRectGetMaxX(_likeButton.frame) + 50, CGRectGetMaxY(_sliderView.frame) + 30, 30, 30);
//        [_comment setBackgroundImage:[UIImage imageNamed:@"评论12"] forState:UIControlStateNormal];
//        [self addSubview:_comment];
//        
//        //分享按钮
//        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _shareButton.frame = CGRectMake(CGRectGetMaxX(_comment.frame) + 50, CGRectGetMaxY(_sliderView.frame) + 30, 30, 30);
//        [_shareButton setBackgroundImage:[UIImage imageNamed:@"分享12"] forState:UIControlStateNormal];
//        [self addSubview:_shareButton];
//        
//       
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
