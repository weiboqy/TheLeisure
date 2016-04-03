//
//  RadioDetailHeader.m
//  Leisure
//
//  Created by lanou on 16/4/3.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioDetailHeader.h"
#import "UIImageView+WebCache.h"

@interface RadioDetailHeader()

@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UIImageView *iconImage;
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *descLabel;
@property (strong, nonatomic)UILabel *count;
@property (strong, nonatomic)UIImageView *imageViewVV;




@end

@implementation RadioDetailHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        [self addSubview:_imageView];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 170, 30, 30)];
        _iconImage.layer.cornerRadius = 15;
        _iconImage.layer.masksToBounds = YES;
        [self addSubview:_iconImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 180, 100, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor blueColor];
        [self addSubview:_nameLabel];
        
        _descLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 200, 20)];
        _descLabel.text = [NSString stringWithFormat:@"%@", self.model.desc];
        [self addSubview:_descLabel];
        
        _imageViewVV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 120, 175, 10, 10)];
        _imageViewVV.image = [UIImage imageNamed:@"u58.png"];
        [self addSubview:_imageViewVV];
        
        _count = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 170, 100, 20)];
        _count.font = [UIFont systemFontOfSize:12];
        [self addSubview:_count];
        }
    return self;
}

- (void)setModel:(RadioInfoModel *)model {
    _model = model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.coverimg]] placeholderImage:PLACEHOLDERIMAGE];
    _descLabel.text = [NSString stringWithFormat:@"%@", model.desc];
    _count.text = [NSString stringWithFormat:@"%@", model.musicvisitnum];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.userInfoModel.icon]] placeholderImage:PLACEHOLDERIMAGE];
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.userInfoModel.uname];
    
}
- (void)setUserModel:(RadioUserInfoModel *)userModel {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
