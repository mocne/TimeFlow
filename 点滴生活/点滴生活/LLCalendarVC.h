//
//  LLCalendarVC.h
//  点滴生活
//
//  Created by qingyun on 16/2/19.
//  Copyright © 2016年 lily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLCalendarVC : UIViewController
@property (nonatomic, strong) NSDate *today;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);
@end
