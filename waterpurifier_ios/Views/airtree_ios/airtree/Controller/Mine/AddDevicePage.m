//
//  AddDevicePage.m
//  airtree
//
//  Created by WindShan on 2016/11/18.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "AddDevicePage.h"
#import "smartlinklib_7x.h"
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "GloriaLabel.h"

@interface AddDevicePage ()<UITextFieldDelegate>
{
    UITextField * wifiSSIDTextField; // wifi 名字
    UITextField * wifiPwdTextField; // wifi密码
    UIButton * connectBtn;
    //UIProgressView *connectProgressView; // 连接进度
    //UISwitch *oneDeviceSwitch;
    BOOL isconnecting;
#ifdef USE_SmartLink
    HFSmartLink * smtlk;
#endif
}
@end

@implementation AddDevicePage

- (void)viewDidLoad {
    [super viewDidLoad];
 
#ifdef USE_SmartLink
    smtlk = [HFSmartLink shareInstence];
    smtlk.isConfigOneDevice = true;
    smtlk.waitTimers = 30;
#endif

    self.title = @"添加设备";
    [self setNavigationLeft:@"返回" sel:@selector(backAticon)];
    
    isconnecting = false;
    
    wifiSSIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 35)];
    wifiSSIDTextField.secureTextEntry = NO;
    wifiSSIDTextField.placeholder = @"    请输入Wifi名字";
    wifiSSIDTextField.font = [UIFont fontWithName:@"Arial" size:16];
    wifiSSIDTextField.delegate = self;
    wifiSSIDTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    wifiSSIDTextField.layer.masksToBounds = YES;
    wifiSSIDTextField.layer.cornerRadius = 5.0f;
    wifiSSIDTextField.layer.borderWidth = 1.0f;
    wifiSSIDTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:wifiSSIDTextField];
    
    wifiPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, SCREEN_WIDTH-60, 35)];
    wifiPwdTextField.secureTextEntry = YES;
    wifiPwdTextField.placeholder = @"    请输入wifi密码";
    wifiPwdTextField.font = [UIFont fontWithName:@"Arial" size:16];
    wifiPwdTextField.delegate = self;
    wifiPwdTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    wifiPwdTextField.layer.masksToBounds=YES;
    wifiPwdTextField.layer.cornerRadius=5.0f;
    wifiPwdTextField.layer.borderWidth= 1.0f;
    wifiPwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:wifiPwdTextField];
    
//    //进度条的创建
//    connectProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(30, 260, SCREEN_WIDTH-60, 3)];
//    //甚至进度条的风格颜色值，默认是蓝色的
//    connectProgressView.progressTintColor = [UIColor blueColor];
//    //表示进度条未完成的，剩余的轨迹颜色,默认是灰色
//    connectProgressView.trackTintColor = RgbColor(184, 184, 184);
//    //设置进度条的进度值
//    //范围从0~1，最小值为0，最大值为1.
//    //0.8-->进度的80%
//    connectProgressView.progress = 0.0;
//    //设置进度条的风格特征
//    connectProgressView.progressViewStyle = UIProgressViewStyleDefault;
//    [self.view addSubview:connectProgressView];
    
//    GloriaLabel* oneDeviceTips = [[GloriaLabel alloc] initWithFrame:CGRectMake(30, 150, SCREEN_WIDTH/2, 30)];
//    oneDeviceTips.font = FONT18;
//    oneDeviceTips.textColor = [UIColor blackColor];
//    oneDeviceTips.textAlignment = NSTextAlignmentLeft;
//    oneDeviceTips.text = @"配置单个设备";
//    [self.view addSubview:oneDeviceTips];
    
//    oneDeviceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 150, 100, 30)];
//    [oneDeviceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:oneDeviceSwitch];
    // oneDeviceSwitch.on = smtlk.isConfigOneDevice;

    connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    connectBtn.frame = CGRectMake(30,200, SCREEN_WIDTH-60, 40);
    [connectBtn setTitle:@"开始连接" forState:UIControlStateNormal];
    connectBtn.backgroundColor = BLUE_BUTTON_COLOR;
    connectBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    connectBtn.layer.masksToBounds=YES;
    connectBtn.layer.cornerRadius=5.0f;
    [connectBtn addTarget:self action:@selector(connectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectBtn];
    
    // 显示ssid设备名字
    [self showWifiSsid];
    wifiPwdTextField.text = [self getspwdByssid:wifiSSIDTextField.text];
    
    // Do any additional setup after loading the view.
}

#pragma mark custom action begin
-(void)backAticon
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)connectAction
{
    NSString * ssidStr = wifiSSIDTextField.text;
    NSString * pswdStr = wifiPwdTextField.text;
    
    [self savePswd];
    //connectProgressView.progress = 0.0;
    if(!isconnecting)
    {
        isconnecting = true;
#ifdef USE_SmartLink
        [smtlk startWithSSID:ssidStr Key:pswdStr withV3x:true
                processblock: ^(NSInteger pro)
         {
             //connectProgressView.progress = (float)(pro)/100.0;
             
         }
                successBlock:^(HFSmartLinkDeviceInfo *dev)
         {
             NSString *path = [[NSString alloc] initWithFormat:@"/user/add_device"];
             NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
             
             [param setValue:dev.mac forKey:@"mac"];
             [param setValue:_loginUser[@"_id"] forKey:@"userID"];
             
             MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
             MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
             [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
              {
                  NSString *response = [completedRequest responseAsString];
                  if(response == nil)
                  {
                      [self setButTitle:@"开始连接"];
                      [Global alertMessageEx:@"绑定时发生异常，请稍候再试" title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
                      return;
                  }

                  FxLog(@"Response: %@", response);
                  
                  NSError *error = [completedRequest error];
                  NSData *data = [completedRequest responseData];
                  
                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                  NSString *success = [json objectForKey:@"success"];
                  FxLog(@"Success: %@", success);
                  
                  if (success != nil && [success boolValue])
                  {
                      if([[json objectForKey:@"status"] integerValue] == 4)
                      {
                          [Global alertMessageEx:@"该设备已被其他人绑定过" title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
                      }
                      else
                      {
                          [Global alertMessageEx:@"新设备绑定成功" title:@"提示信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
                          [self dismissViewControllerAnimated:YES completion:nil];
                      }
                  }
                  else
                  {
                      NSString* errorTips = [json objectForKey:@"error"] == nil?@"获取数据异常":[json objectForKey:@"error"];
                      [Global alertMessageEx:errorTips title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
                  }
              }];
             
             [host startRequest:request];
         }
            failBlock:^(NSString *failmsg)
         {
             [self setButTitle:@"开始连接"];
             [Global alertMessageEx:@"绑定时发生异常，请稍候再试" title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
         }
                    endBlock:^(NSDictionary *deviceDic)
         {
             isconnecting  = false;
             
             [self setButTitle:@"开始连接"];
         }];
#endif
        [self setButTitle:@"正在连接..."];
        
    }
    else
    {
        
#ifdef USE_SmartLink
        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk)
         {
             if(isOk)
             {
                 isconnecting = false;
                 [self setButTitle:@"开始连接"];
                 [Global alertMessageEx:@"配网模式已被终止" title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
             }
             else
             {
                 [Global alertMessageEx:@"配网模式已被终止" title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
             }
         }];
#endif

    }

}

//-(void)switchAction:(id)sender
//{
//    UISwitch *switchBtn = (UISwitch *)sender;
//    
//    if(switchBtn.on)
//    {
//#ifdef USE_SmartLink
//       smtlk.isConfigOneDevice = true;
//#endif
//    }
//    else
//    {
//#ifdef USE_SmartLink
//        smtlk.isConfigOneDevice = false;
//#endif
//    }
//    
//}
#pragma mark end

#pragma mark custom function begin

-(void)savePswd
{
    [UserDefault setObject:wifiPwdTextField.text forKey:wifiSSIDTextField.text];
}

-(NSString *)getspwdByssid:(NSString * )mssid
{
    return [UserDefault objectForKey:mssid];
}

- (void)showWifiSsid
{
    BOOL wifiOK = FALSE;
    NSDictionary *ifs;
    NSString *ssid;
    
    if (!wifiOK)
    {
        ifs = [self fetchSSIDInfo];
        ssid = [ifs objectForKey:@"SSID"];
        
        if (ssid != nil)
        {
            wifiOK= TRUE;
            wifiSSIDTextField.text = ssid;
        }
        else
        {
            [Global alertMessageEx:[NSString stringWithFormat:@"请先连接Wi-Fi"] title:@"提示" okTtitle:nil cancelTitle:@"关闭" delegate:self];
        }
    }
}

- (id)fetchSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    FxLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    
    for (NSString *ifnam in ifs)
    {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        FxLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    
    return info;
}

- (void) setButTitle:(NSString *) title
{
    NSAttributedString *attributedTitle = [connectBtn attributedTitleForState:UIControlStateNormal];
    NSMutableAttributedString *butTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitle];
    [butTitle.mutableString setString:title];
    [connectBtn setAttributedTitle:butTitle forState:UIControlStateNormal];
    
}

#pragma mark end

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
#ifdef USE_SmartLink
    [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
        isconnecting  = false;
        [self setButTitle:@"开始连接"];
    }];
#endif

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self textFieldShouldReturn:wifiSSIDTextField];
    [self textFieldShouldReturn:wifiPwdTextField];
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
