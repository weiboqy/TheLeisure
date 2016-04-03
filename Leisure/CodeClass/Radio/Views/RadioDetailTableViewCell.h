//
//  RadioDetailTableViewCell.h
//  Leisure
//
//  Created by lanou on 16/4/3.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioDetailListModel.h"
#import "UIImageView+WebCache.h"

@interface RadioDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coverimgImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *musicVisitLabel;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic)RadioDetailListModel *model;

- (void)setDataWithModel:(RadioDetailListModel *)model ;

@end
