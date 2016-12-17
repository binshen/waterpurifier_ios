//
//  ViewController.h
//  BasicProgramExample
//
//  Created by Gloria on 16/11/7.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@end

