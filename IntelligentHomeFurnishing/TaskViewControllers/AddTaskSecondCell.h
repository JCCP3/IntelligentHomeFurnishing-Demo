//
//  AddTaskSecondCell.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/29.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTaskSecondCellDelegate <NSObject>

-(void)addTaskSecondCellOnClickSwitch:(NSString *)showInfo withSwitchState:(NSString *)switchState;

@end

@interface AddTaskSecondCell : UITableViewCell{
    
    IBOutlet UILabel *_showLabel;
    
    IBOutlet UISwitch *_showDetailSwitch;
    
    IBOutlet UILabel *_showDelayInfoLabel;
    
    NSString *_currentShowInfo;
    
}

@property (nonatomic ,assign)id<AddTaskSecondCellDelegate> delegate;

- (IBAction)onClickChooseSwitch:(id)sender;


-(void)loadAddTaskSecondCell:(NSString *)showInfo withSwitch:(NSString *)switchState withDelayInfo:(NSString *)delayInfo withActiveState:(BOOL)activeState;

+(CGFloat)heightForAddTaskSecondCell;

@end
