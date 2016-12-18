//
// Created by Bin Shen on 16/12/2016.
// Copyright (c) 2016 Bin Shen. All rights reserved.
//

#import "LoginPage.h"
#import "GloriaLabel.h"
#import "RegisterPage.h"

@interface LoginPage() {
    UIButton * nomalLoginBtn;
    UITextField * userPhoneTextField;
    UITextField * userPwdTextFeild;

    UIButton * registBtn;
    UIButton * forgetBtn;

    GloriaLabel * tipsLabel;

    UIImageView * logoImageView;

    UIView *normalLoginView; //普通登录界面
}
@end

@implementation LoginPage

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.navigationController.navigationBarHidden = YES;

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    //self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    nomalLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nomalLoginBtn.frame = CGRectMake(30, SCREEN_HEIGHT/2+65, SCREEN_WIDTH-60, 40);
    [nomalLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    nomalLoginBtn.backgroundColor = BLUE_BUTTON_COLOR;
    nomalLoginBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [nomalLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nomalLoginBtn.layer.masksToBounds=YES;
    nomalLoginBtn.layer.cornerRadius=8.0f;
    [nomalLoginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nomalLoginBtn];

    registBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registBtn.frame = CGRectMake(SCREEN_WIDTH-150, SCREEN_HEIGHT/2+125, 120, 40);
    [registBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [registBtn setTitleColor:BLUE_BUTTON_COLOR forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(fogotPwdAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];

    registBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registBtn.frame = CGRectMake(30, SCREEN_HEIGHT/2+125, 60, 40);
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [registBtn setTitleColor:BLUE_BUTTON_COLOR forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];

    userPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-60, SCREEN_WIDTH-60, 35)];
    userPhoneTextField.placeholder = @"    请输入手机号";
    userPhoneTextField.font = [UIFont fontWithName:@"Arial" size:16];
    userPhoneTextField.delegate = self;
    userPhoneTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    userPhoneTextField.layer.masksToBounds=YES;
    userPhoneTextField.layer.cornerRadius=8.0f;
    userPhoneTextField.layer.borderWidth= 1.0f;
    userPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    userPhoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:userPhoneTextField];

    userPwdTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2, SCREEN_WIDTH-60, 35)];
    userPwdTextFeild.placeholder = @"    请输入密码";
    userPwdTextFeild.secureTextEntry = YES;
    userPwdTextFeild.font = [UIFont fontWithName:@"Arial" size:16];
    userPwdTextFeild.delegate = self;
    userPwdTextFeild.tag = 204;
    userPwdTextFeild.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    userPwdTextFeild.layer.masksToBounds=YES;
    userPwdTextFeild.layer.cornerRadius=8.0f;
    userPwdTextFeild.layer.borderWidth= 1.0f;
    userPwdTextFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:userPwdTextFeild];

    tipsLabel = [[GloriaLabel alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 60)];
    tipsLabel.font = [UIFont systemFontOfSize:26.0];
    tipsLabel.textColor = [UIColor blackColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.text = @"FEI环境数";
    [self.view addSubview:tipsLabel];

    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, 60, 250, 100)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    logoImageView.userInteractionEnabled = YES;
    //logoImageView.backgroundColor = [UIColor whiteColor];
    [logoImageView.layer setMasksToBounds:YES];
    [logoImageView.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [self.view addSubview:logoImageView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)userLogin
{
    // 执行登录操作
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中...";
    // 隐藏时候从父控件中移除
    HUD.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    HUD.dimBackground = YES;

    NSString *path = [[NSString alloc] initWithFormat:@"/user/login"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userPhoneTextField.text forKey:@"username"];
    [param setValue:userPwdTextFeild.text forKey:@"password"];

    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
    BASE_INFO_FUN(param);
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {

        HUD.hidden = YES;

        //NSString *response = [completedRequest responseAsString];
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];

        if (data == nil)
        {
            BASE_ERROR_FUN(error);
            [Global alertMessageEx:@"请检查网络." title:@"登录失败" okTtitle:nil cancelTitle:@"确定" delegate:self];
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请检查网络." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[alert show];
        }
        else
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *success = [json objectForKey:@"success"];
            BASE_INFO_FUN(json);
            NSDictionary *user = [json objectForKey:@"user"];
            if (success != nil && [success boolValue] && ![user isEqual:[NSNull null]])
            {
                _loginUser = [user mutableCopy];

                // 存储用户信息
                [UserDefault setObject:@"1" forKey:@"isLogin"];
                [UserDefault setObject:user[@"_id"] forKey:@"user_id"];
                [UserDefault setObject:user[@"username"] forKey:@"username"];
                [UserDefault setObject:user[@"password"] forKey:@"password"];
                [UserDefault setObject:user[@"email"] forKey:@"email"];
                [UserDefault setObject:user[@"nickname"] forKey:@"nickname"];
                [UserDefault synchronize];//使用synchronize强制立即将数据写入磁盘,防止在写完NSUserDefaults后程序退出导致的数据丢失

                // 跳转主界面
                //[GetAppDelegate showHomePage];
            }
            else
            {
                [UserDefault setObject:@"0" forKey:@"isLogin"];
                [Global alertMessageEx:@"输入的用户名或密码错误." title:@"登录失败" okTtitle:nil cancelTitle:@"确定" delegate:self];
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"输入的用户名或密码错误." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //[alert show];
            }
        }
    }];

    [host startRequest:request];

}

-(void)registAction
{
    // 调转注册界面操作
    RegisterPage * registerPage = [[RegisterPage alloc] initIsFirstPage:NO];
    [self.navigationController pushViewController:registerPage animated:YES];
}

-(void)fogotPwdAction
{
//    // 调转重置界面操作
//    FogetPwdPage * fogetPwdPage = [[FogetPwdPage alloc] initIsFirstPage:NO];
//    [self.navigationController pushViewController:fogetPwdPage animated:YES];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger textLength = 0;

    if ([string isEqualToString:@""]) {
        textLength = textField.text.length-1;
    }
    else
    {
        textLength = textField.text.length+1;
    }

    BOOL flag = NO;
    if( textField == userPhoneTextField )
    {
        // 检测手机号是否合法
        if( textLength == 11 && [StringUtil isMobile:[userPhoneTextField.text stringByAppendingString:string]] == NO)
        {
            [Global alertMessage:@"手机号码不合法，请重新输入！"];
        }

        // 大于11位数不让输入
        if( textLength > 11 )
            return NO;
    }

    flag = YES;
    if (flag)
    {
//        [loginBtn setBackgroundColor:BLUECOLOR];
//        loginBtn.userInteractionEnabled = YES;
    }
    else
    {
//        loginBtn.backgroundColor = [UIColor lightGrayColor];
//        loginBtn.userInteractionEnabled = NO;
    }

    return flag;
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
    [self textFieldShouldReturn:userPhoneTextField];
    [self textFieldShouldReturn:userPwdTextFeild];
}

@end