//
//  IntelligentTaskViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "IntelligentAddTaskViewController.h"
#import "IntelligentAddSpaceTaskViewController.h"
#import "IntelligentAddWeekTaskViewController.h"
#import "IntelligentContextualAddTaskViewController.h"
#import "IntelligentContextualAddSpaceTaskViewController.h"
#import "IntelligentContextualWeekTaskViewController.h"

@interface IntelligentTaskViewController : BaseTabBarViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    
    UITableView *_tableView;
    
    NSMutableArray *_aryData;
    
    NSMutableArray *_aryTaskData;
    
    NSMutableArray *_aryContextualTaskData;
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    IBOutlet UISegmentedControl *_segment;
    
    IBOutlet UIButton *_addBtn;
    
    NSIndexPath *_currentDeleteIndexPath;
    
    NSMutableArray *_aryControlList; //集成器列表
    NSMutableArray *_aryTaskList;
    NSMutableDictionary *_taskWithControlDic; //对应任务和集中器的Dictionary
    
    NSMutableArray *_arySwitchData;
    
}

@property (nonatomic ,strong)NSIndexPath *selectIndex;

@property (nonatomic ,assign)BOOL isOpen;

//选择任务模式
- (IBAction)onClickChooseSegment:(id)sender;

- (IBAction)onClickAddContextualTask:(id)sender;


@end
