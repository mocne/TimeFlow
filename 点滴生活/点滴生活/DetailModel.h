//
//  DetailModel.h
//  点滴生活
//
//  Created by qingyun on 16/2/26.
//  Copyright © 2016年 lily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DetailModel : NSObject

@property (nonatomic, strong) NSString *textStr;
@property (nonatomic, strong) NSString *locationStr;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *labelStr;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)saveDataInfoWithDict:(NSDictionary *)dict;

+ (instancetype)initWithTextStr:(NSString *)textStr LocationStr:(NSString *)locationStr ImageData:(NSData *)imageData TimeStr:(NSString *)timeStr andLabelStr:(NSString *)labelStr;

@end
