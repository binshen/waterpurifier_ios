//
//  ManageDeviceListPage.m
//  airtree
//
//  Created by if on 2016/11/18.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "ManageDeviceListPage.h"
#import "DeviceStatus.h"
#import "Reachability.h"
#import "DeviceDetailsPage.h"
#import "AddDevicePage.h"
#import "BaseNaviController.h"
@interface ManageDeviceListPage ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *deviceArray; //设备数组
    NSTimer *timer;
}

@end

@implementation ManageDeviceListPage

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    //开启定时器
    if(timer!=nil)
        [timer setFireDate:[NSDate distantPast]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
    //关闭定时器
    if(timer!=nil)
        [timer setFireDate:[NSDate distantFuture]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设备管理";
    [self setNavigationLeft:@"返回" sel:@selector(backAction)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarbtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction)];
    //rightBarbtn.tintColor = NAVIGATIONTINTCOLOR;
    self.navigationItem.rightBarButtonItem=rightBarbtn;

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //此处调用加载数据的接口
    [self loadDeviceInfoList:YES];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(updateDeviceInfoList) userInfo:nil repeats:YES];
    
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//加载设备数据    暂时模拟  假数据

-(void)updateDeviceInfoList
{
    [self loadDeviceInfoList:NO];
}

-(void)loadDeviceInfoList:(BOOL)bTips
{
    MBProgressHUD *HUD;
    if(bTips)
    {
        // 执行登录操作
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"数据加载中...";
        // 隐藏时候从父控件中移除
        HUD.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        HUD.dimBackground = YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/user/%@/get_device_info", _loginUser[@"_id"]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPGET];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
    {
        if(bTips&&HUD!=nil)
        {
            HUD.hidden = YES;
        }
        
        NSString *response = [completedRequest responseAsString];
        BASE_INFO_FUN(response);
        //NSLog(@"Response: %@", response);
        
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        
        if (data == nil) {
            
        }
        else
        {
            deviceArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        
        [_tableView reloadData];
    }];
    [host startRequest:request];
    
    
//    if (deviceArray) {
//        [deviceArray removeAllObjects];
//        deviceArray = nil;
//    }
//    deviceArray = [[NSMutableArray alloc] init];
//    
//    DeviceStatus *info = [[DeviceStatus alloc] init];
//    info.deviceName = @"中国环境院用";
//    info.deviceStatus = @"不在线";
//    [deviceArray addObject:info];
//    
//    DeviceStatus *info2 = [[DeviceStatus alloc] init];
//    info2.deviceName = @"5151大屏机";
//    info2.deviceStatus = @"云端在线";
//    [deviceArray addObject:info2];
//    
//    DeviceStatus *info3 = [[DeviceStatus alloc] init];
//    info3.deviceName = @"测试数字机22222";
//    info3.deviceStatus = @"不在线";
//    [deviceArray addObject:info3];
//    
//    DeviceStatus *info4 = [[DeviceStatus alloc] init];
//    info4.deviceName = @"chongjiceshi01";
//    info4.deviceStatus = @"云端在线";
//    [deviceArray addObject:info4];
//    
//    [tableView reloadData];
}
-(void)rightAction
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status != ReachableViaWiFi)
    {
        [Global alertMessageEx:@"请先连接WIFI网络." title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
        return ;
    }

    AddDevicePage *page = [[AddDevicePage alloc] init];
    BaseNaviController *navi = [[BaseNaviController alloc] initWithRootViewController:page];
     [self presentViewController:navi animated:YES completion:nil];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [deviceArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"deviceManage";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSUInteger row = [indexPath row];
    NSDictionary *device = [deviceArray objectAtIndex:row];
    cell.textLabel.text = [device valueForKey:@"name"] == nil ? device[@"mac"] : device[@"name"];
    BASE_INFO_FUN(cell.textLabel.text);
    cell.detailTextLabel.text = [device[@"status"] integerValue] == 1 ? @"云端在线" : @"不在线";
    cell.imageView.image = [UIImage imageNamed:@"ic_device_25"];
    cell.textLabel.font = FONT16;
    cell.textLabel.textColor = BLACKTEXTCOLOR_TITLE;
    cell.detailTextLabel.text = [device[@"status"] integerValue] == 1 ? @"云端在线" : @"不在线";
    cell.detailTextLabel.font = FONT14;
    cell.detailTextLabel.textColor = BLACKTEXTCOLOR_SUB;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     _selectedDevice = [[deviceArray objectAtIndex:[indexPath row]] mutableCopy];
    
    DeviceDetailsPage *page = [[DeviceDetailsPage alloc] initIsFirstPage:NO];
    BaseNaviController *loginNav = [[BaseNaviController alloc] initWithRootViewController:page];
    [self presentViewController:loginNav animated:YES completion:nil];
    
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
