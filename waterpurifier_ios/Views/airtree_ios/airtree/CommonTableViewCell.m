//
//  CommonTableViewCell.m
//  FindJob
//
//  Created by Gloria on 16/8/3.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "CommonTableViewCell.h"

@implementation CommonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _identifierString = reuseIdentifier;
        
        if ([reuseIdentifier isEqualToString:@"homeImage"]) {
            _homeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 200)];
            [self addSubview:_homeImageView];
        }
    }
    return self;
}

@end
