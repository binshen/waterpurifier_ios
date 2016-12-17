//
//  MonitorView.h
//  airtree
//
//  Created by WindShan on 2016/11/17.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitorView : UIView


-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;


-(void) setAirTimeLabelText:(NSString*)text;
-(void) setAirTitleLabelText:(NSString*)text;
-(void) setAirTagLabelText:(NSString*)text;
-(void) setAirStatusLabelText:(NSString*)text;
-(void) setAirScoreLabelText:(NSString*)text;
-(void) setAirDetailImageName:(NSString*)name;
-(void) setAirStatusImageName:(NSString*)name;
@end
