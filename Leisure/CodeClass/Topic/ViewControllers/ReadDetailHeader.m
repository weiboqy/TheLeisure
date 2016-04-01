//
//  ReadDetailHeader.m
//  Leisure
//
//  Created by lanou on 16/4/1.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadDetailHeader.h"

@implementation ReadDetailHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.segment = [[UISegmentedControl alloc]initWithItems:@[@"Hot", @"New"]];
        self.segment.selectedSegmentIndex = 0;
        self.segment.frame = CGRectMake(self.frame.size.width / 2 + 40, 0, 150, 30);
        [self addSubview:_segment];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
