//
//  ViewController.m
//  BasicProgramExample
//
//  Created by Gloria on 16/11/7.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "CSNetAccessor.h"
#import "HTool.h"
#import "ResultInfo.h"
#import "JSONAutoSerializer.h"
#import "AdInfo.h"
#import "CommonTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()
{
    NSMutableArray *recommentArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Welcome";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    recommentArray = [[NSMutableArray alloc] init];
    [self getAds];
    
}

-(void)getAds
{

    NSString *url = @"GetBillInfoList?";
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在加载";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ResultInfo *resultInfo = (ResultInfo *)[CSNetAccessor getNetData:url PostUrl:[NSString stringWithFormat:@"place=%d&skip=%d&take=%d",2,0,15]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD.hidden = YES;
            
            if (resultInfo.state == 1) {
                NSMutableArray *objArray = (NSMutableArray *)resultInfo.obj;
                
                for (int i = 0; i < [objArray count]; i++) {
                    AdInfo *info = [[JSONAutoSerializer sharedSerializer] deserializeObject:[objArray objectAtIndex:i] withClass:@"AdInfo"];
                    [recommentArray addObject:info];
                }
            }
            
            [_tableView reloadData];
            
        });
    });
    
}

#pragma mark - UITableViewDelegate&UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [recommentArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  220;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *identifier = @"homeImage";
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[CommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([recommentArray count] > indexPath.section) {
        
        AdInfo *info = [recommentArray objectAtIndex:indexPath.section];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.homeImageView sd_setImageWithURL:[NSURL URLWithString:info.url] placeholderImage:nil];
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
