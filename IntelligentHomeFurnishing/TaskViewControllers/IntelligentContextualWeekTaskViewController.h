//
//  IntelligentContextualWeekTaskViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/2.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@interface IntelligentContextualWeekTaskViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AddTaskFirstCellDelegate,UIActionSheetDelegate,AddSpaceTaskSecondCellDelegate>{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    IBOutlet UIButton *_addBtn;
    
    UITableView *_tableView;
    NSMutableArray *_aryData;
    NSMutableArray *_aryContextualData;
    NSMutableArray *_aryWeekdayData;
    NSMutableArray *_aryWeekIDData;
    
    UIDatePicker *_datePicker;
    UIView *datePickerAccessoryView;
    
    NSString *_currentSelectedDateIndex;
    
    
    NSString *_currentOpenState;
    NSString *_currentOpenTime;
    
    
    NSString *_currentClosedState;
    NSString *_currentClosedTime;
    
    NSString *_currentSelectedWeekDay;
    NSMutableArray *_currentSelectedWeekArray;
    
    NSString *_currentAppendingWeekID;
    NSString *_currentAppendingWeek;
    
    NSString *_currentSelectedContextualID;
    NSString *_currentSelectedContextual;
    
    NSMutableArray *_aryContextualModelData;
    NSMutableDictionary *_currentOPenDic;
    NSMutableDictionary *_currentCloseDic;

    
}

@property (nonatomic ,strong)NSString *parentType;
@property (nonatomic ,strong)NSString *type;

@property (nonatomic ,strong)NSString *taskInfoID;


- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickAdd:(id)sender;

@end
