//
//  MenuHeaderView.m
//  Leisure
//
//  Created by lanou on 16/4/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "MenuHeaderView.h"


@implementation MenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconImage.image = [UIImage imageNamed:@"yejing"];
        _iconImage.layer.cornerRadius = 40;
        _iconImage.layer.masksToBounds = YES;
        [self addSubview:_iconImage];
        
        _name = [UIButton buttonWithType:UIButtonTypeCustom];
        _name.frame = CGRectZero;

        [_name setTitle:@"登陆/注册" forState:UIControlStateNormal];
        [_name setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self addSubview:_name];
        
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downButton.frame = CGRectZero;
        [_downButton setBackgroundImage:[UIImage imageNamed:@"下载123"] forState:UIControlStateNormal];
        [self addSubview:_downButton];
        
        _loveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loveButton.frame = CGRectZero;
        [_loveButton setBackgroundImage:[UIImage imageNamed:@"喜欢123"] forState:UIControlStateNormal];
        [self addSubview:_loveButton];
    }
    return self;
}
- (void)loginClick {
//    LoginViewController *loginVC = [[LoginViewController alloc]init];
//    [self.navigationController pushViewController:loginVC animated:YES];
    QYLog(@"----是不是啥");
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    CGFloat downW = self.frame.size.width / 4;
    _iconImage.frame = CGRectMake(15, 20, 80, 80);
    _name.frame = CGRectMake(90, 45, 100, 30);
    _downButton.frame = CGRectMake(55, 120, 20, 20);
    _loveButton.frame = CGRectMake(130, 120, 20, 20);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
