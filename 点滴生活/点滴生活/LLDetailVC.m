//
//  LLDetailVC.m
//  点滴生活
//
//  Created by qingyun on 16/2/26.
//  Copyright © 2016年 lily. All rights reserved.
//
//  展示详情
//


#import "LLDetailVC.h"
#import "LLCalendarVC.h"
#import "DetailModel.h"
#import "DBFileHandle.h"
#import "LLCommon.h"

@interface LLDetailVC ()
@property (nonatomic, strong) NSMutableDictionary *detailDic;
@property (nonatomic, strong) NSMutableArray *detailArr;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *labelLabel;
@end

@implementation LLDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BFgray.jpg"]];
    imageView.frame = CGRectMake(0, 64, kScreenW, kScreenH);
    [self.view addSubview:imageView];

    [self loadLocalDatas];
    
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)loadLocalDatas
{
    _detailArr = [NSMutableArray array];
    _detailArr = [[DBFileHandle shareHandle] selectValueAllfromdetailTable];
}
- (void)setupViews
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, kScreenW-20, 20)];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, kScreenW-20, 150)];
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(20, kScreenH-340, kScreenW-40, 250)];
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenH-80, 200, 80)];
    _labelLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-60, kScreenH-60, 60, 40)];
    
    
//    DetailModel *model = _detailArr.lastObject;
//    _model = model;
    
    _timeLabel.text = _model.timeStr;
    _timeLabel.numberOfLines = 0;
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = _model.textStr;
    _locationLabel.text = _model.locationStr;
    _locationLabel.numberOfLines = 0;
    _image.image = [UIImage imageWithData:_model.imageData];
    _labelLabel.text = _model.labelStr;

    [self.view addSubview:_timeLabel];
    [self.view addSubview:_contentLabel];
    [self.view addSubview:_image];
    [self.view addSubview:_locationLabel];
    [self.view addSubview:_labelLabel];

    
}

- (IBAction)goToCalendar:(UIBarButtonItem *)sender {
    
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //获取Main.storyboard中的第2个视图
    LLCalendarVC *vc = [mainStory instantiateViewControllerWithIdentifier:@"LLCVC"];
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
