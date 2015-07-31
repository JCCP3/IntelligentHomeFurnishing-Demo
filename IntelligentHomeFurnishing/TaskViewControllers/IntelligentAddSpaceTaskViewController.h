//
//  IntelligentAddSpaceTaskViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/1.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "AddSpaceTaskFirstCell.h"
#import "AddTaskFirstCell.h"
#import "AddSpaceTaskSecondCell.h"


@interface IntelligentAddSpaceTaskViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AddSpaceTaskFirstCellDelegate,AddTaskFirstCellDelegate,AddSpaceTaskSecondCellDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    IBOutlet UIButton *_addBtn;
    
    NSMutableArray *_aryData;
    NSMutableArray *_arySwitchData;
    NSMutableArray *_aryTaskData; //任务数组
    
    UITableView *_tableView;
    
    NSString *_currentNestState; //嵌套状态
    
    NSString *_currentSelectedTaskName;
    NSString *_currentSelectedTaskIndex;
    NSString *_currentSelectedSwitchName;//开关名称
    NSString *_currentSelectedSwitchIndex; //开关编号
    
    NSString *_currentFirstDoTimeSwitchState; //首次执行时间状态
    NSString *_currentFirstDoTime;
    NSString *_currentGetFirstDoTime;
    
    
    NSString *_currentCombineState; //结合状态
    NSString *_currentCombineTime; //结合时间
    
    NSString *_currentRepeatState; //重复状态
    NSString *_currentRepeatTime; //重复时间
    
    UIDatePicker *_datePicker;
    
    UIAlertView *alertView;
    
    UIView *datePickerAccessoryView;
    
    NSString *_currentSelectedDateIndex;
    NSString *_currentCombineDay;
    NSString *_currentRepeatDay;
    
    NSString *_combineDay;
    NSString *_repeateDay;
    NSMutableDictionary *_combineDateDic;
    NSMutableDictionary *_repeatDateDic;
    NSMutableDictionary *_firstDoDateDic;
    
    BOOL _isEnableCombine;
    BOOL _isEnableRepeat;
    
    TaskInfo *_currentTaskInfo;
}

@property (nonatomic ,strong)NSString *intelligentDeviceID; //集中器ID
@property (nonatomic ,strong)NSString *taskInfoID; //开关ID

@property (nonatomic ,strong)NSString *parentType;
@property (nonatomic ,strong)NSString *type;


- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickAdd:(id)sender;

@end
