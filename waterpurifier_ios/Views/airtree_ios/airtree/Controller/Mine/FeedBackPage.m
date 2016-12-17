//
//  FeedBackPage.m
//  airtree
//
//  Created by WindShan on 2016/11/14.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "FeedBackPage.h"
#import "UITextView+Expand.h"

@interface FeedBackPage ()<UITextViewDelegate>
{
    UITextView * feedbackTextView;
    UIButton * commitBtn;
}
@end

@implementation FeedBackPage

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用户反馈";
    
    
    feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 120)]; //初始化大小并自动释放
    feedbackTextView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    feedbackTextView.font = [UIFont fontWithName:@"Arial"size:18.0];//设置字体名字和字体大小
    feedbackTextView.delegate = self;//设置它的委托方法
    feedbackTextView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    //feedbackTextView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    feedbackTextView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    feedbackTextView.scrollEnabled = YES;//是否可以拖动
    feedbackTextView.placeholder = @"    请输入您宝贵的意见";
    feedbackTextView.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    feedbackTextView.layer.masksToBounds= YES;
    feedbackTextView.layer.cornerRadius = 5.0f;
    feedbackTextView.layer.borderWidth = 2.0f;
    feedbackTextView.limitLength = [[NSNumber alloc] initWithInt:200]; // 限制字数
    //feedbackTextView.editable = NO;//禁止编辑
    //feedbackTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.view addSubview: feedbackTextView];//加入到整个页面中

    
//    feedbackTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 120)];
//    feedbackTextField.secureTextEntry = NO;
//    feedbackTextField.placeholder = @"    请输入您宝贵的意见";
//    feedbackTextField.font = [UIFont fontWithName:@"Arial" size:16];
//    feedbackTextField.delegate = self;
//    feedbackTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
//    feedbackTextField.layer.masksToBounds= YES;
//    feedbackTextField.layer.cornerRadius = 5.0f;
//    feedbackTextField.layer.borderWidth = 2.0f;
//    feedbackTextField.textAlignment = UITextAlignmentLeft;
//    feedbackTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [self.view addSubview:feedbackTextField];
    
    
    commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(30, 180, SCREEN_WIDTH-60, 40);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.backgroundColor = BLUE_BUTTON_COLOR;
    commitBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 5.0f;
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)commitAction
{
    if(feedbackTextView.text.length == 0)
    {
        [Global alertMessageEx:@"请输入反馈信息." title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
    }
    else
    {
        NSString *path = [NSString stringWithFormat:@"/user/%@/feedback", _loginUser[@"_id"]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:feedbackTextView.text forKey:@"feedback"];
        
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
        MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
        [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
         {
             NSString *response = [completedRequest responseAsString];
             BASE_INFO_FUN(response);
            
            [Global alertMessageEx:@"反馈信息提交成功，感谢您提出宝贵意见!" title:@"提示信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
             
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [host startRequest:request];
    }
}

#pragma mark disappear keyboard begin
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 在编辑范围是否允许输入某些text
    // 如果你的textView里面不允许用回车，可以用此方法通过按回车回收键盘
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self textViewDidEndEditing:feedbackTextView];
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
