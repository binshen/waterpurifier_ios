//
// Created by Bin Shen on 18/12/2016.
// Copyright (c) 2016 Bin Shen. All rights reserved.
//

#import "RegisterPage.h"
#import "GloriaLabel.h"

@interface RegisterPage() {

    UITextField * userPhoneTextField;
    UITextField * userCodeTextField;
    UITextField * userNameTextField;
    UITextField * userPasswordTextField;

    GloriaLabel * getCheckCodeLabel;
    UIButton * resetUserPwdBtn;
    UIButton *sendBtn;
    dispatch_source_t _timer;
}
@end

@implementation RegisterPage

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"注册";
    [self setNavigationLeft:@"返回" sel:@selector(backAction)];

    userPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 25, SCREEN_WIDTH-40, 35)];
    userPhoneTextField.secureTextEntry = NO;
    userPhoneTextField.placeholder = @"请输入手机号";
    userPhoneTextField.font = [UIFont fontWithName:@"Arial" size:16];
    userPhoneTextField.delegate = self;
    userPhoneTextField.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
    userPhoneTextField.layer.masksToBounds = YES;
    //userPhoneTextField.layer.cornerRadius = 8.0f;
    userPhoneTextField.layer.borderWidth = 1.0f;
    userPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    userPhoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userPhoneTextField.backgroundColor = [UIColor whiteColor];

    CGRect frame = userPhoneTextField.frame;
    frame.size.width = 5;
    userPhoneTextField.leftViewMode = UITextFieldViewModeAlways;
    userPhoneTextField.leftView = [[UIView alloc] initWithFrame:frame];

    [self.view addSubview:userPhoneTextField];
}

@end