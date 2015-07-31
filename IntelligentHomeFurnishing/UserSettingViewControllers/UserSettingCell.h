//
//  UserSettingCell.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/28.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserSettingCellDelegate <NSObject>

-(void)userSettingChooseSwitch:(UISwitch *)switchState;

@end

@interface UserSettingCell : UITableViewCell{
    
    IBOutlet UILabel *_leftShowLabel;
    
    IBOutlet UISwitch *_rightSwitch;
    
}

@property (strong, nonatomic) IBOutlet UILabel *leftShowLabel;

@property (strong, nonatomic) IBOutlet UISwitch *rightSwitch;

@property (nonatomic ,assign)id<UserSettingCellDelegate> delegate;

-(void)loadCurrentSwitchState;

+(CGFloat)heightForUserSettingCell;

- (IBAction)onClickChooseSwitch:(id)sender;


@end
