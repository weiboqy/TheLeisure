//
//  RadioCover.h
//  Leisure
//
//  Created by lanou on 16/4/7.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioDetailListModel.h"

@interface RadioCover : UIView

@property (strong, nonatomic) IBOutlet UIImageView *picImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UISlider *sliderView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;


@property (strong, nonatomic)RadioDetailListModel *listModel;






///**图片*/
//@property (strong, nonatomic)UIImageView *picImageView;
///**名称*/
//@property (strong, nonatomic)UILabel *nameLabel;
///**进度条*/
//@property (strong, nonatomic)UISlider *sliderView;
///**剩余时间*/
//@property (strong ,nonatomic)UILabel *timeLabel;
//
///**下载*/
//@property (strong, nonatomic)UIButton *downButton;
///**喜欢*/
//@property (strong, nonatomic)UIButton *likeButton;
///**评论*/
//@property (strong, nonatomic)UIButton *comment;
///**分享*/
//@property (strong, nonatomic)UIButton *shareButton;



@end
