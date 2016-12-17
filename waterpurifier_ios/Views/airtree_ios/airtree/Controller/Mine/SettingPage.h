//
//  SettingPage.h
//  airtree
//
//  Created by WindShan on 2016/11/14.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "BaseNavPage.h"

@interface SettingPage : BaseNavPage<UITableViewDelegate,UITableViewDataSource>
{
    
}

@property(nonatomic,strong) UITableView * userInfoTableView;

@end
