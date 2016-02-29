//
//  LLCalenderCell.m
//  点滴生活
//
//  Created by qingyun on 16/2/18.
//  Copyright © 2016年 lily. All rights reserved.
//

#import "LLCalenderCell.h"

@implementation LLCalenderCell

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:18]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}
@end
