//
//  DeviceDetailsPage.m
//  airtree
//
//  Created by if on 2016/11/18.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "DeviceDetailsPage.h"
#import "DeviceDetailsInfo.h"
#import "HistoricalDataPage.h"
#import "ChangeDeviceNamePage.h"
#import "DateTimePicker.h"

@interface DeviceDetailsPage ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSTimer *timer;
    NSString *checkStatus;

}

@end

@implementation DeviceDetailsPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设备详情";
    [self setNavigationLeft:@"返回" sel:@selector(backAction)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
//    view.userInteractionEnabled = YES;
//    UIButton *quitLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    quitLoginBtn.frame =CGRectMake(20, 50, SCREEN_WIDTH-40, 40);
//    [quitLoginBtn.layer setMasksToBounds:YES];
//    [quitLoginBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
//    quitLoginBtn.backgroundColor = BLUE_BUTTON_COLOR;
//    [quitLoginBtn setTitle:@"解绑该设备" forState:UIControlStateNormal];
//    [quitLoginBtn addTarget:self action:@selector(unBindDevice) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:quitLoginBtn];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //_tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    
    
    NSDictionary *device = _selectedDevice;
    if([device[@"type"] integerValue] == 1) {
        [self loadDeviceInfoList];
    }
    
//    //此处调用加载数据的接口
//    [self loadDeviceInfoList];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *device = _selectedDevice;
    NSString *deviceName = device[@"name"] == nil ? device[@"mac"] : device[@"name"];
    NSLog(@"DeviceName: %@", deviceName);
    
    cell.detailTextLabel.text = deviceName;
    
    if([device[@"type"] integerValue] == 1)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadDeviceInfoList) userInfo:nil repeats:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
    [timer invalidate];
}


-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//加载设备数据    暂时模拟  假数据
-(void)loadDeviceInfoList
{
    NSDictionary *device = _selectedDevice;
    
    NSString *path = [NSString stringWithFormat:@"/device/mac/%@/get_test", device[@"mac"]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPGET];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
     {
        NSString *response = [completedRequest responseAsString];
        BASE_INFO_FUN(response);
        
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *test = [json objectForKey:@"test"];
        if(test != nil)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([[json objectForKey:@"created"] longLongValue] / 1000)]];
            checkStatus = [NSString stringWithFormat:@"%@(%@)", [test integerValue] == 1 ? @"需要更换" : @"无需更换", dateString];
        }
        else
        {
            checkStatus = @"";
        }
         
        //[self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = checkStatus;
         
     }];
    
    [host startRequest:request];

//    currentDeviceInfo = [[DeviceDetailsInfo alloc] init];
//    currentDeviceInfo.deviceNO = @"a8a8a8a833333udjibfs9847jihuhfbc";
//    currentDeviceInfo.deviceName = @"chongjiceshi01";
//    currentDeviceInfo.deviceType = @"从机";
//    currentDeviceInfo.deviceMAC = @"B3H38F8F8F8FDD93";
}

-(void)unBindDevice
{
    [Global alertMessageEx:@"确定要解除绑定吗" title:@"提示信息" okTtitle:@"确认" cancelTitle:@"取消" delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   // buttonIndex 0 取消 1 确定
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            NSString *path = [NSString stringWithFormat:@"/user/%@/device/%@/unbind", _loginUser[@"_id"], _selectedDevice[@"_id"]];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
            MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
            [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
             {
                // NSString *response = [completedRequest responseAsString];
                // NSLog(@"Response: %@", response);
                
                NSError *error = [completedRequest error];
                NSData *data = [completedRequest responseData];
                
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSString *success = [json objectForKey:@"success"];
                NSLog(@"Success: %@", success);
                if(success != nil && [success boolValue])
                {
                    [Global alertMessageEx:@"解除绑定成功!" title:@"提示信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
               
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    NSString* errorTips = [json objectForKey:@"error"] == nil?@"获取数据异常":[json objectForKey:@"error"];
                    [Global alertMessageEx:errorTips title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
                }
            }];
            
            [host startRequest:request];

        }
            break;
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

//此处上面和下面 是设置 footerview
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    UIButton *quitLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitLoginBtn.frame =CGRectMake(20, 50, SCREEN_WIDTH-40, 40);
    [quitLoginBtn.layer setMasksToBounds:YES];
    [quitLoginBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    quitLoginBtn.backgroundColor = BLUE_BUTTON_COLOR;
    [quitLoginBtn setTitle:@"解绑该设备" forState:UIControlStateNormal];
    [quitLoginBtn addTarget:self action:@selector(unBindDevice) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:quitLoginBtn];
    
    
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"deviceManage";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger type = [_selectedDevice[@"type"] integerValue];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"设备编号";
            cell.textLabel.font = FONT16;
            cell.textLabel.textColor = BLACKTEXTCOLOR_TITLE;
            
            cell.detailTextLabel.text = _selectedDevice[@"_id"];
            cell.detailTextLabel.font = FONT14;
            cell.detailTextLabel.textColor = BLACKTEXTCOLOR_SUB;
            
        }
            break;
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.text = @"设备名称";
            cell.textLabel.font = FONT16;
            cell.textLabel.textColor = BLACKTEXTCOLOR_TITLE;
            cell.userInteractionEnabled = YES;
            cell.detailTextLabel.text = [_selectedDevice valueForKey:@"name"] == nil ? _selectedDevice[@"mac"] : _selectedDevice[@"name"];
            cell.detailTextLabel.font = FONT14;
            cell.detailTextLabel.textColor = BLACKTEXTCOLOR_SUB;
            
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"类型";
            cell.textLabel.font = FONT16;
            cell.textLabel.textColor = BLACKTEXTCOLOR_TITLE;
            
            cell.detailTextLabel.text = (type == 1 ? @"主机" : @"从机");
            cell.detailTextLabel.font = FONT14;
            cell.detailTextLabel.textColor = BLACKTEXTCOLOR_SUB;
            
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"MAC";
            cell.textLabel.font = FONT16;
            cell.textLabel.textColor = BLACKTEXTCOLOR_TITLE;
            
            cell.detailTextLabel.text = [_selectedDevice[@"mac"] uppercaseString];
            cell.detailTextLabel.font = FONT14;
            cell.detailTextLabel.textColor = BLACKTEXTCOLOR_SUB;

        }
            break;
        case 4:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = YES;
            cell.textLabel.text = @"历史数据";
            cell.textLabel.font = FONT16;
            cell.textLabel.textColor = BLACKTEXTCOLOR_TITLE;
            
            
        }
            break;
        case 5:
            if(type == 1)
            {
                cell.textLabel.text = @"滤网检测";
                //cell.detailTextLabel.text = self.checkStatus;
            } else {
                cell.textLabel.text = @"";
                cell.detailTextLabel.text = @"";
            }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            
            
        }
            break;
        case 1:
        {
            
            ChangeDeviceNamePage *page = [[ChangeDeviceNamePage alloc] initIsFirstPage:NO];
            [self.navigationController pushViewController:page animated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
            
        }
            break;
        case 4:
        {
            HistoricalDataPage *historicalDataPage = [[HistoricalDataPage alloc] initIsFirstPage:NO];
            historicalDataPage.deviceName = [_selectedDevice valueForKey:@"name"] == nil ? _selectedDevice[@"mac"] : _selectedDevice[@"name"];
            [self.navigationController pushViewController:historicalDataPage animated:YES];
        }
            break;
        default:
            break;
    }

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
