//
//  RadioTableViewCell.h
//  Leisure
//
//  Created by lanou on 16/4/2.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioListModel.h"


@interface RadioTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *coverimgImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *radioidLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@property (strong, nonatomic)RadioListModel *model;

- (void)setDataWithModel:(RadioListModel *)model;

@end
