//
//  RadioPlayTableViewCell.m
//  Leisure
//
//  Created by lanou on 16/4/6.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioPlayTableViewCell.h"

@interface RadioPlayTableViewCell()
@property (strong, nonatomic) IBOutlet UIView *typeView;



@end

@implementation RadioPlayTableViewCell

- (void)setPlayInfo:(RadioDetailListModel *)playInfo{
    self.titleLabel.text = [NSString stringWithFormat:@"%@", playInfo.title];
    self.nameLabel.text = [NSString stringWithFormat:@"%@", playInfo.playInfo.userInfo.uname];
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _typeView.hidden = !selected;
    // Configure the view for the selected state
}

@end
