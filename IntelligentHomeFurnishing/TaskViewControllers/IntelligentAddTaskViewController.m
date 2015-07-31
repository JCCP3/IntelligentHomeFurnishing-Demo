//
//  IntelligentAddTaskViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/27.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntelligentAddTaskViewController.h"
#import "Utility.h"

@interface IntelligentAddTaskViewController ()

@end

@implementation IntelligentAddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    _aryData = [[NSMutableArray alloc] init];
    _arySwitchData = [[NSMutableArray alloc] init]; //所有开关集合
    _currentSelectedSwitchNameArray = [[NSMutableArray alloc] init];
    _currentSelectedSwitchIndexArray = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    //适配
    [self layoutIntelligentAddTaskView];
    
    //加载对应集成器的开关
    [self loadIntelligentAllSwitch];
    
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
                            
                            
                            NSString *currentSwitchInfoString =   currentSwitchInfo.switchName;                [_currentSelectedSwitchNameArray addObject:currentSwitchInfoString];
                            
                            [_currentSelectedSwitchIndexArray addObject:[NSString stringWithFormat:@"%d",[switchArray count]-i]];
                            
                        }
                        
                    }

                    
                }
        
                NSString *appendingString = @"";
                
                
                for (int i=0; i<[_currentSelectedSwitchNameArray count]; i++) {
                    
                    if(i<[_currentSelectedSwitchNameArray count]-1){
                        appendingString = [appendingString stringByAppendingString:[_currentSelectedSwitchNameArray objectAtIndex:i]];
                        appendingString = [appendingString stringByAppendingString:@","];
                    }else{
                        appendingString = [appendingString stringByAppendingString:[_currentSelectedSwitchNameArray objectAtIndex:i]];
                    }
                }
                
                _currentAppendingName = appendingString;
                
                NSString *appendingIndexString = @"";
                
                for (int i=0; i<[_currentSelectedSwitchIndexArray count]; i++) {
                    
                    if(i<[_currentSelectedSwitchIndexArray count]-1){
                        appendingIndexString = [appendingIndexString stringByAppendingString:[_currentSelectedSwitchIndexArray objectAtIndex:i]];
                        appendingIndexString = [appendingIndexString stringByAppendingString:@","];
                    }else{
                        appendingIndexString = [appendingIndexString stringByAppendingString:[_currentSelectedSwitchIndexArray objectAtIndex:i]];
                    }
                }
                
                _currentAppendingIndex = appendingIndexString;
                
                
                /*  设置状态 */
                
                if(_currentTaskInfo.taskAction1 && ![_currentTaskInfo.taskAction1 isEqual:@""]){
                    //激活日出操作
                    _isEnableSunUp = YES; //已经激活
                    
                    if([_currentTaskInfo.taskAction1 intValue] == 1){
                        
                        //日出打开
                        _currentSunUpSwithState = @"1";
                    }else{
                        
                        //日出关闭
                        _currentSunUpSwithState = @"0";
                    }
                    
                    
                }else{
                    _currentSunUpSwithState = @"0";
                    
                    _isEnableSunUp = NO;
                    //未激活
                }
               
                if(_currentTaskInfo.taskExecutionTs1 && ![_currentTaskInfo.taskExecutionTs1 isEqual:@""]){
                    
                    //已经激活
                    _currentSunUpDelay = _currentTaskInfo.taskExecutionTs1; //日出推迟的分钟数
                }else{
                    _currentSunUpDelay = @"";
                }
                
                
                /* 日落操作 */
                if(_currentTaskInfo.taskAction2 && ![_currentTaskInfo.taskAction2 isEqual:@""]){
                    //激活日出操作
                    _isEnableSunDown = YES; //已经激活
                    
                    if([_currentTaskInfo.taskAction2 intValue] == 1){
                        
                        //日落打开
                        _currentSunDownSwitchState = @"1";
                    }else{
                        
                        //日落关闭
                        _currentSunDownSwitchState = @"0";
                    }
                    
                    
                }else{
                
                    _currentSunDownSwitchState = @"0";
                    
                    _isEnableSunDown = NO;
                    //未激活
                }
                
                if(_currentTaskInfo.taskExecutionTs2 && ![_currentTaskInfo.taskExecutionTs2 isEqual:@""]){
                    
                    //已经激活
                    _currentSunDownDelay = _currentTaskInfo.taskExecutionTs2; //日出推迟的分钟数
                }else{
                    _currentSunDownDelay = @""; //日落推迟分钟数
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


-(void)layoutIntelligentAddTaskView{
    
    [_addTaskBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_addTaskBtn.bounds.size.width, _addTaskBtn.frame.origin.y, _addTaskBtn.bounds.size.width, _addTaskBtn.bounds.size.height)];
    
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
                
                
                /* 加载开关成功 */
                
                //得到任务详情
                if(_taskInfoID && ![_taskInfoID isEqual:@""]){
                    
                    //加载得到任务详情
                    [self showLoadingMessage:@"加载中..."];
                    [self loadTaskInfoData];
                    
                }else{
                    
                    //当前是添加
                    //默认开关都关闭 添加的时候
                    _currentSunUpSwithState = @"0";
                    _currentSunDownSwitchState = @"0";
                    _currentSunDownDelay = @""; //日落推迟分钟数
                    _currentSunUpDelay = @""; //日出推迟的分钟数
                    
                }

                
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

#pragma mark UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        
        static NSString *cellIdentifier = @"AddTaskFirstCell";
        
        AddTaskFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            
            cell = [[AddTaskFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddTaskFirstCell:_currentAppendingName withShowLabel:@"选择开关"];
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        
        static NSString *cellIdentifier = @"AddTaskSecondCell";
        
        AddTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            
            cell = [[AddTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddTaskSecondCell:@"日出时间" withSwitch:_currentSunUpSwithState withDelayInfo:_currentSunUpDelay withActiveState:_isEnableSunUp];
        
        return cell;
        
    }else if (indexPath.row == 2){
        
        static NSString *cellIdentifier = @"AddTaskSecondCell";
        
        AddTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            
            cell = [[AddTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddTaskSecondCell:@"日落时间" withSwitch:_currentSunDownSwitchState withDelayInfo:_currentSunDownDelay withActiveState:_isEnableSunDown];
        
        return cell;
    }
    
    return nil;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 1 || indexPath.row == 2){
        return [AddTaskSecondCell heightForAddTaskSecondCell];
    }else{
        return [AddTaskFirstCell heightForTaskFirstCell];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 1){
        
        if(!_isEnableSunUp){
            //日出时间
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否激活日出时间" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 3000;
            [alertView show];
        }else{
            
            //弹出选择日出日期框
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"日出推迟" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 1000;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *sunUpTextField = [alertView textFieldAtIndex:0];
            sunUpTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            sunUpTextField.placeholder = @"提前请输入负数";
            [alertView show];
            
            
        }
        
        
    }else if (indexPath.row == 2){
        
        //日落时间
        if(!_isEnableSunDown){
            //日出时间
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否激活日落时间" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 4000;
            [alertView show];
        }else{
            
            //弹出选择日落日期框
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"日落推迟" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 2000;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *sunDownTextField = [alertView textFieldAtIndex:0];
            sunDownTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            sunDownTextField.placeholder = @"提前请输入负数";
            [alertView show];
        }
    }

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark 提交添加任务
- (IBAction)onClickAddTask:(id)sender {
    
    int errorNum = 0;
    
    //集中器模式下 添加太阳时任务
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if(_taskInfoID && ![_taskInfoID isEqual:@""]){
        [paramDic setObject:_taskInfoID forKey:@"id"]; //新增时为－1 修改为
    }else{
        [paramDic setObject:@"-1" forKey:@"id"]; //新增时为－1 修改为
    }
    
    if(_intelligentDeviceID && ![_intelligentDeviceID isEqual:@""]){
         [paramDic setObject:_intelligentDeviceID forKey:@"centerControllerId"]; //集中器编号
    }else if(_currentTaskInfo.taskCenterControllerID){
        //集中器编号
        [paramDic setObject:_currentTaskInfo.taskCenterControllerID forKey:@"centerControllerId"];
    }
   
    
    if(_currentAppendingIndex && ![_currentAppendingIndex isEqual:@""]){
        
         [paramDic setObject:_currentAppendingIndex forKey:@"switchIndexsString"]; //开关序号
        
    }else{
        
        if(errorNum == 0){
            
            [self showSuccessOrFailedMessage:@"请选择开关"];
            errorNum ++;
            
        }
        
    }

    

    if(_isEnableSunUp){
        
        //日出操作被激活
        [paramDic setObject:@"1" forKey:@"closed"];
        
        if([_currentSunUpSwithState isEqual:@"1"]){
            //开关打开操作
            
            if([_currentSunUpDelay intValue]<0){
                [paramDic setObject:@"-1" forKey:@"closedDelay"];
            }else{
                [paramDic setObject:@"1" forKey:@"closedDelay"];
            }
            
           
            [paramDic setObject:@"1" forKey:@"closedFromRaiseOrSet"]; //日出操作打开
            
            if(_currentSunUpDelay && ![_currentSunUpDelay isEqual:@""]){
               [paramDic setObject:_currentSunUpDelay forKey:@"closedDelayMinutes"]; //日出操作提前分钟数
            }else{
                
                if(errorNum == 0){
                    
                    [self showSuccessOrFailedMessage:@"请选择推迟提出时间开关"];
                    errorNum ++;
                    
                }
                
            }
            
            
        }else if([_currentSunUpSwithState isEqual:@"0"]){
            
            //开关关闭操作
            if([_currentSunUpDelay intValue]<0){
                [paramDic setObject:@"-1" forKey:@"closedDelay"];
            }else{
                [paramDic setObject:@"1" forKey:@"closedDelay"];
            }
            
            [paramDic setObject:@"0" forKey:@"closedFromRaiseOrSet"]; //日出操作关闭
            
            
            
            if(_currentSunUpDelay && ![_currentSunUpDelay isEqual:@""]){
                [paramDic setObject:_currentSunUpDelay forKey:@"closedDelayMinutes"]; //日出操作提前分钟数
            }else{
                
                if(errorNum == 0){
                    
                    [self showSuccessOrFailedMessage:@"请选择推迟时间"];
                    errorNum ++;
                    
                }
                
            }
            
            
            
        }
        
    }else{
        
        //日出操作没激活
        [paramDic setObject:@"0" forKey:@"closed"];
        
        
    }
    
    
    
    if(_isEnableSunDown){
        
        //激活日落操作
        [paramDic setObject:@"1" forKey:@"opened"];
        
        
        if([_currentSunDownSwitchState isEqual:@"1"]){
            
            if([_currentSunDownDelay intValue]<0){
                [paramDic setObject:@"-1" forKey:@"openedDelay"];
            }else{
                [paramDic setObject:@"1" forKey:@"openedDelay"];
            }
            
            if(_currentSunDownDelay && ![_currentSunDownDelay isEqual:@""]){
                [paramDic setObject:_currentSunDownDelay forKey:@"openedDelayMinutes"];
            }else{
                
                if(errorNum == 0){
                    
                    [self showSuccessOrFailedMessage:@"请选择推迟时间"];
                    errorNum ++;
                    
                }
                
            }
            
            [paramDic setObject:@"1" forKey:@"openedFromRaiseOrSet"];
            
        }else{
            
            [paramDic setObject:@"0" forKey:@"openedFromRaiseOrSet"];
        }
        
        
        
    }else{
        
        [paramDic setObject:@"0" forKey:@"opened"];
        
    }
    
    /* 判断出错信息 */
    if(!_isEnableSunDown && !_isEnableSunUp){
        if(errorNum == 0){
            [self showSuccessOrFailedMessage:@"请激活至少一个操作"];
            errorNum++;
        }
    }
    
    if([_currentSunUpDelay isEqual:@""] && [_currentSunDownDelay isEqual:@""]){
        if(errorNum == 0){
            [self showSuccessOrFailedMessage:@"请至少选择一个操作"];
            errorNum++;
        }
    }
    
    if(errorNum == 0){
     
        [[RequestService defaultRequestService] asyncPostDataWithURL:SaveIntelligentSunTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
            
            if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                // 添加太阳时任务成功
                [self showSuccessOrFailedMessage:@"添加太阳时任务成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        } errorBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];

        
    }
}

- (IBAction)onClickBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark AddTaskFirstCellDelegate
-(void)addTaskFirstCellOnClickChoose:(NSString *)chooseType{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (int i=0; i<[_arySwitchData count]; i++) {
        
        SwitchInfo *switchInfo = [_arySwitchData objectAtIndex:i];
        
        [actionSheet addButtonWithTitle:switchInfo.switchName];
    }
    
    [actionSheet showInView:self.view];
    
}

-(void)addTaskFirstCellOnClickChooseTask:(NSString *)chooseType{
    
    //不做任何操作
    
}

#pragma mark UIActionSheeetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex != 0){
        
        SwitchInfo *switchInfo = [_arySwitchData objectAtIndex:buttonIndex-1];
    
        _currentSelectedSwitchName = switchInfo.switchName;
        _currentSelectedSwitchIndex = switchInfo.switchIndex;
        
        if(![_currentSelectedSwitchNameArray containsObject:_currentSelectedSwitchName]){
            [_currentSelectedSwitchNameArray addObject:_currentSelectedSwitchName];
        }else{
            [_currentSelectedSwitchNameArray removeObject:_currentSelectedSwitchName];
        }
        
        if(![_currentSelectedSwitchIndexArray containsObject:_currentSelectedSwitchIndex]){
            [_currentSelectedSwitchIndexArray addObject:_currentSelectedSwitchIndex];
        }else{
            [_currentSelectedSwitchIndexArray removeObject:_currentSelectedSwitchIndex];
        }
        
        NSString *appendingString = @"";
        
        
        for (int i=0; i<[_currentSelectedSwitchNameArray count]; i++) {
            
            if(i<[_currentSelectedSwitchNameArray count]-1){
                appendingString = [appendingString stringByAppendingString:[_currentSelectedSwitchNameArray objectAtIndex:i]];
                appendingString = [appendingString stringByAppendingString:@","];
            }else{
                appendingString = [appendingString stringByAppendingString:[_currentSelectedSwitchNameArray objectAtIndex:i]];
            }
        }
    
        _currentAppendingName = appendingString;
        
        
        NSString *appendingIndexString = @"";
        
        for (int i=0; i<[_currentSelectedSwitchIndexArray count]; i++) {
            
            if(i<[_currentSelectedSwitchIndexArray count]-1){
                appendingIndexString = [appendingIndexString stringByAppendingString:[_currentSelectedSwitchIndexArray objectAtIndex:i]];
                appendingIndexString = [appendingIndexString stringByAppendingString:@","];
            }else{
                appendingIndexString = [appendingIndexString stringByAppendingString:[_currentSelectedSwitchIndexArray objectAtIndex:i]];
            }
        }
        
        _currentAppendingIndex = appendingIndexString;
        [_tableView reloadData];
        
    }else{
        
        //点击取消
        
    }
    
}

#pragma mark AddTaskSecondCellDelegate
-(void)addTaskSecondCellOnClickSwitch:(NSString *)showInfo withSwitchState:(NSString *)switchState{
    
    if([showInfo isEqual:@"日出时间"]){
        
        if([switchState isEqual:@"0"]){
            //未开
            _currentSunUpSwithState = switchState;
        }else if([switchState isEqual:@"1"]){
            //开 弹出框
            _currentSunUpSwithState = switchState;
        
            
        }
        
    }else if([showInfo isEqual:@"日落时间"]){
        
        if([switchState isEqual:@"0"]){
            //未开
            _currentSunDownSwitchState = switchState;
        }else if([switchState isEqual:@"1"]){
            //开 弹出框
            _currentSunDownSwitchState = switchState;
           
        }
        
    }
    
   
    
}

#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 1000){
        
        if(buttonIndex == 0){
            
            //确定
            //日出
            UITextField *sunUpTextField = [alertView textFieldAtIndex:0];
            
            if(![sunUpTextField.text isEqual:@""]){
                
                //判断是否是数字
                if(![Utility checkIsNum:sunUpTextField.text]){
                    //不是数字
                    [self showSuccessOrFailedMessage:@"请输入数字"];
                    
                }else{
                    
                    _currentSunUpDelay = sunUpTextField.text;
                    [_tableView reloadData];
                }
                
            }else{
                
                [self showSuccessOrFailedMessage:@"请输入延迟时间"];
                
            }
            
        }else{
            
            
        }
        
        
    }else if (alertView.tag == 2000){
        
        if(buttonIndex == 0){
            
            //确定
            //日落
            UITextField *sunDownTextField = [alertView textFieldAtIndex:0];
            
            if(![sunDownTextField.text isEqual:@""]){
                
                if(![Utility checkIsNum:sunDownTextField.text]){
                    [self showSuccessOrFailedMessage:@"请输入数字"];
                    
                }else{
                    _currentSunDownDelay = sunDownTextField.text;
                    [_tableView reloadData];
                }
                
            }else{
                
                [self showSuccessOrFailedMessage:@"请输入延迟时间"];
                
            }
            
        }else{
            
        }
        
        
    }else if (alertView.tag == 3000){
        
        //是否激活日出操作
        if(buttonIndex == 0){
            
            //取消
            _isEnableSunUp = NO;
        }else{
            
            //确定
            _isEnableSunUp = YES;
            _currentSunUpDelay = @"0";
        }
        
        [_tableView reloadData];
        
    }else if (alertView.tag == 4000){
        
        //是否激活日出操作
        if(buttonIndex == 0){
            
            //取消
            _isEnableSunDown = NO;
        }else{
            
            //确定
            _isEnableSunDown = YES;
            _currentSunDownDelay = @"0";
        }
        
        [_tableView reloadData];
        
    }

    
}

@end
