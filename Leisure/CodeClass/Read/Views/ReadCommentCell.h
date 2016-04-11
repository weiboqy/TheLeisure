//
//  ReadCommentCell.h
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadCommentModel.h"

@interface ReadCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImagView;
@property (strong, nonatomic) IBOutlet UILabel *unameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addtime_fLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic)ReadCommentModel *model;




@end
