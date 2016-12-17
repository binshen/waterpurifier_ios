//
//  SettingPage.m
//  airtree
//
//  Created by WindShan on 2016/11/14.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "SettingPage.h"
#import "ChangeNamePage.h"
#import "ChangePwdPage.h"
#import "FeedBackPage.h"
#import "ChangeEmailPage.h"

@interface SettingPage ()
{

    NSTimer * autoRefreshTime;
    NSNumber * avg_number;
}
@end

@implementation SettingPage

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self autoRefreshData];
    autoRefreshTime = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(autoRefreshData) userInfo:nil repeats:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人设置";
    [self setNavigationLeft:@"返回" sel:@selector(backAction)];
    
    
    self.userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60) style:UITableViewStyleGrouped];
    self.userInfoTableView.delegate = self;
    self.userInfoTableView.dataSource = self;
    self.userInfoTableView.backgroundColor = [UIColor clearColor];
    self.userInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.userInfoTableView.scrollsToTop = YES;
    //self.userInfoTableView.scrollEnabled = YES;
    [self.view addSubview:self.userInfoTableView];

}

-(void) backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    if(autoRefreshTime != nil)
        [autoRefreshTime invalidate];
    
    [self.userInfoTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

//此处上面和下面 是设置 footerview
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    UIButton *quitLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitLoginBtn.frame =CGRectMake(30, 50, SCREEN_WIDTH-60, 40);
    [quitLoginBtn.layer setMasksToBounds:YES];
    [quitLoginBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    quitLoginBtn.backgroundColor = BLUE_BUTTON_COLOR;/////色值自己改一下
    [quitLoginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    quitLoginBtn.userInteractionEnabled = YES;
    [quitLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitLoginBtn addTarget:self action:@selector(exitLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:quitLoginBtn];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger index = [indexPath row];
    
    switch (index)
    {
        case 0:
        {
            NSString *nickname = _loginUser[@"nickname"] == nil ? _loginUser[@"username"] : _loginUser[@"nickname"];
            
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text = nickname;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
            cell.textLabel.text = @"修改密码";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            cell.textLabel.text = @"家庭综合指数";
            cell.detailTextLabel.text = avg_number.stringValue;
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 4:
            cell.textLabel.text = @"用户反馈";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 3:
        {
            NSString *userEmail = _loginUser[@"email"] == nil ? _loginUser[@"email"] : _loginUser[@"email"];
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = userEmail;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 5:
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath row] == 5) {
        return 0;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = [indexPath row];
    // 页面跳转
    if(index == 0)
    {
        // 跳转昵称修改界面
        ChangeNamePage * page = [[ChangeNamePage alloc] initIsFirstPage:NO];
        [self.navigationController pushViewController:page animated:YES];
    }
    else if(index == 1)
    {
        // 跳转修改密码界面
        ChangePwdPage * page = [[ChangePwdPage alloc] initIsFirstPage:NO];
        [self.navigationController pushViewController:page animated:YES];
    }
    else if(index == 3)
    {
        // 跳转修改邮箱界面
        ChangeEmailPage * page = [[ChangeEmailPage alloc] initIsFirstPage:NO];
        [self.navigationController pushViewController:page animated:YES];
    }
    else if(index == 4)
    {
        // 跳转用户反馈界面
        FeedBackPage * page = [[FeedBackPage alloc] initIsFirstPage:NO];
        [self.navigationController pushViewController:page animated:YES];
    } else {
        //TODO
    }
}

#pragma mark - custom function begin
-(void)exitLoginAction
{
    NSString *path = [NSString stringWithFormat:@"/user/%@/offline", _loginUser[@"_id"]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSString *response = [completedRequest responseAsString];
        NSLog(@"SegueToLogout: %@", response);
        [GetAppDelegate showLoginPage];
    }];
    [host startRequest:request];
    
    [UserDefault setObject:@"0" forKey:@"isLogin"];
    [UserDefault setObject:nil forKey:@"user_id"];
    
    _loginUser = nil;
}

- (void) autoRefreshData
{
    NSString *path = [NSString stringWithFormat:@"/user/%@/get_avg_data", _loginUser[@"_id"]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"GET"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        if (data != nil)
        {
            NSDictionary *avgData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            avg_number = [avgData valueForKey:@"avg"];
            [self.userInfoTableView reloadData];
        }
    }];
    [host startRequest:request];
}

#pragma mark - custom function end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
