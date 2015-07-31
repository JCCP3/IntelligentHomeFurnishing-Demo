//
//  IntelligentContextualAddSpaceTaskViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/2.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@interface IntelligentContextualAddSpaceTaskViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AddTaskFirstCellDelegate,UIActionSheetDelegate,AddSpaceTaskSecondCellDelegate>{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    IBOutlet UIButton *_addBtn;
    
    NSMutableArray *_aryData;
    
    UITableView *_tableView;
    
    NSMutableArray *_aryContextualModelData;
    
    NSString *_currentSelectedContextualModel;
    NSString *_CurrentSelectedContextualModelID; // 选中的情景模式ID
    
    NSString *_currentFirstDoTimeSwitchState;
    NSString *_currentFirstDoTime;
    
    NSString *_currentCombineState;
    NSString *_currentCombineTime;
    
    NSString *_currentRepeatState;
    NSString *_currentRepeatTime;
    
    NSString *_currentSelectedDateIndex;
    
    UIDatePicker *_datePicker;
    UIView *datePickerAccessoryView;
    
    NSString *_combineDay;
    NSString *_currentCombineDay;
    NSMutableDictionary *_combineDateDic;
    
    NSString *_repeateDay;
    NSString *_currentRepeatDay;
    NSMutableDictionary *_repeatDateDic;
    
    NSMutableDictionary *_firstDoDateDic;
    NSString *_currentGetFirstDoTime;
    
    BOOL _isEnableCombine; //激活结合时间
    BOOL _isEnableRepeat; //激活重复周期
}

@property (nonatomic ,strong)NSString *parentType;
@property (nonatomic ,strong)NSString *type;

@property (nonatomic ,strong)NSString *taskInfoID;
@property (nonatomic ,strong)NSString *intelligentDeviceInfoID;


- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickAdd:(id)sender;


@end
