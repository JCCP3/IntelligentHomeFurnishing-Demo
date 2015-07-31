//
//  IntelligentContextualAddTaskViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/2.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@interface IntelligentContextualAddTaskViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,AddTaskFirstCellDelegate,UIActionSheetDelegate,AddTaskSecondCellDelegate>{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    IBOutlet UIButton *_addBtn;
    
    UITableView *_tableView;
    
    NSMutableArray *_aryData;
    
    NSMutableArray *_aryContextualModelData; //情景模式数组
    
    NSString *_currentSelectedContextualModel; //当前选中的情景模式
    NSString *_CurrentSelectedContextualModelID; //选中情景模式ID
    
    NSString *_currentSunUpSwithState; //日出时间状态
    
    NSString *_currentSunUpDelay; // 日出时间推迟
    
    NSString *_currentSunDownSwitchState; //日落时间状态
    
    NSString *_currentSunDownDelay;//日落时间推迟
    
    BOOL _isEnableSunUp;
    
    BOOL _isEnableSunDown;
    
    TaskInfo *_currentTaskInfo;
}

@property (nonatomic ,strong)NSString *parentType;
@property (nonatomic ,strong)NSString *type;
@property (nonatomic ,strong)NSString *taskInfoID;
@property (nonatomic ,strong)NSString *homeInfoID; //家庭模式ID


- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickAdd:(id)sender;


@end
