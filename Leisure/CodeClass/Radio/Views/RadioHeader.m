//
//  RadioHeader.m
//  Leisure
//
//  Created by lanou on 16/4/2.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioHeader.h"

@implementation RadioHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        [self addSubview:_scrollView];
        
        // 初始化3个按钮
        CGFloat buttonX = 5;
        CGFloat buttonY = CGRectGetMaxY(_scrollView.frame) + 5;
        CGFloat buttonW = (ScreenWidth - 8 * 2 - 10) / 3;
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(5, buttonY, buttonW, buttonW);
        [self addSubview:_leftBtn];
        
        buttonX += buttonW + 8;
        _midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _midBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonW);
        [self addSubview:_midBtn];
        
        buttonX += buttonW + 8;
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonW);
        [self addSubview:_rightBtn];
        
        // 全部电台的label
        CGFloat labelY = CGRectGetMaxY(_leftBtn.frame) + 5;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, labelY, 120, 20)];
        label.text = @"全部电台·All stations";
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        
        // 分割线
        CGFloat viewY = CGRectGetMaxY(label.frame) - 10;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(122, viewY, ScreenWidth - 124, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
