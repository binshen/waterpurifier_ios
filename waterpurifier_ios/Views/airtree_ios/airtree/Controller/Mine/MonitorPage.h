//
//  MonitorPage.h
//  airtree
//
//  Created by WindShan on 2016/11/17.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "BaseNavPage.h"

@interface MonitorPage : BaseNavPage

@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,assign) NSDictionary *pageDevice;

-(void) setAirTimeLabelText:(NSString*)text;
-(void) setAirTitleLabelText:(NSString*)text;
-(void) setAirTagLabelText:(NSString*)text;
-(void) setAirStatusLabelText:(NSString*)text;
-(void) setAirDetailImageName:(NSString*)name;
-(void) setAirStatusImageName:(NSString*)name;
@end
