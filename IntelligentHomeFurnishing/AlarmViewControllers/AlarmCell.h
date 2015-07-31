//
//  AlarmCell.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/22.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContextualModel.h"

@protocol AlarmCellDelegate <NSObject>

-(void)alarmCellOnClickOff:(ContextualModel *)model;

-(void)alarmCellOnClickOn:(ContextualModel *)model;

@end

@interface AlarmCell : UITableViewCell{
    
    IBOutlet UILabel *_alarmLabel;
    
    IBOutlet UIButton *_offBtn;
    
    IBOutlet UIButton *_onBtn;
    
    ContextualModel *_contextualModel;
    
}

@property (nonatomic ,assign)id<AlarmCellDelegate> delegate;

-(void)loadAlarmCell:(ContextualModel *)model;

+(CGFloat)heightForAlarmCell;

- (IBAction)onClickOff:(id)sender;

- (IBAction)onClickOn:(id)sender;


@end
