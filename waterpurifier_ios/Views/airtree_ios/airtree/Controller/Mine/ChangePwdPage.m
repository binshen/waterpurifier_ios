//
//  ChangePwdPage.m
//  airtree
//
//  Created by WindShan on 2016/11/11.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "ChangePwdPage.h"
#import "GloriaLabel.h"

@interface ChangePwdPage ()
{
    UITextField * userOldPwdTextField;
    UITextField * userNewPwdTextField;
    UITextField * userSurePwdTextField;
    
    UIButton * resetUserPwdBtn;

    
}
@end

@implementation ChangePwdPage


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";

    userOldPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 35)];
    userOldPwdTextField.secureTextEntry = NO;
    userOldPwdTextField.placeholder = @"    请输入原密码";
    userOldPwdTextField.font = [UIFont fontWithName:@"Arial" size:16];
    userOldPwdTextField.delegate = self;
    userOldPwdTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    userOldPwdTextField.layer.masksToBounds=YES;
    userOldPwdTextField.layer.cornerRadius=8.0f;
    userOldPwdTextField.layer.borderWidth= 1.0f;
    userOldPwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:userOldPwdTextField];

    userNewPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, SCREEN_WIDTH-60, 35)];
    userNewPwdTextField.secureTextEntry = YES;
    userNewPwdTextField.placeholder = @"    请输入新密码";
    userNewPwdTextField.font = [UIFont fontWithName:@"Arial" size:16];
    userNewPwdTextField.delegate = self;
    userNewPwdTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    userNewPwdTextField.layer.masksToBounds=YES;
    userNewPwdTextField.layer.cornerRadius=8.0f;
    userNewPwdTextField.layer.borderWidth= 1.0f;
    userNewPwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:userNewPwdTextField];
    
    userSurePwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 160, SCREEN_WIDTH-60, 35)];
    userSurePwdTextField.secureTextEntry = YES;
    userSurePwdTextField.placeholder = @"    请输入确认密码";
    userSurePwdTextField.font = [UIFont fontWithName:@"Arial" size:16];
    userSurePwdTextField.delegate = self;
    userSurePwdTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    userSurePwdTextField.layer.masksToBounds=YES;
    userSurePwdTextField.layer.cornerRadius=8.0f;
    userSurePwdTextField.layer.borderWidth= 1.0f;
    userSurePwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:userSurePwdTextField];
    
    resetUserPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetUserPwdBtn.frame = CGRectMake(30,220, SCREEN_WIDTH-60, 40);
    [resetUserPwdBtn setTitle:@"提交修改" forState:UIControlStateNormal];
    resetUserPwdBtn.backgroundColor = BLUE_BUTTON_COLOR;
    resetUserPwdBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [resetUserPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetUserPwdBtn.layer.masksToBounds=YES;
    resetUserPwdBtn.layer.cornerRadius=5.0f;
    [resetUserPwdBtn addTarget:self action:@selector(resetUserPwdAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetUserPwdBtn];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    resetUserPwdBtn.userInteractionEnabled = YES;
    resetUserPwdBtn.alpha = 1;
}

#pragma mark custom function begin
////倒计时提醒
# pragma mark custom function end


#pragma mark button event begin
-(void)resetUserPwdAction
{
    // 重置密码操作
    if(userOldPwdTextField.text.length == 0)
    {
        [Global alertMessageEx:@"请输入原密码." title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
    }
    else if(userNewPwdTextField.text.length == 0)
    {
        [Global alertMessageEx:@"请输入新密码." title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];

    }
    else if(userSurePwdTextField.text.length == 0)
    {
        [Global alertMessageEx:@"请输入确认密码." title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
    }
    else if(![userNewPwdTextField.text isEqual:userSurePwdTextField.text])
    {
        [Global alertMessageEx:@"两次输入的新密码不一致." title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
    }
    else
    {
        NSString *path = [NSString stringWithFormat:@"/user/%@/change_psw", _loginUser[@"_id"]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userOldPwdTextField.text forKey:@"password"];
        [param setValue:userNewPwdTextField.text forKey:@"new_password"];
        
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
        MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
        [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
         {
            // NSString *response = [completedRequest responseAsString];
            // NSLog(@"Response: %@", response);
            
            NSError *error = [completedRequest error];
            NSData *data = [completedRequest responseData];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            FxLog(@"json: %@", json);
            NSString *success = [json objectForKey:@"success"];
            FxLog(@"Success: %@", success);
            if(success != nil && [success boolValue])
            {
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
    [self textFieldShouldReturn:userOldPwdTextField];
    [self textFieldShouldReturn:userSurePwdTextField];
    [self textFieldShouldReturn:userNewPwdTextField];
}

#pragma mark disappear keyboard end



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
