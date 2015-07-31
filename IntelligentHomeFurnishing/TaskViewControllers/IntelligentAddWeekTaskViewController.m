//
//  IntelligentAddWeekTaskViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/1.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntelligentAddWeekTaskViewController.h"
#import "Utility.h"

@interface IntelligentAddWeekTaskViewController ()

@end

@implementation IntelligentAddWeekTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    //初始化不嵌套
    _currentNestState = @"0";
    _currentSelectedWeekArray = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [self layoutIntelligentAddWeekTaskView];
    
    
    //获取当前集成器下所有开关
    [self loadIntelligentAllSwitch];
    
    //获取当前集成器下所有任务
    [self loadAllTaskByIntelligentDeviceID];
    
   
}

-(void)loadTaskInfoData{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_taskInfoID forKey:@"taskId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:GetCurrentTaskInfo paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if([responseDic objectForKey:@"data"] && ![[responseDic objectForKey:@"data"] isEqual:@""]){
                
                NSMutableDictionary *tempDic = [responseDic objectForKey:@"data"];
                if(!_currentTaskInfo){
                    _currentTaskInfo = [[TaskInfo alloc] init];
                }
                
                [_currentTaskInfo setTaskInfoWithDataDic:tempDic];
                
                
                //周期
                if(_currentTaskInfo.taskWeek && ![_currentTaskInfo.taskWeek isEqual:@""]){
                    
                    NSString *week = _currentTaskInfo.taskWeek;
                    NSMutableArray *currentSelectedWeekIDArray = [[NSMutableArray alloc] init];
                    
                    currentSelectedWeekIDArray = [[week componentsSeparatedByString:@","] mutableCopy];
                    
                    for (int i=0; i<[currentSelectedWeekIDArray count]; i++) {
                        
                        NSString *c = [currentSelectedWeekIDArray objectAtIndex:i];
                        
                        switch ([c intValue]) {
                            case 1:
                                [_currentSelectedWeekArray addObject:@"星期一"];
                                break;
                                
                            case 2:
                                [_currentSelectedWeekArray addObject:@"星期二"];
                                break;
                                
                            case 3:
                                [_currentSelectedWeekArray addObject:@"星期三"];
                                break;
                                
                            case 4:
                                [_currentSelectedWeekArray addObject:@"星期四"];
                                break;
                                
                            case 5:
                                [_currentSelectedWeekArray addObject:@"星期五"];
                                break;
                                
                            case 6:
                                [_currentSelectedWeekArray addObject:@"星期六"];
                                break;
                                
                            case 7:
                                [_currentSelectedWeekArray addObject:@"星期天"];
                                break;
            
                            default:
                                break;
                        }
                        
                    }
                    
                }
                
                
                NSString *appendingString = @"";
                
                for (int i=0; i<[_currentSelectedWeekArray count]; i++) {
                    
                    if(i<[_currentSelectedWeekArray count]-1){
                        
                        appendingString = [appendingString stringByAppendingString:[_currentSelectedWeekArray objectAtIndex:i]];
                        
                        appendingString = [appendingString stringByAppendingString:@","];
                        
                    }else{
                        
                        appendingString =[appendingString stringByAppendingString:[_currentSelectedWeekArray objectAtIndex:i]];
                    }
                    
                }
                
                _currentAppendingWeek = appendingString;
                
                NSString *appendingWeekIDString = @"";
                for (int i=0; i<[_currentSelectedWeekArray count]; i++) {
                    
                    
                    NSString *currentWeek = @"";
                    
                    if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期一"]){
                        
                        currentWeek = @"1";
                        
                    }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期二"]){
                        currentWeek = @"2";
                        
                    }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期三"]){
                        currentWeek = @"3";
                        
                    }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期四"]){
                        currentWeek = @"4";
                        
                    }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期五"]){
                        currentWeek = @"5";
                        
                    }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期六"]){
                        currentWeek = @"6";
                        
                    }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期天"]){
                        currentWeek = @"7";
                        
                    }
                    
                    if(i<[_currentSelectedWeekArray count]-1){
                        
                        appendingWeekIDString = [appendingWeekIDString stringByAppendingString:currentWeek];
                        
                        appendingWeekIDString = [appendingWeekIDString stringByAppendingString:@","];
                        
                    }else{
                        
                        appendingWeekIDString = [appendingWeekIDString stringByAppendingString:currentWeek];
                    }
                }
                
                _currentAppendingWeekID = appendingWeekIDString;
                
                
                
                
                /* 是否嵌套 */
                if([_currentTaskInfo.taskType2 isEqual:@"2"]){
                    
                    //存在嵌套
                    
                    //子任务序号
                    _currentNestState = @"1";
                    
                    _currentSelectedTaskID = _currentTaskInfo.taskIndex; //子任务序号
                    
                }else{
                    
                    //不存在嵌套
                    _currentNestState = @"0"; //不存在嵌套
                    
                    //开关序号
                    if(_currentTaskInfo.taskSwitchIndex && ![_currentTaskInfo.taskSwitchIndex isEqual:@""] && [_arySwitchData count]>0){
                        
                        NSMutableArray *switchArray = [[NSMutableArray alloc] init];
                        
                        for (int j = 0; j<_currentTaskInfo.taskSwitchIndex.length; j++) {
                            
                            NSString *subString = [_currentTaskInfo.taskSwitchIndex substringWithRange:NSMakeRange(j, 1)];
                            
                            [switchArray addObject:subString];
                            
                        }
                        
                        
                        for (int i = [switchArray count]-1; i>=0; i--) {
                            
                            NSString *c = [switchArray objectAtIndex:i];
                            
                            if([c isEqual:@"1"]){
                                
                                SwitchInfo *currentSwitchInfo = [_arySwitchData objectAtIndex:[switchArray count]-1-i];
                                
                                
                                NSString *currentSwitchInfoString = currentSwitchInfo.switchName;
                                
                                _currentSelectedSwitchName = currentSwitchInfoString;
                                
                                _currentSelectedSwitchID = [NSString stringWithFormat:@"%d",[switchArray count]-i];
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
                
                
                //打开
                if(_currentTaskInfo.taskExecutionTs1 && ![_currentTaskInfo.taskExecutionTs1 isEqual:@""]){
                    //打开状态激活
                    
                    _isOpenEnable = YES;
                    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[_currentTaskInfo.taskExecutionTs1 longLongValue]/1000.0]; //得到的天时分秒
        
                    _currentOPenDic = [Utility changeDateToShiFenMiaoDictionay:date];
                    _currentOpenTime = [Utility changeDateToShiFen:date];
                    
                }else{
                    _isOpenEnable = NO;
                }
                
                //关闭
                if(_currentTaskInfo.taskExecutionTs2 && ![_currentTaskInfo.taskExecutionTs2 isEqual:@""]){
                    //关闭状态激活
                    
                    _isCloseEnable = YES;
                    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[_currentTaskInfo.taskExecutionTs2 longLongValue]/1000.0]; //得到的天时分秒
                    
                    _currentCloseDic = [Utility changeDateToShiFenMiaoDictionay:date];
                    _currentClosedTime = [Utility changeDateToShiFen:date];
                    
                }else{
                    _isCloseEnable = NO;
                }

                
                
                [_tableView reloadData];
            }
            
        }
        
        [self removeLoadingMessage];
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
        [self removeLoadingMessage];
    }];
    
}

-(void)layoutIntelligentAddWeekTaskView{
    
    _arySwitchData = [[NSMutableArray alloc] init];
    _aryTaskData = [[NSMutableArray alloc] init];
    
    _aryWeekdayData = [[NSMutableArray alloc] initWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天", nil];
    
    [_addBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_addBtn.bounds.size.width, _addBtn.frame.origin.y, _addBtn.bounds.size.width, _addBtn.bounds.size.height)];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT+40.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    datePickerAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
    [datePickerAccessoryView setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-46.f, 5.f, 46.f, 30.f)];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:[UIColor orangeColor]];
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(onClickCommit) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-46-46, 5.f, 46, 30.f)];
//    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
//    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn setBackgroundColor:[UIColor orangeColor]];
//    [cancelBtn addTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, DEVICE_AVALIABLE_WIDTH, 21.f)];
    showLabel.font = [UIFont systemFontOfSize:15.f];
    showLabel.textColor = [UIColor orangeColor];
    showLabel.text = @"请选择时间";
    showLabel.textAlignment = NSTextAlignmentCenter;
    
    [datePickerAccessoryView addSubview:commitBtn];
//    [datePickerAccessoryView addSubview:cancelBtn];
    [datePickerAccessoryView addSubview:showLabel];
    
    
    
    [self.view addSubview:datePickerAccessoryView];
    [self.view addSubview:_datePicker];
    [self.view bringSubviewToFront:datePickerAccessoryView];

}

// 提交
-(void)onClickCommit{
    
    //得到当前时间
    NSDate *date = [_datePicker date];
    
    if([_currentSelectedDateIndex isEqual:@"1"]){
        _currentOpenTime = [Utility changeDateToShiFen:date];
        _currentOPenDic = [Utility changeDateToShiFenDictionary:date];
    }else if ([_currentSelectedDateIndex isEqual:@"2"]){
        _currentClosedTime = [Utility changeDateToShiFen:date];
        _currentCloseDic = [Utility changeDateToShiFenDictionary:date];
    }
    
    [UIView animateWithDuration:.5 animations:^{
        
        [_datePicker setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT+40.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
        
        [datePickerAccessoryView setFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
        
        [_tableView reloadData];
    }];
   
}


//取消
-(void)onClickCancel{
    
    [UIView animateWithDuration:.5 animations:^{
        
        [_datePicker setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT+40.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
        
        [datePickerAccessoryView setFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
    }];
    
    
    if([_currentSelectedDateIndex isEqual:@"1"]){
        
        //取消则关闭
        _currentOpenState = @"0";
        [_tableView reloadData];
        
    }else if ([_currentSelectedDateIndex isEqual:@"2"]){
        //取消则关闭
        _currentClosedState = @"0";
        [_tableView reloadData];
    }
    

}

//加载所有开关
-(void)loadIntelligentAllSwitch{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:_intelligentDeviceID forKey:@"centerControllerId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:GetAllSwitchByIntelligentID paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        NSMutableArray *currentTempArray = [[NSMutableArray alloc] init];
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if([responseDic objectForKey:@"data"] && ![[responseDic objectForKey:@"data"] isEqual:@""] && ![[responseDic objectForKey:@"data"] isKindOfClass:[NSNull class]] && [[responseDic objectForKey:@"data"] count]>0){
                
                NSMutableArray *tempArray = [responseDic objectForKey:@"data"];
                
                for(int i=0 ;i<[tempArray count];i++){
                    
                    NSMutableDictionary *tempDic = [tempArray objectAtIndex:i];
                    
                    SwitchInfo *switchInfo = [[SwitchInfo alloc] init];
                    [switchInfo setSwitchInfoWithDataDic:tempDic];
                    
                    [currentTempArray addObject:switchInfo];
                    
                    
                }
                
                _arySwitchData = currentTempArray;
                
                //得到所有开关
                if(_taskInfoID && ![_taskInfoID isEqual:@""]){
                    
                    //加载得到任务详情
                    [self loadTaskInfoData];
                }
                
            }
            
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
    
}


-(void)loadAllTaskByIntelligentDeviceID{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:_intelligentDeviceID forKey:@"centerControllerId"];
    [[RequestService defaultRequestService] asyncGetDataWithURL:IntegratedDevicesAllTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        NSMutableArray *currentTempArray = [[NSMutableArray alloc] init];
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if([responseDic objectForKey:@"taskList"] && ![[responseDic objectForKey:@"taskList"] isEqual:@""]&& ![[responseDic objectForKey:@"taskList"] isKindOfClass:[NSNull class]] && [[responseDic objectForKey:@"taskList"] count]>0){
                
                NSMutableArray *tempArray = [responseDic objectForKey:@"taskList"];
                
                for (int i=0; i<[tempArray count]; i++) {
                    
                    NSMutableDictionary *tempDic = [tempArray objectAtIndex:i];
                    
                    TaskInfo *taskInfo = [[TaskInfo alloc] init];
                    [taskInfo setTaskInfoWithDataDic:tempDic];
                    
                    [currentTempArray addObject:taskInfo];
                }
                
                _aryTaskData = currentTempArray;
                
                
            }else{
                
                [self showSuccessOrFailedMessage:@"暂无任务"];
                
            }
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        
        //嵌套
        static NSString *cellIdentifier = @"AddSpaceTaskFirstCell";
        
        AddSpaceTaskFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            
            cell = [[AddSpaceTaskFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddSpaceTaskFirstCell:_currentNestState];
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        //选择开关或者任务
        static NSString *cellIdentifier = @"AddTaskFirstCell";
        
        AddTaskFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            
            cell = [[AddTaskFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        if([_currentNestState isEqual:@"1"]){
            
            //选择嵌套
            [cell loadAddTaskFirstCell:_currentSelectedTaskName withShowLabel:@"选择任务"];
        }else{
            
            //不选择嵌套
            [cell loadAddTaskFirstCell:_currentSelectedSwitchName withShowLabel:@"选择开关"];
        }
        
        return cell;

        
    }else if (indexPath.row == 2){
        
        //选择星期
        static NSString *cellIdentifier = @"AddTaskFirstCell";
        
        AddTaskFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            
            cell = [[AddTaskFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddTaskFirstCell:_currentAppendingWeek withShowLabel:@"选择星期"];
        
        return cell;

    }else if (indexPath.row == 3){
        
        //选择时间 时 分
        static NSString *cellIndentifier = @"AddSpaceTaskSecondCell";
        
        AddSpaceTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if(cell == nil){
            
            cell = [[AddSpaceTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        cell.showSwitch.hidden = YES;
        
        [cell loadAddSpaceTaskSecondCellData:@"打开" withSwitchState:_currentOpenState withDetailInfo:_currentOpenTime withActiveState:_isOpenEnable];
        
        return cell;

    }else if (indexPath.row == 4){
        
        static NSString *cellIndentifier = @"AddSpaceTaskSecondCell";
        
        AddSpaceTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if(cell == nil){
            
            cell = [[AddSpaceTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        cell.showSwitch.hidden = YES;
        
        [cell loadAddSpaceTaskSecondCellData:@"关闭" withSwitchState:_currentClosedState withDetailInfo:_currentClosedTime withActiveState:_isCloseEnable];
        
        return cell;

    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 3 || indexPath.row == 4){
        return 60.f;
    }else{
        return 44.f;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 3){
        
        //打开是否激活
        if(!_isOpenEnable){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否激活打开时间" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10086;
            [alertView show];
            
        }else{
            
            _currentSelectedDateIndex = @"1";
            
            [UIView animateWithDuration:.5 animations:^{
                
                [_datePicker setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT-216.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
                
                [datePickerAccessoryView setFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
                
                [_tableView reloadData];
                
            }];
            
        }
        
    }else if (indexPath.row == 4){
        
        if(!_isCloseEnable){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否激活关闭时间" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10010;
            [alertView show];
            
        }else{
            
            _currentSelectedDateIndex = @"2";
            
            [UIView animateWithDuration:.5 animations:^{
                
                [_datePicker setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT-216.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
                
                [datePickerAccessoryView setFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
                
                [_tableView reloadData];
                
            }];
            
        }
        
        
    }
    
}


#pragma mark AddSpaceTaskFirstCellDelegate
-(void)addSpaceTaskFirstCellOnClickChooseSwitch:(NSString *)switchState{
    
    _currentNestState = switchState;
    
    [_tableView reloadData];
    
}

#pragma mark AddTaskFirstCellDelegate
-(void)addTaskFirstCellOnClickChoose:(NSString *)chooseType{
    
    //选择开关
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.tag = 2000;
    for (int i=0; i<[_arySwitchData count]; i++) {
        
        SwitchInfo *switchInfo = [_arySwitchData objectAtIndex:i];
        
        [actionSheet addButtonWithTitle:switchInfo.switchName];
    }
    
    [actionSheet showInView:self.view];
    
}

-(void)addTaskFirstCellOnClickChooseTask:(NSString *)chooseType{
    
    if([chooseType isEqual:@"选择任务"]){
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = 3000;
        for (int i=0; i<[_aryTaskData count]; i++) {
            
            TaskInfo *taskInfo = [_aryTaskData objectAtIndex:i];
            
            [actionSheet addButtonWithTitle:[Utility getTaskInfoNameByTaskInfo:taskInfo]];
            
            taskInfo.taskInfoName = [Utility getTaskInfoNameByTaskInfo:taskInfo];
        }
        
        [actionSheet showInView:self.view];
        
        
    }else if([chooseType isEqual:@"选择星期"]){
        
        //选择星期
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = 4000;
        for (int i=0; i<[_aryWeekdayData count]; i++) {
            
            [actionSheet addButtonWithTitle:[_aryWeekdayData objectAtIndex:i]];
        }
        
        [actionSheet showInView:self.view];
    }
    
}


#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == 2000){
        
        if(buttonIndex != 0){
            
            SwitchInfo *switchInfo = [_arySwitchData objectAtIndex:buttonIndex-1];
            
            _currentSelectedSwitchName = switchInfo.switchName;
            _currentSelectedSwitchID = switchInfo.switchIndex;
            [_tableView reloadData];
            
        }else{
            
            //点击取消
            
        }
        
        
    }else if (actionSheet.tag == 3000){
        
        if(buttonIndex != 0){
            
            TaskInfo *taskInfo = [_aryTaskData objectAtIndex:buttonIndex-1];
            
            _currentSelectedTaskName = taskInfo.taskInfoName;
            _currentSelectedTaskID = taskInfo.taskIndex;
            [_tableView reloadData];
            
        }else{
            
            
        }
        
    }else if(actionSheet.tag == 4000){
        
        //星期
        if(buttonIndex != 0 ){
            
            _currentSelectedWeekDay = [_aryWeekdayData objectAtIndex:buttonIndex-1];
            
            if(![_currentSelectedWeekArray containsObject:_currentSelectedWeekDay]){
                
                [_currentSelectedWeekArray addObject:_currentSelectedWeekDay];
                
            }else{
                
                [_currentSelectedWeekArray removeObject:_currentSelectedWeekDay];
            }
            
            NSString *appendingString = @"";
            
            for (int i=0; i<[_currentSelectedWeekArray count]; i++) {
                
                if(i<[_currentSelectedWeekArray count]-1){
                    
                    appendingString = [appendingString stringByAppendingString:[_currentSelectedWeekArray objectAtIndex:i]];
                    
                    appendingString = [appendingString stringByAppendingString:@","];
                    
                }else{
                    
                    appendingString =[appendingString stringByAppendingString:[_currentSelectedWeekArray objectAtIndex:i]];
                }
                
            }
            
            _currentAppendingWeek = appendingString;
            
            NSString *appendingWeekIDString = @"";
            for (int i=0; i<[_currentSelectedWeekArray count]; i++) {
                
                
                NSString *currentWeek = @"";
                
                if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期一"]){
                    
                    currentWeek = @"1";
                    
                }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期二"]){
                    currentWeek = @"2";
                    
                }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期三"]){
                    currentWeek = @"3";
                    
                }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期四"]){
                    currentWeek = @"4";
                    
                }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期五"]){
                    currentWeek = @"5";
                    
                }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期六"]){
                    currentWeek = @"6";
                    
                }else if([[_currentSelectedWeekArray objectAtIndex:i] isEqual:@"星期天"]){
                    currentWeek = @"7";
                    
                }
                
                if(i<[_currentSelectedWeekArray count]-1){
                    
                    appendingWeekIDString = [appendingWeekIDString stringByAppendingString:currentWeek];
                    
                    appendingWeekIDString = [appendingWeekIDString stringByAppendingString:@","];
                    
                }else{
                    
                    appendingWeekIDString = [appendingWeekIDString stringByAppendingString:currentWeek];
                }
            }
            
            _currentAppendingWeekID = appendingWeekIDString;
            
            [_tableView reloadData];
            
        }
        
    }
    

}


- (IBAction)onClickBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickAddd:(id)sender {
    
    int errorNum = 0;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if(_taskInfoID && ![_taskInfoID isEqual:@""]){
        [paramDic setObject:_taskInfoID forKey:@"id"];
    }else{
        [paramDic setObject:@"-1" forKey:@"id"];
    }
    
    if(_intelligentDeviceID && ![_intelligentDeviceID isEqual:@""]){
        [paramDic setObject:_intelligentDeviceID forKey:@"centerControllerId"];
        
    }
    
    
    /* 是否嵌套 */
    if([_currentNestState isEqual:@"1"]){
        
        if(_currentSelectedTaskID && ![_currentSelectedTaskID isEqual:@""]){
            //嵌套
            [paramDic setObject:_currentSelectedTaskID forKey:@"switchIndex"];
            [paramDic setObject:@"2" forKey:@"type2"];
            [paramDic setObject:_currentSelectedTaskID forKey:@"childTaskId"];//嵌套任务的子任务编号
        }else{
            
            if(errorNum == 0){
                [self showSuccessOrFailedMessage:@"请选择子任务"];
            }
            errorNum++;
        }
        
        
    }else{
        
        if(_currentSelectedSwitchID && ![_currentSelectedSwitchID isEqual:@""]){
            
            //没嵌套
            [paramDic setObject:_currentSelectedSwitchID forKey:@"switchIndex"];
            [paramDic setObject:@"0" forKey:@"type2"];
            
            
        }else{
            if(errorNum == 0){
                [self showSuccessOrFailedMessage:@"请选择开关"];
            }
            errorNum++;
        }
        
        
    }
    
    [paramDic setObject:@"1" forKey:@"type"];
    
    if(_currentAppendingWeekID && ![_currentAppendingWeekID isEqual:@""]){
        
        [paramDic setObject:_currentAppendingWeekID forKey:@"week"];
        
    }else{
        
        if(errorNum == 0){
            [self showSuccessOrFailedMessage:@"请选择星期"];
        }
        
        errorNum ++;
    }
    
    
    if(_isOpenEnable){
        //打开操作激活
        
        if(_currentOPenDic && ![_currentOPenDic isEqual:@""]){
            
            [paramDic setObject:@"1" forKey:@"action1"];
            [paramDic setObject:[Utility changeTianShiFenMiaoToHaoMiao:@"0" withShi:[_currentOPenDic objectForKey:@"hour"] withFen:[_currentOPenDic objectForKey:@"min"] withMiao:@"0"] forKey:@"executionTs1"]; //打开的执行时间 毫秒
            
        }else{
            
            if(errorNum == 0){
                [self showSuccessOrFailedMessage:@"请选择时间"];
            }
            errorNum++;
        }
        
        
    }else{
        [paramDic setObject:@"0" forKey:@"action1"];
    }
    
    if(_isCloseEnable){
        //关闭操作激活
        
        if(_currentCloseDic && ![_currentCloseDic isEqual:@""]){
            
            [paramDic setObject:@"1" forKey:@"action2"];
            [paramDic setObject:[Utility changeTianShiFenMiaoToHaoMiao:@"0" withShi:[_currentCloseDic objectForKey:@"hour"] withFen:[_currentCloseDic objectForKey:@"min"] withMiao:@"0"]  forKey:@"executionTs2"]; //关闭的执行时间 毫秒
            
        }else{
            
            if(errorNum == 0){
                [self showSuccessOrFailedMessage:@"请选择时间"];
            }
            errorNum++;
        }
        
        
    }else{
        [paramDic setObject:@"0" forKey:@"action2"];
    }
    
    
    
    if([_currentOpenTime isEqual:@""] && [_currentClosedTime isEqual:@""]){
        
        if(errorNum == 0){
            
            //两个都为空
            [self showSuccessOrFailedMessage:@"请至少选择一项操作"];
            
            errorNum ++;
        }
        
    }else{
        
    }
    
    if(errorNum == 0){
        
        [[RequestService defaultRequestService] asyncGetDataWithURL:SaveIntelligentWeekTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
            
            if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                [self showSuccessOrFailedMessage:@"添加周任务成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        } errorBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
    }
    
    
    
}

#pragma mark AddSpaceTaskSecondCellDelegate
-(void)addWeekTaskSecondCellOpenOnClickChooseSwitch:(NSString *)switchState{
    
    /* 打开的switch 开关 */
    _currentOpenState = switchState; //当前开关的打开状态
    
    [_tableView reloadData];
}

-(void)addWeekTaskSecondCellCloseOnClickChooseSwitch:(NSString *)switchState{
    
    
    _currentClosedState = switchState;
    
    [_tableView reloadData];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10086){
        
        //打开
        if(buttonIndex == 0){
            
            _isOpenEnable = NO;
            
        }else{
            
            _isOpenEnable = YES;
            //激活打开时间 默认0天
          
            _currentOPenDic = [@{@"0":@"hour",@"0":@"min",@"0":@"sec"} mutableCopy];
            
        }
        
        [_tableView reloadData];
        
    }else if (alertView.tag == 10010){
        
        //关闭
        
        if(buttonIndex == 0){
            
            _isCloseEnable = NO;
            
        }else{
            
            _isCloseEnable = YES;
            
            //激活关闭时间 默认0天
            _currentCloseDic = [@{@"0":@"hour",@"0":@"min",@"0":@"sec"} mutableCopy];
        }
        
        [_tableView reloadData];
        
    }else{
        if(buttonIndex == 0){
            // 取消
            
        }else{
            // 确定
            
            [_tableView reloadData];
        }
        
    }
    
}

@end
