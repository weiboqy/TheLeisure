//
//  MenuFootView.m
//  Leisure
//
//  Created by lanou on 16/4/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "MenuFootView.h"

@implementation MenuFootView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        _songTotal = [UIButton buttonWithType:UIButtonTypeCustom];
        _songTotal.frame = CGRectZero;
        [_songTotal setBackgroundImage:[UIImage imageNamed:@"圆盘"] forState:UIControlStateNormal];
        _songTotal.layer.cornerRadius = 20;
        _songTotal.layer.masksToBounds = YES;
        [self addSubview:_songTotal];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectZero;
        [_playButton setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        _playButton.layer.cornerRadius = 20;
        _playButton.layer.masksToBounds = YES;
        _playButton.backgroundColor = [UIColor clearColor];
        [self addSubview:_playButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _songTotal.frame = CGRectMake(10, 10, 40, 40);
    _playButton.frame = CGRectMake(self.frame.size.width - 150, 10, 40, 40);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
