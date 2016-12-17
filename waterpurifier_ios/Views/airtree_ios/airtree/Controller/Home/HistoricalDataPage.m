//
//  HistoricalDataPage.m
//  airtree
//
//  Created by if on 2016/11/18.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "HistoricalDataPage.h"
#import "DeviceHistoryInfo.h"
#import "DateTimePicker.h"

@interface HistoricalDataPage ()
{
    UITableView *tableView;
    DeviceHistoryInfo *currentDeviceInfo;
    
    UIButton *dateSelectBtn;
    UILabel *allNumbersLabel;//Main Value
    UILabel *PM25Label;//Pm25 Value
    UILabel *temperatureLabel;//Temperature Value
    UILabel *humidityLabel;//Humidity Value
    UILabel *formaldehydeLabel;//Formaldehyde Value
    
    
    DateTimePicker *pickerView;
    NSDate *selectedDate;
    
    
}

@end

@implementation HistoricalDataPage
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.deviceName;
    [self setNavigationLeft:@"返回" sel:@selector(backAction)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40) style:UITableViewStyleGrouped];
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    [self.view addSubview:tableView];
    
    dateSelectBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 30, 120, 30)];
    dateSelectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    //dateSelectBtn.tintColor = [UIColor redColor];
    [dateSelectBtn setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
    //timeLabel.text = self.title;
    dateSelectBtn.backgroundColor = [UIColor clearColor];
    [dateSelectBtn addTarget:self action:@selector(clickDateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dateSelectBtn];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [dateSelectBtn setTitle:dateString forState:UIControlStateNormal];
    
    
    
    allNumbersLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 80)];
    allNumbersLabel.font = [UIFont boldSystemFontOfSize:80.0f];
    allNumbersLabel.textColor = RgbColor(38, 104, 168);
    allNumbersLabel.backgroundColor = [UIColor clearColor];
    allNumbersLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:allNumbersLabel];
    
    UILabel *allNumbersLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-70, 230, 140, 40)];
    allNumbersLabel2.font = [UIFont boldSystemFontOfSize:20.0f];
    allNumbersLabel2.textColor = BLACKTEXTCOLOR_TITLE;
    allNumbersLabel2.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:241/255.0 alpha:0.3];//色值和透明度自己调
    allNumbersLabel2.text = @"净化空气总量";
    [allNumbersLabel2.layer setMasksToBounds:YES];
    [allNumbersLabel2.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
    allNumbersLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:allNumbersLabel2];

    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 320, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:241/255.0 alpha:0.3];//色值和透明度自己调
    [self.view addSubview:line];
    
    PM25Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 350, SCREEN_WIDTH/4, 30)];
    PM25Label.font = [UIFont boldSystemFontOfSize:18.0f];
    PM25Label.textColor = BLACKTEXTCOLOR_TITLE;
    PM25Label.backgroundColor = [UIColor clearColor];
    PM25Label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:PM25Label];
    
    temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 350, SCREEN_WIDTH/4, 30)];
    temperatureLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    temperatureLabel.textColor = BLACKTEXTCOLOR_TITLE;
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:temperatureLabel];
    
    humidityLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 350, SCREEN_WIDTH/4, 30)];
    humidityLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    humidityLabel.textColor = BLACKTEXTCOLOR_TITLE;
    humidityLabel.backgroundColor = [UIColor clearColor];
    humidityLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:humidityLabel];
    
    formaldehydeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 350, SCREEN_WIDTH/4, 30)];
    formaldehydeLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    formaldehydeLabel.textColor = BLACKTEXTCOLOR_TITLE;
    formaldehydeLabel.backgroundColor = [UIColor clearColor];
    formaldehydeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:formaldehydeLabel];
    
    UILabel *PM25Label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 400, SCREEN_WIDTH/4, 30)];
    PM25Label2.font = [UIFont boldSystemFontOfSize:18.0f];
    PM25Label2.text = @"PM2.5";
    PM25Label2.textColor = BLACKTEXTCOLOR_TITLE;
    PM25Label2.backgroundColor = [UIColor clearColor];
    PM25Label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:PM25Label2];
    
    UILabel *temperatureLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 400, SCREEN_WIDTH/4, 30)];
    temperatureLabel2.font = [UIFont boldSystemFontOfSize:18.0f];
    temperatureLabel2.text = @"温度";
    temperatureLabel2.textColor = BLACKTEXTCOLOR_TITLE;
    temperatureLabel2.backgroundColor = [UIColor clearColor];
    temperatureLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:temperatureLabel2];
    
    UILabel *humidityLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 400, SCREEN_WIDTH/4, 30)];
    humidityLabel2.font = [UIFont boldSystemFontOfSize:18.0f];
    humidityLabel2.text = @"湿度";
    humidityLabel2.textColor = BLACKTEXTCOLOR_TITLE;
    humidityLabel2.backgroundColor = [UIColor clearColor];
    humidityLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:humidityLabel2];
    
    UILabel *formaldehydeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 400, SCREEN_WIDTH/4, 30)];
    formaldehydeLabel2.font = [UIFont boldSystemFontOfSize:18.0f];
    formaldehydeLabel2.text = @"甲醛";
    formaldehydeLabel2.textColor = BLACKTEXTCOLOR_TITLE;
    formaldehydeLabel2.backgroundColor = [UIColor clearColor];
    formaldehydeLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:formaldehydeLabel2];

    [self initView:[NSDate date]];
    //此处调用加载数据的接口
    //[self loadDeviceInfoList];
    
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pickerChanged:(id)sender
{
    selectedDate = pickerView.picker.date;
}

-(void)donePressed
{
    pickerView.hidden = YES;
    [pickerView removeFromSuperview];
    
    [self initView:pickerView.picker.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:pickerView.picker.date];
    [dateSelectBtn setTitle:dateString forState:UIControlStateNormal];
}

-(void)cancelPressed
{
    pickerView.hidden = YES;
    [pickerView removeFromSuperview];
}

-(void)clickDateButton:(id)sender {
    [pickerView removeFromSuperview];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if(IsiPhone4 || IsiPhone5)
    {
        pickerView = [[DateTimePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 250, screenWidth, screenHeight/2)];
    }
    else
    {
        pickerView = [[DateTimePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 300, screenWidth, screenHeight/2)];
    }
    
    [pickerView addTargetForDoneButton:self action:@selector(donePressed)];
    [pickerView addTargetForCancelButton:self action:@selector(cancelPressed)];
    
    [pickerView setHidden:NO];
    [pickerView setMode:UIDatePickerModeDate];
    
    [self.view addSubview:pickerView];
    
    //[self.pickerView.picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void) initView: (NSDate *) date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *day = [dateFormat stringFromDate:date];
    
    self.navigationItem.title = _selectedDevice[@"name"] == nil ? _selectedDevice[@"mac"] : _selectedDevice[@"name"];
    NSString *path = [NSString stringWithFormat:@"/device/mac/%@/get_history?day=%@", _selectedDevice[@"mac"], day];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPGET];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
    {
        NSString *response = [completedRequest responseAsString];
        NSLog(@"History - day: %@ - mac: %@ - data: %@", day, _selectedDevice[@"mac"], response);
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        if(data == nil)
        {
            [allNumbersLabel setText:@"0"];
            [PM25Label setText:@"0ug/m³"];
            [temperatureLabel setText:@"0℃"];
            [humidityLabel setText:@"0%"];
            [formaldehydeLabel setText:@"0mg/m³"];
        }
        else
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if([json count] < 1)
            {
                [allNumbersLabel setText:@"0"];
                [PM25Label setText:@"0ug/m³"];
                [temperatureLabel setText:@"0℃"];
                [humidityLabel setText:@"0%"];
                [formaldehydeLabel setText:@"0mg/m³"];
            }
            else
            {
                [allNumbersLabel setText:json[@"x3"] == nil || (NSNull *)json[@"x3"] == [NSNull null] ? @"0" : [NSString stringWithFormat:@"%.f", round([json[@"x3"] floatValue])]];
                [PM25Label setText:json[@"x1"] == nil || (NSNull *)json[@"x1"] == [NSNull null] ? @"0ug/m³" : [NSString stringWithFormat:@"%.fug/m³", round([json[@"x1"] floatValue])]];
                [temperatureLabel setText:json[@"x11"] == nil || (NSNull *)json[@"x11"] == [NSNull null] ? @"0℃" : [NSString stringWithFormat:@"%.f℃", round([json[@"x11"] floatValue])]];
                [humidityLabel setText:json[@"x10"] == nil || (NSNull *)json[@"x10"] == [NSNull null] ? @"0%" : [NSString stringWithFormat:@"%.f%%", round([json[@"x10"] floatValue])]];
                [formaldehydeLabel setText:json[@"x9"] == nil || (NSNull *)json[@"x9"] == [NSNull null] ? @"0mg/m³" : [NSString stringWithFormat:@"%.fmg/m³", round([json[@"x9"] floatValue])]];
            }
        }
    }];
    [host startRequest:request];
}



@end
