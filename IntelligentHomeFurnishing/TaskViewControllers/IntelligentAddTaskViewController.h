//
//  IntelligentAddTaskViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/27.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "AddTaskFirstCell.h"
#import "AddTaskSecondCell.h"
#import "AddTaskThirdCell.h"
#import "RequestService.h"

/* 修改或者添加太阳时任务 */
@interface IntelligentAddTaskViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AddTaskFirstCellDelegate,UIActionSheetDelegate,AddTaskSecondCellDelegate,UIAlertViewDelegate>{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    UITableView *_tableView;
    
    NSMutableArray *_aryData;
    
    NSMutableArray *_arySwitchData;
    
    IBOutlet UIButton *_addTaskBtn;
    
    NSMutableArray *_currentSelectedSwitchNameArray;
    NSString *_currentSelectedSwitchName;
    
    NSMutableArray *_currentSelectedSwitchIndexArray;
    NSString *_currentSelectedSwitchIndex;
    
    NSString *_currentAppendingName;
    NSString *_currentAppendingIndex;
    
    
    NSString *_currentSunUpDelay;
    NSString *_currentSunDownDelay;
    
    NSString *_currentSunUpSwithState;
    NSString *_currentSunDownSwitchState;
    
    BOOL _isEnableSunUp;
    
    BOOL _isEnableSunDown;
    TaskInfo *_currentTaskInfo;
    
    
}

@property (nonatomic ,strong)NSString *taskInfoID;
@property (nonatomic ,strong)NSString *intelligentDeviceID; //集成器ID
@property (nonatomic ,strong)NSString *parentType;
@property (nonatomic ,strong)NSString *type;

- (IBAction)onClickAddTask:(id)sender;

- (IBAction)onClickBack:(id)sender;


@end
