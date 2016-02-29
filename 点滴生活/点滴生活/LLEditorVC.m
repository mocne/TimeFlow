//
//  LLEditorVC.m
//  点滴生活
//
//  Created by qingyun on 16/2/20.
//  Copyright © 2016年 lily. All rights reserved.
//
//  编辑页面
//

#import "LLEditorVC.h"
#import "LLCalendarVC.h"
#import "UITextView+Placeholder.h"
#import "TimeFlowVC.h"
#import <CoreLocation/CoreLocation.h>
#import "LLCommon.h"
#import "DBFileHandle.h"
#import "DetailModel.h"
#import "LLDetailVC.h"

@interface LLEditorVC ()<UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *editTableView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIPickerView *pikerView;

@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableDictionary *thingDictionary;
@property (nonatomic, strong) NSArray *pikerArr;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *addImage;
@property (nonatomic, strong) UILabel *pikerLabel;
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) UIGestureRecognizer *tap;
@property (nonatomic, strong) NSString *textStr;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnItem;

@property (nonatomic, strong) NSString *str;

@end

@implementation LLEditorVC

#define X   kScreenW/3
#define Y   kScreenH/2.5
#define W   kScreenW/2
#define H   kScreenH/3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = YES;
    
    _editTableView.rowHeight = 44.0f;
    _editTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    _textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.text = [NSString stringWithFormat:@"添加地址🏠"];
    
    _addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insert_image1.png"]];
    
    _pikerLabel = [[UILabel alloc] init];
    _pikerLabel.text = [NSString stringWithFormat:@"生活"];
    
    self.timeArray = [NSMutableArray array];
    _thingDictionary = [NSMutableDictionary new];
    
    self.pikerArr = [NSArray array];
    self.pikerArr = @[@"生活",@"工作",@"生日🎂",@"聚会",@"学习",@"旅游"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setLocale:[NSLocale currentLocale]];
    [fomatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    self.dateStr = [fomatter stringFromDate:date];
}


- (IBAction)returnToCalendar:(UIBarButtonItem *)sender {
    
    if (self.textView.text ==nil) {
        _textView.text = @"我的记录";
    }
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //获取Main.storyboard中的第2个视图
    LLCalendarVC *vc = [mainStory instantiateViewControllerWithIdentifier:@"LLCVC"];

    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{

    [_barBtnItem setTitle:@"完成"];
    
}
- (IBAction)rbtnClick:(UIBarButtonItem *)sender {

    if ([sender.title isEqualToString:@"完成"]) {
        //取消textView的第一响应
        [_textView resignFirstResponder];
        _textStr = _textView.text;
        self.barBtnItem.title = @"保存";
    }else if ([sender.title isEqualToString:@"保存"]){
        
        [self insertValues];
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //获取Main.storyboard中的第2个视图
        LLDetailVC *vc = [mainStory instantiateViewControllerWithIdentifier:@"LLDVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 设置动画效果
   
        _timeArray = [[DBFileHandle shareHandle] selectValueAllfromdetailTable];
        vc.model = _timeArray.lastObject;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    _textStr = textView.text;
}

- (void)initLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    //向用户申请授权，如果授权是没有决定的
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLHeadingFilterNone;
    
}
//定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //此处locations存储了持续更新的位置坐标值，去最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *arrary, NSError *error) {
        if (arrary.count > 0) {
            CLPlacemark *placemark = [arrary objectAtIndex:0];
            
            //将获得的所有信息显示到label上
            NSLog(@"location：%@",placemark.name);
            NSString *str = [NSString stringWithFormat:@"当前位置:"];
            NSString *str2 = [str stringByAppendingString:placemark.name];
            self.locationLabel.text = str2;
            [_editTableView reloadData];

            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方式来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
                self.locationLabel.text = city;
            }
        }else if(error == nil && [arrary count] ==  0){
            NSLog(@"No results were returned.");
        }else if (error != nil){
            NSLog(@"An error occurred = %@",error);
        }
    }];
    [manager stopUpdatingLocation];
    [_editTableView reloadData];
}

//选取图片
- (void)pickImage
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //从相册选取
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    //从相机选取
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机拍摄" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.allowsEditing=YES;
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    //取消选择
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alter addAction:cancel];
    [alter addAction:album];
    [alter addAction:camera];
    [self presentViewController:alter animated:YES completion:nil];
}
#pragma mark - imagePickerView delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    self.addImage = [[UIImageView alloc] initWithImage:image];
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.editTableView reloadData];
}

#pragma mark - setup PickerView
- (void)setupCategoryandLabel{
    
    UIPickerView *pikerView = [[UIPickerView alloc] initWithFrame:CGRectMake(X + 40, Y+100, W-40, H-50)];
    [self.view addSubview:pikerView];
    self.pikerView = pikerView;
    self.pikerView.delegate = self;
    self.pikerView.dataSource = self;
    self.pikerView.backgroundColor = [UIColor colorWithRed:0.4745 green:0.9451 blue:0.5137 alpha:0.8];
}

#pragma mark - pikerViewDelegate
//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//每行列数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pikerArr.count;
}

#pragma mark -UIPickerViewDelegate
//设置文本
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pikerArr[row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_pikerArr[row] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        
        return attributedString;
    }
    return nil;
}

//设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}
//选中Row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_pikerArr[row] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    _pikerLabel.attributedText = attributedString;
    [self.pikerView removeFromSuperview];
    [self.editTableView reloadData];
}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger cellCount = 0;
    switch (section) {
        case 0:
            cellCount = 1;
            break;
        case 1:
            cellCount = 3;
            break;
        case 2:
            cellCount = 1;
            break;
        default:
            break;
    }
    return cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowheight =44;
    switch (indexPath.section) {
        case 0:
            return rowheight =150.f;
            break;
        case 1:
            if (indexPath.row == 1) {
                return rowheight =100.f;
            }else{
            return rowheight = 60.f;
            }
            break;
        case 2:
            return rowheight = 60.f;
            break;
        default:
            break;
    }
    return rowheight;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    UITableViewCell *cell0 = [[UITableViewCell alloc]init];
    switch (indexPath.section) {
        case 0:
        {
            self.textView.placeholder = @"记录一下此刻发生的事儿吧ʕ•ᴥ•ʔ";
            self.textView.backgroundColor = [UIColor colorWithRed:0.7882 green:0.9843 blue:0.5529 alpha:0.5];
            [cell0 addSubview:self.textView];
            cell0.tag = 9;
        }
            break;
        case 1:
        {
            //定位
            cell0.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9451 blue:0.5333 alpha:0.5];

            if (indexPath.row ==0) {
                [cell0.textLabel setNumberOfLines:0];
                cell0.textLabel.text= _locationLabel.text;
                cell0.tag = 10;
                [cell0 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            //➕图片
            if (indexPath.row == 1) {
                self.addImage.frame = CGRectMake(10, 0, 100, 100);
                [cell0 addSubview:_addImage];
                cell0.tag = 11;
            }
            if (indexPath.row == 2) {
                cell0.textLabel.text = _dateStr;
                cell0.tag = 12;
            }
        }
            break;
        case 2:
        {
            UITableViewCell *cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell0 = cell2;
            
            cell0.backgroundColor = [UIColor colorWithRed:0.9725 green:0.7373 blue:0.5961 alpha:0.5];
            cell0.textLabel.text = @"分类标签🏷️";
            cell0.detailTextLabel.attributedText = self.pikerLabel.attributedText;
            cell0.tag = 13;
        }
            break;
        case 3:
        {
            cell0.backgroundColor = [UIColor colorWithRed:0.9373 green:0.6431 blue:0.8039 alpha:0.5];
            cell0.tag = 14;
        }
            break;
        default:
            break;
    }
    
    cell = cell0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
        if (cell.tag ==9) {
            _textView.text = _textStr;
        }
        if (cell.tag ==10) {
            [self initLocation];
            [self.locationManager startUpdatingLocation];
            cell.textLabel.text = self.locationLabel.text;
            cell.backgroundColor= [UIColor clearColor];
            }
        if (cell.tag == 11) {
            [self pickImage];
            cell.userInteractionEnabled = NO;
           }
        if (cell.tag == 12) {
           NSDate *date = [NSDate date];
           NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
           [fomatter setLocale:[NSLocale currentLocale]];
           [fomatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
           self.dateStr = [fomatter stringFromDate:date];
           cell.textLabel.text = self.dateStr;
            cell.userInteractionEnabled = NO;
          }
        if (cell.tag == 13) {
        [self setupCategoryandLabel];
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 0.9;
            cell.detailTextLabel.attributedText = self.pikerLabel.attributedText;
            cell.userInteractionEnabled = NO;
            }];
     }
}

/**
 *数据持久化获取单例对象
 */
- (void)insertValues
{
    NSData *data;
    if (UIImagePNGRepresentation(_addImage.image) == nil) {
        data = UIImageJPEGRepresentation(_addImage.image, 1);
    }else{
        data = UIImagePNGRepresentation(_addImage.image);
    }
    if ([self.textView.text isEqualToString:@""]) {
        self.textView.text = @"未填写";
    }
    if ([self.locationLabel.text isEqualToString:@"添加地址🏠"]) {
        self.locationLabel.text = @"地址未知";
    }
    
    DetailModel *detailData = [DetailModel initWithTextStr:_textView.text LocationStr:_locationLabel.text ImageData:data TimeStr:_dateStr andLabelStr:_pikerLabel.text];
    
    DBFileHandle *handle = [DBFileHandle shareHandle];
    if ([handle insertData2detailTable:detailData]) {
        NSLog(@"====插入成功");
    }else{
        NSLog(@"anything is wrong");
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@">>>%@",error);
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
