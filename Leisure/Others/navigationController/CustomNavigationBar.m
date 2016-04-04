//
//  CustomNavigationBar.m
//  Leisure
//
//  Created by lanou on 16/4/3.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _menuBtu = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuBtu.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        [_menuBtu setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [self addSubview:_menuBtu];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_menuBtu.frame.size.width + 5,12 , 100, self.frame.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_titleLabel];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel sizeToFit];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
