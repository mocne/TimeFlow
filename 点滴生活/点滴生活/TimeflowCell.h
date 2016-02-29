//
//  TimeflowCell.h
//  点滴生活
//
//  Created by qingyun on 16/2/26.
//  Copyright © 2016年 lily. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailModel;

@interface TimeflowCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationStr;
@property (strong, nonatomic) IBOutlet UILabel *labelLabel;
//@property (nonatomic, strong) DetailModel *model;

@end
