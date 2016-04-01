//
//  ReadCollectionFootView.m
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadCollectionFootView.h"

@implementation ReadCollectionFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.coverimgImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height - 10)];
        self.coverimgImage.image = [UIImage imageNamed:@"写作"];
        [self addSubview:self.coverimgImage];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
