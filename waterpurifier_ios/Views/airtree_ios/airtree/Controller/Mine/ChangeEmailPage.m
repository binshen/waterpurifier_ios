//
//  ChangeEmailPage.m
//  airtree
//
//  Created by WindShan on 2016/11/11.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "ChangeEmailPage.h"
#import "GloriaLabel.h"

@interface ChangeEmailPage ()
{
    UITextField * userNickNameTextField;
    
    UIButton * resetUserNameBtn;

    
}
@end

@implementation ChangeEmailPage


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改邮箱";

    userNickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 35)];
    userNickNameTextField.secureTextEntry = NO;
    userNickNameTextField.placeholder = @"    请输入新的邮箱";
    userNickNameTextField.font = [UIFont fontWithName:@"Arial" size:16];
    userNickNameTextField.delegate = self;
    userNickNameTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    userNickNameTextField.layer.masksToBounds=YES;
    userNickNameTextField.layer.cornerRadius=5.0f;
    userNickNameTextField.layer.borderWidth= 1.0f;
    userNickNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:userNickNameTextField];

    
    resetUserNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetUserNameBtn.frame = CGRectMake(30,90, SCREEN_WIDTH-60, 40);
    [resetUserNameBtn setTitle:@"提交修改" forState:UIControlStateNormal];
    resetUserNameBtn.backgroundColor = BLUE_BUTTON_COLOR;
    resetUserNameBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [resetUserNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetUserNameBtn.layer.masksToBounds=YES;
    resetUserNameBtn.layer.cornerRadius=5.0f;
    [resetUserNameBtn addTarget:self action:@selector(resetUserNameAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetUserNameBtn];
    
    if (_loginUser[@"email"] != nil) {
        [userNickNameTextField setText:_loginUser[@"email"]];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    resetUserNameBtn.userInteractionEnabled = YES;
    resetUserNameBtn.alpha = 1;
}

#pragma mark custom function begin
////倒计时提醒
# pragma mark custom function end


#pragma mark button event begin
-(void)resetUserNameAction
{
    // 重置昵称操作
    if(userNickNameTextField.text.length == 0)
    {
        [Global alertMessageEx:@"请输入邮箱." title:@"错误信息" okTtitle:nil cancelTitle:@"OK"  delegate:self];
    }
    else if(userNickNameTextField.text.length > 0 && [StringUtil isValidateEmail:userNickNameTextField.text] == NO)
    {
        // 检测手机号是否合法
        [Global alertMessageEx:@"邮箱不合法，请重新输入！" title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
    }
    else
    {
        NSString *path = [NSString stringWithFormat:@"/user/%@/update_email", _loginUser[@"_id"]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userNickNameTextField.text forKey:@"email"];
        
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
        MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
        [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
        {
//            NSString *response = [completedRequest responseAsString];
//            BASE_INFO_FUN(response);
            
            NSError *error = [completedRequest error];
            NSData *data = [completedRequest responseData];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *success = [json objectForKey:@"success"];
            if(success != nil && [success boolValue])
            {
                
                [_loginUser setObject:userNickNameTextField.text forKey:@"email"];
                [UserDefault setObject:userNickNameTextField.text forKey:@"email"];
                [UserDefault synchronize];
                
                [Global alertMessageEx:@"邮箱修改成功!" title:@"提示信息" okTtitle:nil cancelTitle:@"OK"  delegate:self];
                // 最外层控制器出栈
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
    [self textFieldShouldReturn:userNickNameTextField];
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
