//
//  RadioPlayUserView.m
//  Leisure
//
//  Created by lanou on 16/4/7.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioPlayControlView.h"

@implementation RadioPlayControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 55, ScreenWidth, 2)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
        
        //上一首
        _aboveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _aboveButton.frame = CGRectZero;
        [_aboveButton setBackgroundImage:[UIImage imageNamed:@"上一首"] forState:UIControlStateNormal];
        _aboveButton.backgroundColor = [UIColor redColor];
        _aboveButton.layer.cornerRadius = 15;
        _aboveButton.layer.masksToBounds = YES;
        [_aboveButton addTarget:self action:@selector(aboveClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_aboveButton];
        
        //播放/暂停
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
       _playButton.frame = CGRectZero;
        _playButton.backgroundColor = [UIColor redColor];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        _playButton.tag = 3001;
        _playButton.layer.cornerRadius = 20;
        _playButton.layer.masksToBounds = YES;
        [_playButton addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playButton];
        
        //下一首
        _belowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _belowButton.frame = CGRectZero;
        [_belowButton setBackgroundImage:[UIImage imageNamed:@"下一首"] forState:UIControlStateNormal];
         _belowButton.backgroundColor = [UIColor redColor];
        _belowButton.layer.cornerRadius = 15;
        _belowButton.layer.masksToBounds = YES;
        [_belowButton addTarget:self action:@selector(belowClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_belowButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _aboveButton.frame = CGRectMake(60, ScreenHeight - 45, 30, 30);
    
   _playButton.frame = CGRectMake(CGRectGetMaxX(_aboveButton.frame) + 77, CGRectGetMaxY(_aboveButton.frame) - 30 - 5, 40, 40);
   _belowButton.frame = CGRectMake(CGRectGetMaxX(_playButton.frame) + 77, CGRectGetMaxY(_playButton.frame) - 40 + 5, 30, 30); 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
