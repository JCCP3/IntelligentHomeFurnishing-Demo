//
//  AddSpaceTaskSecondCell.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/1.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddSpaceTaskSecondCellDelegate <NSObject>

//开始时间
-(void)addSpaceTaskSecondCellOnClickChooseSwitch:(NSString *)switchState;

//结合持续时间
-(void)addSpaceTaskSecondCellCombineOnClickChooseSwitch:(NSString *)switchState;

//重复自定义周期
-(void)addSpaceTaskSecondCellRepateOnClickChooseSwitch:(NSString *)switchState;

//打开
-(void)addWeekTaskSecondCellOpenOnClickChooseSwitch:(NSString *)switchState;


//关闭
-(void)addWeekTaskSecondCellCloseOnClickChooseSwitch:(NSString *)switchState;

@end

@interface AddSpaceTaskSecondCell : UITableViewCell{
    
    IBOutlet UILabel *_showLabel;

    
    IBOutlet UILabel *_showDetailLabel;
    
    NSString *_currentShow;
    
}

@property (strong, nonatomic) IBOutlet UISwitch *showSwitch;

@property (nonatomic ,assign)id<AddSpaceTaskSecondCellDelegate> delegate;

-(void)loadAddSpaceTaskSecondCellData:(NSString *)showLabelString withSwitchState:(NSString *)switchState withDetailInfo:(NSString *)detailInfo withActiveState:(BOOL)active;

+(CGFloat)heightForAddSpaceTaskSecondCell;

- (IBAction)onClickChooseSwitch:(id)sender;


@end
