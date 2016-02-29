//
//  LLCalendarVC.m
//  点滴生活
//
//  Created by qingyun on 16/2/19.
//  Copyright © 2016年 lily. All rights reserved.
//

#import "LLCalendarVC.h"
#import "LLCalenderCell.h"
#import "UIColor+ZXLazy.h"
#import "TimeFlowVC.h"
#import "LLEditorVC.h"

@interface LLCalendarVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *mothLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLaout;

@property (nonatomic, strong) NSArray *weekDayArray;

@property (nonatomic, strong) NSDate *date;

@end

NSString *const Identifier = @"cell";


@implementation LLCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController reloadInputViews];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    _date = [NSDate date];
    self.today = self.date;
    
    
    NSArray *arr = [NSArray array];
    self.weekDayArray = arr;
    self.weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];

    [self awakeFromNib];
    [self customInterface];
    [self setupMonth];
    [self addSwipe];
}
- (IBAction)push2TimeFlow:(id)sender {
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //获取Main.storyboard中的第2个视图
    TimeFlowVC *vc = [mainStory instantiateViewControllerWithIdentifier:@"TFVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // 设置动画效果
    [self presentViewController:vc animated:YES completion:nil];
    

}
- (void)awakeFromNib
{
    [self.collectionView registerClass:[LLCalenderCell class] forCellWithReuseIdentifier:Identifier];
}

//每一个日期格子的大小
- (void)customInterface
{
    CGFloat itemWidth = self.view.frame.size.width / 7;
//    CGFloat itemHeight = self.view.frame.size.height / 7;
    //74.000000,53.571429
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth , itemWidth);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionViewFlowLaout = layout;
    [self.view addSubview:self.collectionView];
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BGlightpurple.jpg"]];
    self.collectionView.backgroundView = bgImageView;
    
    [self.collectionView setCollectionViewLayout:self.collectionViewFlowLaout animated:YES];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}


- (void)setupMonth
{
    [self.mothLabel setText:[NSString stringWithFormat:@"%.2ld-%li",(long)[self month:self.date],(long)[self year:self.date]]];
    [self.collectionView reloadData];

}


#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


#pragma -mark  UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.weekDayArray.count;
    } else {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLCalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.dateLabel setText:_weekDayArray[indexPath.row]];
        [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#15cc9c"]];
    } else {
        NSInteger daysInThisMonth = [self totaldaysInMonth:self.date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            [cell.dateLabel setText:@""];            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            [cell.dateLabel setText:@""];
        }else{
            day = i - firstWeekday + 1;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#6f6f6f"]];
            
            //this month
            if ([_today isEqualToDate:self.date]) {
                if (day == [self day:self.date]) {
                    cell.dateLabel.textColor = [UIColor colorWithRed:130 green:30 blue:230];
 
                } else if (day > [self day:self.date]) {
                    cell.dateLabel.textColor = [UIColor blackColor];
                }
            } else if ([_today compare:self.date] == NSOrderedAscending) {
                cell.dateLabel.textColor = [UIColor blackColor];
            }
        }
    }
    return cell;
}


#pragma mark - UICollectionViewDelagate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSInteger daysInThisMonth = [self totaldaysInMonth:self.date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:self.date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i >= firstWeekday && i <= firstWeekday + daysInThisMonth - 1) {
            day = i - firstWeekday + 1;
            
            //this month
            if ([_today isEqualToDate:self.date]) {
                if (day <= [self day:self.date]) {
                    return YES;
                }
            } else if ([_today compare:self.date] == NSOrderedDescending) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:self.date];
    
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
    
}


- (IBAction)previous:(UIButton *)sender {
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void){
        self.date = [self lastMonth:self.date];
        [self setupMonth];
    } completion:nil];

}
- (IBAction)next:(UIButton *)sender {
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void){
        self.date = [self nextMonth:self.date];
        [self setupMonth];
    } completion:nil];

}


- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(next:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previous:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipRight];
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
