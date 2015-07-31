//
//  UserSettingCell.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/28.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "UserSettingCell.h"

@implementation UserSettingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self = [[[NSBundle mainBundle] loadNibNamed:@"UserSettingCell" owner:self options:nil] lastObject];
    }
    
    return self;
}

-(void)loadCurrentSwitchState{
    
    
    
    [_rightSwitch setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_rightSwitch.bounds.size.width, _rightSwitch.frame.origin.y, _rightSwitch.bounds.size.width, _rightSwitch.bounds.size.height)];
    
    
    if([APPDELEGATE checkNotificationSwitchIsOpen]){
        
        if([[APPDELEGATE notificationSwitchState] isEqual:@"1"]){
            //开
            _rightSwitch.on = YES;
        }else{
            //关
            _rightSwitch.on = NO;
        }
        
    }else{
        _rightSwitch.on = YES;
    }
    
}

+(CGFloat)heightForUserSettingCell{
    return 44.f;
}

- (IBAction)onClickChooseSwitch:(id)sender {
    
    UISwitch *rightSwitch = (UISwitch *)sender;
    
    [_delegate userSettingChooseSwitch:rightSwitch];
    
}

@end
