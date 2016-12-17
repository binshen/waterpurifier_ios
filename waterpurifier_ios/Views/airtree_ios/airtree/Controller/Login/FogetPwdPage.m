//
//  FogetPwdPage.m
//  airtree
//
//  Created by WindShan on 2016/11/11.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "FogetPwdPage.h"
#import "GloriaLabel.h"

@interface FogetPwdPage ()
{
    UITextField * userPhoneTextField;
    UITextField * checkCodeTextField;
    UITextField * userNewPwdTextField;
    
    GloriaLabel * getCheckCodeLabel;
    UIButton * resetUserPwdBtn;
    UIButton *sendBtn;
    dispatch_source_t _timer;
    
}
@end

@implementation FogetPwdPage


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    [self setNavigationLeft:@"返回" sel:@selector(backAction)];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    
    userPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-180, 35)];
    userPhoneTextField.secureTextEntry = NO;
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

    checkCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, SCREEN_WIDTH-60, 35)];
    checkCodeTextField.secureTextEntry = NO;
    checkCodeTextField.placeholder = @"    请输入验证码";
    checkCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    checkCodeTextField.font = [UIFont fontWithName:@"Arial" size:16];
    checkCodeTextField.delegate = self;
    checkCodeTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    checkCodeTextField.layer.masksToBounds=YES;
    checkCodeTextField.layer.cornerRadius=8.0f;
    checkCodeTextField.layer.borderWidth= 1.0f;
    checkCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:checkCodeTextField];
    
    userNewPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 160, SCREEN_WIDTH-60, 35)];
    userNewPwdTextField.secureTextEntry = YES;
    userNewPwdTextField.placeholder = @"    请输入新的密码";
    userNewPwdTextField.font = [UIFont fontWithName:@"Arial" size:16];
    userNewPwdTextField.delegate = self;
    userNewPwdTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    userNewPwdTextField.layer.masksToBounds=YES;
    userNewPwdTextField.layer.cornerRadius=8.0f;
    userNewPwdTextField.layer.borderWidth= 1.0f;
    userNewPwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:userNewPwdTextField];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendBtn.frame = CGRectMake(SCREEN_WIDTH-130,60,120, 40);
    [sendBtn setTitleColor:BLACKTEXTCOLOR_SUB forState:UIControlStateNormal];
    sendBtn.userInteractionEnabled = NO;
    [sendBtn addTarget:self action:@selector(getCheckCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    getCheckCodeLabel = [[GloriaLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 40, 90, 35)];
    getCheckCodeLabel.font = FONT14;
    getCheckCodeLabel.backgroundColor = BLUE_BUTTON_COLOR;
    getCheckCodeLabel.textColor = [UIColor whiteColor];
    getCheckCodeLabel.textAlignment = NSTextAlignmentCenter;
    getCheckCodeLabel.text = @"获取验证码";
    getCheckCodeLabel.userInteractionEnabled = NO;
    [self.view addSubview:getCheckCodeLabel];
    
    resetUserPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetUserPwdBtn.frame = CGRectMake(30, 220, SCREEN_WIDTH-60, 40);
    [resetUserPwdBtn setTitle:@"重置密码" forState:UIControlStateNormal];
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
    
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    
    sendBtn.userInteractionEnabled = YES;
    sendBtn.alpha = 1;
    getCheckCodeLabel.text = @"获取验证码";
}

#pragma mark custom function begin
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
////倒计时提醒
-(void)startCountDown{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                sendBtn.userInteractionEnabled = YES;
                sendBtn.alpha = 1;
                
                getCheckCodeLabel.text = @"重新获取";
                
            });
        }
        else
        {
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                FxLog(@"____%@",strTime);
                sendBtn.userInteractionEnabled = NO;
                sendBtn.alpha = 0.4;

                getCheckCodeLabel.text = [NSString stringWithFormat:@"%@秒",strTime];
            });
            
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}
# pragma mark custom function end


#pragma mark button event begin
-(void)resetUserPwdAction
{
    // 重置密码操作
    if(userPhoneTextField.text.length == 0)
    {
        [Global alertMessageEx:@"请输入手机号." title:@"错误信息" okTtitle:nil cancelTitle:@"OK"  delegate:self];
    }
    else if(checkCodeTextField.text.length == 0)
    {
        [Global alertMessageEx:@"请输入验证码." title:@"错误信息" okTtitle:nil cancelTitle:@"OK"  delegate:self];
    }
    else if(userNewPwdTextField.text.length == 0)
    {
        [Global alertMessageEx:@"请输入密码." title:@"错误信息" okTtitle:nil cancelTitle:@"OK"  delegate:self];
    }
    else
    {
        NSString *path = [[NSString alloc] initWithFormat:@"/user/forget_psw"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userPhoneTextField.text forKey:@"username"];
        [param setValue:userNewPwdTextField.text forKey:@"password"];
        [param setValue:checkCodeTextField.text forKey:@"code"];
        
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
        MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
        [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
         {
            NSError *error = [completedRequest error];
            NSData *data = [completedRequest responseData];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *success = [json objectForKey:@"success"];
            BASE_INFO_FUN(json);
            if(success != nil && [success boolValue])
            {
                [Global alertMessageEx:@"密码修改成功!" title:@"提示信息" okTtitle:nil cancelTitle:@"OK"  delegate:self];
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
//获取验证码
-(void)getCheckCodeAction
{
    NSString *path = [[NSString alloc] initWithFormat:@"/user/request_code"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userPhoneTextField.text forKey:@"tel"];
    [param setValue:@"2" forKey:@"type"];
    
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *success = [json objectForKey:@"success"];
        NSLog(@"Success: %@", success);
        if(success != nil && [success boolValue])
        {
            //发送成功提示
            [self startCountDown];
             [Global alertMessageEx:@"提示信息" title:@"验证码发送成功!"  okTtitle:nil cancelTitle:@"OK" delegate:self];
        }
        else
        {
            NSString* errorTips = [json objectForKey:@"error"] == nil?@"获取数据异常":[json objectForKey:@"error"];
            [Global alertMessageEx:errorTips title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];        }
    }];
    
    [host startRequest:request];
}

#pragma mark button event end

#pragma mark disappear keyboard begin
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int textLength = 0;
    
    if ([string isEqualToString:@""]) {
        textLength = textField.text.length-1;
    }else
    {
        textLength = textField.text.length+1;
    }
    
    BOOL flag = NO;
    if( textField == userPhoneTextField )
    {
        // 大于11位数不让输入
        if( textLength > 11 )
            return NO;
        
        // 检测手机号是否合法
        if( textLength == 11 && [StringUtil isMobile:[userPhoneTextField.text stringByAppendingString:string]] == NO)
        {
            [Global alertMessage:@"手机号码不合法，请重新输入！"];
        }
        else if( textLength == 11 && [StringUtil isMobile:[userPhoneTextField.text stringByAppendingString:string]] == YES)
        {
            getCheckCodeLabel.textColor = NAVIGATIONTINTCOLOR;
            getCheckCodeLabel.backgroundColor = [UIColor whiteColor];
            sendBtn.userInteractionEnabled = YES;
        }
        else
        {
            getCheckCodeLabel.backgroundColor = BLUE_BUTTON_COLOR;
            getCheckCodeLabel.textColor = [UIColor whiteColor];
            sendBtn.userInteractionEnabled = NO;
        }
        
    }
    
    if( textField == checkCodeTextField )
    {
        // 大于11位数不让输入
        if( textLength > 6 )
            return NO;

    }
    
    flag = YES;
    
    //    if (textField.tag - 200 == 1) {
    //
    //        if (textLength == 11) {
    //            //满11位高亮获取验证码
    //            //            sendBtn.layer.borderWidth = 1.0;
    //            //            sendBtn.layer.borderColor = NAVIGATIONTINTCOLOR.CGColor;
    //            //            [sendBtn setTitleColor:NAVIGATIONTINTCOLOR forState:UIControlStateNormal];
    //            sencondLabel.textColor = NAVIGATIONTINTCOLOR;
    //            sendBtn.userInteractionEnabled = YES;
    //
    //            if (verifyTextField.text.length > 0) {
    //                quickBtn.backgroundColor = NAVIGATIONTINTCOLOR;
    //                quickBtn.userInteractionEnabled = YES;
    //            }
    //        }else
    //        {
    //            //            sendBtn.layer.borderWidth = 1.0;
    //            //            sendBtn.layer.borderColor = BLACKTEXTCOLOR_SUB.CGColor;
    //            //[sendBtn setTitleColor:BLACKTEXTCOLOR_SUB forState:UIControlStateNormal];
    //            sencondLabel.textColor = BLACKTEXTCOLOR_SUB;
    //            sendBtn.userInteractionEnabled = NO;
    //
    //            quickBtn.backgroundColor = BLACKTEXTCOLOR_SUB;
    //            [quickBtn setBackgroundImage:nil forState:UIControlStateNormal];
    //            quickBtn.userInteractionEnabled = NO;
    //        }
    //    }else
    //    {
    //        if (textField == phoneTextField) {
    //            if (textLength == 11 && verifyTextField.text.length > 0) {
    //                quickBtn.backgroundColor = NAVIGATIONTINTCOLOR;
    //                quickBtn.userInteractionEnabled = YES;
    //            }else
    //            {
    //                quickBtn.backgroundColor = BLACKTEXTCOLOR_SUB;
    //                [quickBtn setBackgroundImage:nil forState:UIControlStateNormal];
    //                quickBtn.userInteractionEnabled = NO;
    //            }
    //        }else
    //        {
    //            if (phoneTextField.text.length ==11 && textLength > 0) {
    //                quickBtn.backgroundColor = NAVIGATIONTINTCOLOR;
    //                quickBtn.userInteractionEnabled = YES;
    //            }else
    //            {
    //                quickBtn.backgroundColor = BLACKTEXTCOLOR_SUB;
    //                [quickBtn setBackgroundImage:nil forState:UIControlStateNormal];
    //                quickBtn.userInteractionEnabled = NO;
    //            }
    //        }
    //    }
    
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return true;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self textFieldShouldReturn:checkCodeTextField];
    [self textFieldShouldReturn:userPhoneTextField];
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
