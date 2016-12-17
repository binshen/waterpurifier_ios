//
//  ChangeDeviceNamePage.m
//  airtree
//
//  Created by WindShan on 2016/11/18.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "ChangeDeviceNamePage.h"

@interface ChangeDeviceNamePage ()<UITextFieldDelegate>
{
    UITextField * deviceNameTextField;
    
    UIButton * resetDeviceNameBtn;
}

@end

@implementation ChangeDeviceNamePage

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.title = @"设备名称";
    [self setNavigationLeft:@"返回" sel:@selector(backAction)];
    
    deviceNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 35)];
    deviceNameTextField.secureTextEntry = NO;
    deviceNameTextField.placeholder = @"    请输入新的名称";
    deviceNameTextField.font = [UIFont fontWithName:@"Arial" size:16];
    deviceNameTextField.delegate = self;
    deviceNameTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    deviceNameTextField.layer.masksToBounds=YES;
    deviceNameTextField.layer.cornerRadius=5.0f;
    deviceNameTextField.layer.borderWidth= 1.0f;
    deviceNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:deviceNameTextField];
    
    NSDictionary *device = _selectedDevice;
    if (device[@"name"] != nil) {
        [deviceNameTextField setText:device[@"name"]];
    } else {
        [deviceNameTextField setText:device[@"mac"]];
    }
    
    
    resetDeviceNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetDeviceNameBtn.frame = CGRectMake(30,90, SCREEN_WIDTH-60, 40);
    [resetDeviceNameBtn setTitle:@"确定" forState:UIControlStateNormal];
    resetDeviceNameBtn.backgroundColor = BLUE_BUTTON_COLOR;
    resetDeviceNameBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [resetDeviceNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetDeviceNameBtn.layer.masksToBounds=YES;
    resetDeviceNameBtn.layer.cornerRadius=5.0f;
    [resetDeviceNameBtn addTarget:self action:@selector(resetDeviceNameAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetDeviceNameBtn];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    resetDeviceNameBtn.userInteractionEnabled = YES;
    resetDeviceNameBtn.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark button event begin
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)resetDeviceNameAction
{
    if(deviceNameTextField.text.length == 0)
    {
        [Global alertMessageEx:@"请输入设备名称." title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
    }
    else
    {
        NSString *path = [NSString stringWithFormat:@"/user/%@/device/%@/update_name", _loginUser[@"_id"], _selectedDevice[@"_id"]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:deviceNameTextField.text forKey:@"name"];
        
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
        MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
        [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
         {
            NSError *error = [completedRequest error];
            NSData *data = [completedRequest responseData];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *success = [json objectForKey:@"success"];
            NSLog(@"Success: %@", success);
            if( success != nil && [success boolValue])
            {
                [_selectedDevice setObject:deviceNameTextField.text forKey:@"name"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSString* errorTips = [json objectForKey:@"error"] == nil?@"获取数据异常":[json objectForKey:@"error"];
                [Global alertMessageEx:errorTips title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
            }
        }];
        
        [host startRequest:request];
    }
}
#pragma mark button event end

#pragma mark disappear keyboard begin

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return true;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self textFieldShouldReturn:deviceNameTextField];
}

#pragma mark disappear keyboard end


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
