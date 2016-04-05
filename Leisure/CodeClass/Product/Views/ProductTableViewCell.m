//
//  ProductTableViewCell.m
//  Leisure
//
//  Created by lanou on 16/4/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ProductTableViewCell.h"

@implementation ProductTableViewCell

- (void)setModel:(ProductListModel *)model {
    [self.coverimgImag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.coverimg]] placeholderImage:PLACEHOLDERIMAGE];
    self.titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    [self.buyUrlLabel setTitle:@"立即购买" forState:UIControlStateNormal];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
