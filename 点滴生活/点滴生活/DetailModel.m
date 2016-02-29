//
//  DetailModel.m
//  点滴生活
//
//  Created by qingyun on 16/2/26.
//  Copyright © 2016年 lily. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _textStr = dict[@"textStr"];
        _locationStr = dict[@"locationStr"];
        _imageData = dict[@"imageData"];
        _timeStr = dict[@"timeStr"];
        _labelStr = dict[@"labelStr"];
    }
    return self;
}
+ (instancetype)initWithTextStr:(NSString *)textStr LocationStr:(NSString *)locationStr ImageData:(NSData *)imageData TimeStr:(NSString *)timeStr andLabelStr:(NSString *)labelStr
{
    DetailModel *model = [[DetailModel alloc] init];
    model.textStr = textStr;
    model.locationStr = locationStr;
    model.imageData = imageData;
    model.timeStr = timeStr;
    model.labelStr = labelStr;
    return model;
}

+ (instancetype)saveDataInfoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
