//
//  TimeThingVC.m
//  点滴生活
//
//  Created by qingyun on 16/2/21.
//  Copyright © 2016年 lily. All rights reserved.
//

#import "TimeFlowVC.h"
#import "LLCommon.h"
#import "DBFileHandle.h"
#import "TimeflowCell.h"
#import "LLCalendarVC.h"
#import "LLDetailVC.h"
#import "DetailModel.h"

@interface TimeFlowVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *timeFlowTable;
@property (nonatomic, strong) UIImageView *myImage;
@property (nonatomic, strong) NSString *dateStr;


@end

@implementation TimeFlowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    self.timeFlowTable.delegate = self;
    self.timeFlowTable.dataSource = self;
    self.timeFlowTable.rowHeight = 150;
    _myImage = [[UIImageView alloc] init];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BGCup.jpg"]];
    self.timeFlowTable.backgroundView = bgImage;
    [self loadDataFromLocal];
    
}

//删除所有数据
- (IBAction)deleteAllDatas:(id)sender {
    [[DBFileHandle shareHandle] deleteAllData:detailTable];
    [self.timeArray removeAllObjects];
    [self.timeFlowTable reloadData];

}

//返回到日历的视图控制器
- (IBAction)goToCalendae:(UIBarButtonItem *)sender {
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //获取Main.storyboard中的第2个视图
    LLCalendarVC *vc = [mainStory instantiateViewControllerWithIdentifier:@"LLCVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 设置动画效果
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)loadDataFromLocal{
    _timeArray = [NSMutableArray array];
    _timeArray = [[DBFileHandle shareHandle] selectValueAllfromdetailTable];
    
    [_timeFlowTable reloadData];

}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.timeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"saveCell";
    
    TimeflowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TimeflowCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DetailModel *model = _timeArray[indexPath.section];
    cell.contentLabel.text = model.textStr;
    cell.locationStr.numberOfLines =0;
    cell.locationStr.text = model.locationStr;
    cell.labelLabel.text = model.labelStr;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //获取Main.storyboard中的第2个视图
    LLDetailVC *detailVC = [mainStory instantiateViewControllerWithIdentifier:@"LLDVC"];
    detailVC.model = _timeArray[indexPath.section];
    [self presentViewController:detailVC animated:YES completion:nil];
    

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    DetailModel *model = _timeArray[section];
    _dateStr =model.timeStr;
    NSArray *array = [_dateStr componentsSeparatedByString:@" "];
    NSString *str = array[0];
    return str;
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
