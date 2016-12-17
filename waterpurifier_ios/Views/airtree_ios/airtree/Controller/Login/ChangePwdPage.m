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
    UITextField * userPhoneTextField;
    UITextField * checkCodeTextField;
    UITextField * userNewPwdTextField;
    
    GloriaLabel * getCheckCodeLabel;
    UIButton * resetUserPwdBtn;
    
    dispatch_source_t _timer;
    
}
@end

@implementation ChangePwdPage


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";

    userPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 60, SCREEN_WIDTH-180, 35)];
    userPhoneTextField.secureTextEntry = NO;
    userPhoneTextField.placeholder = @"    请输入手机号";
    userPhoneTextField.font = [UIFont fontWithName:@"Arial" size:16];
    userPhoneTextField.delegate = self;
    userPhoneTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    userPhoneTextField.layer.masksToBounds=YES;
    userPhoneTextField.layer.cornerRadius=8.0f;
    userPhoneTextField.layer.borderWidth= 1.0f;
    userPhoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:userPhoneTextField];

    checkCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 120, SCREEN_WIDTH-60, 35)];
    checkCodeTextField.secureTextEntry = NO;
    checkCodeTextField.placeholder = @"    请输入验证码";
    checkCodeTextField.font = [UIFont fontWithName:@"Arial" size:16];
    checkCodeTextField.delegate = self;
    checkCodeTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    checkCodeTextField.layer.masksToBounds=YES;
    checkCodeTextField.layer.cornerRadius=8.0f;
    checkCodeTextField.layer.borderWidth= 1.0f;
    checkCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:checkCodeTextField];
    
    userNewPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 180, SCREEN_WIDTH-60, 35)];
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
    
    getCheckCodeLabel = [[GloriaLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 60, 90, 35)];
    getCheckCodeLabel.font = FONT14;
    getCheckCodeLabel.backgroundColor = BLUE_BUTTON_COLOR;
    getCheckCodeLabel.textColor = [UIColor whiteColor];
    getCheckCodeLabel.textAlignment = NSTextAlignmentCenter;
    getCheckCodeLabel.text = @"获取验证码";
    [self.view addSubview:getCheckCodeLabel];
    
    resetUserPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetUserPwdBtn.frame = CGRectMake(30, 240, SCREEN_WIDTH-60, 40);
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
    
    resetUserPwdBtn.userInteractionEnabled = YES;
    resetUserPwdBtn.alpha = 1;
    getCheckCodeLabel.text = @"获取验证码";
}

#pragma mark custom function begin
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
                resetUserPwdBtn.userInteractionEnabled=YES;
                resetUserPwdBtn.alpha=1;
                
                //[sendBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
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
                NSLog(@"____%@",strTime);
                resetUserPwdBtn.userInteractionEnabled=NO;
                resetUserPwdBtn.alpha=0.4;
                //[sendBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
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
