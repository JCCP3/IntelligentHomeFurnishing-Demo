//
//  IntelligentAddWeekTaskViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/1.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "AddSpaceTaskFirstCell.h"
#import "AddTaskFirstCell.h"
#import "AddSpaceTaskSecondCell.h"

@interface IntelligentAddWeekTaskViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AddSpaceTaskFirstCellDelegate,AddTaskFirstCellDelegate,UIActionSheetDelegate,AddSpaceTaskSecondCellDelegate,UIAlertViewDelegate>{
    
    UITableView *_tableView;
    
    NSMutableArray *_aryData;
    NSMutableArray *_aryWeekdayData;
    
    NSMutableArray *_arySwitchData;
    NSMutableArray *_aryTaskData; //任务数组
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    IBOutlet UIButton *_addBtn;
    
    NSString *_currentNestState;
    
    
    NSString *_currentSelectedTaskID; //任务ID
    NSString *_currentSelectedTaskName; //当前选中的任务名称
    NSString *_currentSelectedSwitchID; //开关ID
    NSString *_currentSelectedSwitchName; //当前选中的开关名称
    
    NSString *_currentSelectedWeekDay;//当前选中的星期
    NSMutableArray *_currentSelectedWeekArray;
    
    NSString *_currentAppendingWeekID;
    NSString *_currentAppendingWeek;
    
    
    NSString *_currentSelectedDateIndex;
    
    NSString *_currentOpenState; //当前打开状态
    NSString *_currentOpenTime; //当前打开时间
    NSString *_currentClosedState; // 当前关闭状态
    NSString *_currentClosedTime; //当前关闭时间
    
    UIDatePicker *_datePicker;
    UIView *datePickerAccessoryView;
    
    NSMutableDictionary *_currentOPenDic;
    NSMutableDictionary *_currentCloseDic;
    
    BOOL _isOpenEnable; //打开
    BOOL _isCloseEnable; //关闭
    
    TaskInfo *_currentTaskInfo;
    
}

@property (nonatomic ,strong)NSString *parentType;
@property (nonatomic ,strong)NSString *type;

@property (nonatomic ,strong)NSString *taskInfoID; //修改时的任务ID
@property (nonatomic ,strong)NSString *intelligentDeviceID;//集成器ID

- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickAddd:(id)sender;

@end
