//
//  IntelligentAddSpaceTaskViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/1.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntelligentAddSpaceTaskViewController.h"
#import "Utility.h"

@interface IntelligentAddSpaceTaskViewController ()

@end

@implementation IntelligentAddSpaceTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    //适配
    [self layoutIntelligentAddSpaceTask];
    
    //默认执行时间关闭
    _currentFirstDoTimeSwitchState = @"0";
    _currentCombineState = @"0";
    _currentRepeatState = @"0";
    _currentNestState = @"0"; //默认不嵌套
    
    //获取当前集成器下所有开关
    [self loadIntelligentAllSwitch];
    
    //获取当前集成器下所有任务
    [self loadAllTaskByIntelligentDeviceID];
    
}

//加载任务信息
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
                
                if([_currentTaskInfo.taskType2 isEqual:@"2"]){
                    
                    //存在嵌套
                    
                    //子任务序号
                    _currentNestState = @"1";
                    
                    _currentSelectedTaskIndex = _currentTaskInfo.taskIndex; //子任务序号
                    
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
                                
                                _currentSelectedSwitchIndex = [NSString stringWithFormat:@"%d",[switchArray count]-i];
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
                
                //首次执行时间
                _currentFirstDoTimeSwitchState = @"1"; //首次执行时间状态值
                NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[_currentTaskInfo.taskExecutionTs1 longLongValue]/1000.0];
                _currentFirstDoTime = [Utility changeDateToString:date];
                _currentGetFirstDoTime = [Utility getNianYueRiInfoFromDate:date];
                _firstDoDateDic = [Utility changeDateToShiFenMiaoDictionay:date];
                
                //结合时间
                if(_currentTaskInfo.taskExecutionTs2 && ![_currentTaskInfo.taskExecutionTs2 isEqual:@""]){
                    //结合状态激活
                    _isEnableCombine = YES;
                    
                    //结合开关状态
                    if([_currentTaskInfo.taskAction2 isEqual:@"1"]){
                        _currentCombineState = @"1";
                    }else if ([_currentTaskInfo.taskAction2 isEqual:@"0"]){
                        _currentCombineState = @"0";
                    }
                    
                    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[_currentTaskInfo.taskExecutionTs2 longLongValue]/1000.0]; //得到的是天时分秒
                    _combineDay = [Utility changeDateToDay:date];
                    _currentCombineDay = [NSString stringWithFormat:@"%@天",_combineDay];
                    _currentCombineTime = [Utility changeDateToShiFenMiao:date];
                    _combineDateDic = [Utility changeDateToShiFenMiaoDictionay:date];
                }else{
                    _isEnableCombine = NO;
                }
                
                //循环时间
                if(_currentTaskInfo.taskPeriod && ![_currentTaskInfo.taskPeriod isEqual:@""]){
                    //循环状态激活
                    if([_currentTaskInfo.taskAction2 isEqual:@"1"]){
                        _currentRepeatState = @"1";
                    }else if ([_currentTaskInfo.taskAction2 isEqual:@"0"]){
                        _currentRepeatState = @"0";
                    }
                    _isEnableRepeat = YES;
                    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[_currentTaskInfo.taskPeriod longLongValue]/1000.0]; //得到的天时分秒
                    _repeateDay = [Utility changeDateToDay:date];
                    _currentRepeatDay = [NSString stringWithFormat:@"%d天",_repeateDay];
                    _currentRepeatTime = [Utility changeDateToShiFenMiao:date];
                    _repeatDateDic = [Utility changeDateToShiFenMiaoDictionay:date];
                    
                }else{
                    _isEnableRepeat = NO;
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

-(void)layoutIntelligentAddSpaceTask{
    
    
    _aryData = [[NSMutableArray alloc] init];
    _arySwitchData = [[NSMutableArray alloc] init];
    _aryTaskData = [[NSMutableArray alloc] init];
    
    [_addBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_addBtn.bounds.size.width, _addBtn.frame.origin.y, _addBtn.bounds.size.width, _addBtn.bounds.size.height)];
    
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT+40.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
    datePickerAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
    [datePickerAccessoryView setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-46.f, 5.f, 46.f, 30.f)];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:[UIColor orangeColor]];
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(onClickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-46-46, 5.f, 46, 30.f)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor orangeColor]];
    [cancelBtn addTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
    
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
        
        /* 首次执行时间 */
        _currentFirstDoTime = [Utility changeDateToString:date];
        _currentGetFirstDoTime = [Utility getNianYueRiInfoFromDate:date];
        _firstDoDateDic = [Utility changeDateToShiFenMiaoDictionay:date];
    }else if ([_currentSelectedDateIndex isEqual:@"2"]){
        _currentCombineTime = [Utility changeDateToShiFenMiao:date];
        _combineDateDic = [Utility changeDateToShiFenMiaoDictionay:date];
    }else if ([_currentSelectedDateIndex isEqual:@"3"]){
        _currentRepeatTime = [Utility changeDateToShiFenMiao:date];
        _repeatDateDic = [Utility changeDateToShiFenMiaoDictionay:date];
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
    
}

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
                
                /* 加载完所有开关 */
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
        
    }else if(indexPath.row == 2){
        
        //对应的时间点
        static NSString *cellIndentifier = @"AddSpaceTaskSecondCell";
        
        AddSpaceTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if(cell == nil){
            
            cell = [[AddSpaceTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddSpaceTaskSecondCellData:@"首次执行时间" withSwitchState:_currentFirstDoTimeSwitchState withDetailInfo:_currentFirstDoTime withActiveState:nil];
        
        return cell;
        
    }else if (indexPath.row == 3){
        
        // 结合
        static NSString *cellIndentifier = @"AddSpaceTaskSecondCell";
        
        AddSpaceTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if(cell == nil){
            
            cell = [[AddSpaceTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddSpaceTaskSecondCellData:@"持续时间" withSwitchState:_currentCombineState withDetailInfo:[_currentCombineDay stringByAppendingString:_currentCombineTime] withActiveState:_isEnableCombine];
        
        return cell;
        
        
    }else if (indexPath.row == 4){
        
        //重复
        static NSString *cellIndentifier = @"AddSpaceTaskSecondCell";
        
        AddSpaceTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if(cell == nil){
            
            cell = [[AddSpaceTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddSpaceTaskSecondCellData:@"自定义周期" withSwitchState:_currentRepeatState withDetailInfo:[_currentRepeatDay stringByAppendingString:_currentRepeatTime] withActiveState:_isEnableRepeat];
        
        return cell;
        
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4){
        
        return [AddSpaceTaskSecondCell heightForAddSpaceTaskSecondCell];
    }else{
        return 44.f;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 3){
        
        //结合
        if(!_isEnableCombine){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否激活结合时间" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10086;
            [alertView show];
            
        }else{
            
            _currentSelectedDateIndex = @"2";
            //打开 弹出框
            UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"持续天数" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView1.tag = 5000;
            alertView1.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alertView1 textFieldAtIndex:0];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [alertView1 show];
            
        }
        
    }else if (indexPath.row == 4){
        
        if(!_isEnableRepeat){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否激活重复时间" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10010;
            [alertView show];
            
        }else{
            
            //重复
            _currentSelectedDateIndex = @"3";
            UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"重复天数" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView1.tag = 6000;
            alertView1.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alertView1 textFieldAtIndex:0];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [alertView1 show];
            
        }
        
        
    }else if (indexPath.row == 2){
        
        //首次执行时间
        _currentSelectedDateIndex = @"1";
        [UIView animateWithDuration:.5 animations:^{
            
            [_datePicker setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT-216.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
            
            [datePickerAccessoryView setFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
            
        }];
        
    }
    
}

#pragma mark AddSpaceTaskFirstCellDelegate
-(void)addSpaceTaskFirstCellOnClickChooseSwitch:(NSString *)switchState{
    
    _currentNestState = switchState;
    
    if([switchState isEqual:@"1"]){
        
        //开启嵌套
        [_tableView reloadData];
        
    }else{
        
        //关闭嵌套
        [_tableView reloadData];
    }
    
}

#pragma mark AddSpaceTaskSecondCellDelegate
-(void)addSpaceTaskSecondCellOnClickChooseSwitch:(NSString *)switchState{
    
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    _currentSelectedDateIndex = @"1";
    
    _currentFirstDoTimeSwitchState = switchState;
    
}

//结合
-(void)addSpaceTaskSecondCellCombineOnClickChooseSwitch:(NSString *)switchState{
    
    _datePicker.datePickerMode = UIDatePickerModeTime;
    
    _currentSelectedDateIndex = @"2";
    
    _currentCombineState = switchState;
    

}

//重复
-(void)addSpaceTaskSecondCellRepateOnClickChooseSwitch:(NSString *)switchState{
    
    _datePicker.datePickerMode = UIDatePickerModeTime;
    
    _currentSelectedDateIndex = @"3";
    
    _currentRepeatState = switchState;
    
}


#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 5000){
        
        // 结合
        if(buttonIndex == 0){
            // 取消
            
            
        }else{
            // 确定
            
            //当前持续天数
            UITextField *textField = [alertView textFieldAtIndex:0];
            
            if(![textField.text isEqual:@""]){
                
                _combineDay = textField.text;
                
                _currentCombineDay = [NSString stringWithFormat:@"%@天",textField.text];
                
                [UIView animateWithDuration:.5 animations:^{
                    
                    [_datePicker setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT-216.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
                    
                    [datePickerAccessoryView setFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
                    
                }];
            }else{
                
                [self showSuccessOrFailedMessage:@"请输入持续天数"];
                
            }
            
            
        }
        
    }else if(alertView.tag == 6000){
        
        if(buttonIndex == 0){
            
            
        }else{
            
            
            UITextField *textField = [alertView textFieldAtIndex:0];
            
            if(![textField.text isEqual:@""]){
                
                _repeateDay = textField.text;
                
                _currentRepeatDay = [NSString stringWithFormat:@"%@天",textField.text];
                
                //打开 弹出框
                [UIView animateWithDuration:.5 animations:^{
                    
                    [_datePicker setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT-216.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
                    
                    [datePickerAccessoryView setFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
                    
                }];
                
            }else{
                
                [self showSuccessOrFailedMessage:@"请输入自定义周期"];
            }
            
            
        }

    }else if (alertView.tag == 10086){
        
        //结合
        if(buttonIndex == 0){
            
            _isEnableCombine = NO;
            
        }else{
            
            _isEnableCombine = YES;
            //激活结合时间 默认0天
            _currentCombineDay = @"0天";
            _currentCombineTime = @"0时0分0秒";
            _combineDateDic = [@{@"0":@"hour",@"0":@"min",@"0":@"sec"} mutableCopy];
            
        }
        
        [_tableView reloadData];
        
    }else if (alertView.tag == 10010){
        
        //重复
        
        if(buttonIndex == 0){
            
            _isEnableRepeat = NO;
            
        }else{
            
            _isEnableRepeat = YES;
            
            //激活重复时间 默认0天
            _currentRepeatDay = @"0天";
            _currentRepeatTime = @"0时0分0秒";
            _repeatDateDic = [@{@"0":@"hour",@"0":@"min",@"0":@"sec"} mutableCopy];
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
    
    //选择任务
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.tag = 3000;
    for (int i=0; i<[_aryTaskData count]; i++) {
        
        TaskInfo *taskInfo = [_aryTaskData objectAtIndex:i];
        
        [actionSheet addButtonWithTitle:[Utility getTaskInfoNameByTaskInfo:taskInfo]];
        
        taskInfo.taskInfoName = [Utility getTaskInfoNameByTaskInfo:taskInfo];
    }
    
    [actionSheet showInView:self.view];
    
}


#pragma mark UIActionSheeetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == 2000){
        
        if(buttonIndex != 0){
            
            SwitchInfo *switchInfo = [_arySwitchData objectAtIndex:buttonIndex-1];
            
            _currentSelectedSwitchName = switchInfo.switchName;
            _currentSelectedSwitchIndex = switchInfo.switchIndex;
            [_tableView reloadData];
            
        }else{
            
            //点击取消
            
        }
        
        
    }else if (actionSheet.tag == 3000){
        
        if(buttonIndex != 0){
            
            TaskInfo *taskInfo = [_aryTaskData objectAtIndex:buttonIndex-1];
            
            _currentSelectedTaskName = taskInfo.taskInfoName;
            _currentSelectedTaskIndex = taskInfo.taskIndex;
            [_tableView reloadData];
            
        }else{
            
            //点击取消
            
        }
        
    }
    
    
    
}


- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//添加
- (IBAction)onClickAdd:(id)sender {
    
    int error = 0;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if(_taskInfoID && ![_taskInfoID isEqual:@""]){
        [paramDic setObject:_taskInfoID forKey:@"id"]; //修改
    }else{
        [paramDic setObject:@"-1" forKey:@"id"];//新增
    }

    
    if(_intelligentDeviceID && ![_intelligentDeviceID isEqual:@""]){
         [paramDic setObject:_intelligentDeviceID forKey:@"centerControllerId"];
    }

    
    [paramDic setObject:@"2" forKey:@"type"]; // type
    if(_currentGetFirstDoTime && ![_currentGetFirstDoTime isEqual:@""]){
        [paramDic setObject:_currentGetFirstDoTime forKey:@"executionDate"]; //首次执行日期字符串
    }else{
        
        if(error == 0){
            [self showSuccessOrFailedMessage:@"请选择首次执行日期"];
        }
        
        error++;
    }
    
    
    /*
     
     action1 对应首次执行开关 开或者关
     action2 对应结合执行开关 开或者关
     
     */
    [paramDic setObject:_currentFirstDoTimeSwitchState forKey:@"action1"];
    
    
    [paramDic setObject:_currentCombineState forKey:@"action2"];
    
    //首次执行任务状态
    if([_currentFirstDoTimeSwitchState isEqual:@"1"]){
        
        [paramDic setObject:[Utility changeTianShiFenMiaoToHaoMiao:@"0" withShi:[_firstDoDateDic objectForKey:@"hour"] withFen:[_firstDoDateDic objectForKey:@"min"] withMiao:[_firstDoDateDic objectForKey:@"sec"]] forKey:@"executionTs1"]; //首次执行开关的 时分秒的毫秒数
        
    }
   
    //结合
    if(_isEnableCombine){
        
        //结合开关被激活
        
        if(_combineDay && ![_combineDay isEqual:@""]){
            [paramDic setObject:[Utility changeTianShiFenMiaoToHaoMiao:_combineDay withShi:[_combineDateDic objectForKey:@"hour"] withFen:[_combineDateDic objectForKey:@"min"] withMiao:[_combineDateDic objectForKey:@"sec"]] forKey:@"executionTs2"]; //天时分秒的毫秒数
        }else{
            
            if(error == 0){
                [self showSuccessOrFailedMessage:@"请选择持续时间"];
            }
            
            error++;
            
        }
        
        
    }
    
    if(_isEnableRepeat){
        
        //激活
        
        if(_repeateDay && ![_repeateDay isEqual:@""]){
            [paramDic setObject:[Utility changeTianShiFenMiaoToHaoMiao:_repeateDay withShi:[_repeatDateDic objectForKey:@"hour"] withFen:[_repeatDateDic objectForKey:@"min"] withMiao:[_repeatDateDic objectForKey:@"sec"]] forKey:@"period"]; //循环周期
        }else{
            if(error == 0){
                [self showSuccessOrFailedMessage:@"请选择自定义周期"];
            }
            
            error++;
        }
        
    }
    
    
    if(_currentNestState && ![_currentNestState isEqual:@""] && [_currentNestState isEqual:@"1"]){
        [paramDic setObject:@"2" forKey:@"type2"]; //是否有嵌套任务
    }else{
        
        //没有嵌套任务
        [paramDic setObject:@"0" forKey:@"type2"];
        
    }
    
    
    if([_currentNestState isEqual:@"1"]){
        
        //当前嵌套子任务
        
        if(_currentSelectedTaskIndex && ![_currentSelectedTaskIndex isEqual:@""]){
            
            if([_currentNestState isEqual:@"1"]){
                [paramDic setObject:_currentSelectedTaskIndex forKey:@"childTaskId"]; //嵌套任务子任务编号
            }
            
        }else{
            
            if(error == 0){
                [self showSuccessOrFailedMessage:@"请选择任务编号"];
            }
            
            error++;
            
        }
        
        
    }else{
        
        //没有嵌套任务
        if(_currentSelectedSwitchIndex && ![_currentSelectedSwitchIndex isEqual:@""]){
            
            if([_currentNestState isEqual:@"1"]){
                [paramDic setObject:_currentSelectedTaskIndex forKey:@"switchIndex"]; //子任务编号
            }else{
                [paramDic setObject:_currentSelectedSwitchIndex forKey:@"switchIndex"]; //开关序号
            }
        }else{
            
            if(error == 0){
                [self showSuccessOrFailedMessage:@"请选择开关编号"];
            }
            
            error++;
            
        }

        
    }
    
    
    if(error == 0){
        
        [[RequestService defaultRequestService] asyncPostDataWithURL:SaveIntelligentSpacingTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
            
            if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                [self showSuccessOrFailedMessage:@"添加间隔任务成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [self showSuccessOrFailedMessage:[responseDic objectForKey:@"error"]];
            }
            
        } errorBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
        
    }
    
}
@end
