//
//  IntelligentContextualWeekTaskViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/2.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntelligentContextualWeekTaskViewController.h"
#import "Utility.h"

@interface IntelligentContextualWeekTaskViewController ()

@end

@implementation IntelligentContextualWeekTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _currentSelectedWeekArray = [[NSMutableArray alloc] init];
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f)];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [self layoutIntelligentContextualWeekTaskView];
    
    //获取所有Model
    [self loadAllContextualModelByHomeID];
    if(_taskInfoID && ![_taskInfoID isEqual:@""]){
        
        //加载得到任务详情
        [self loadTaskInfoData];
    }
}

-(void)loadTaskInfoData{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_taskInfoID forKey:@"taskId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:GetCurrentTaskInfo paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            
            
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
    
}

-(void)layoutIntelligentContextualWeekTaskView{
    
    _aryContextualModelData = [[NSMutableArray alloc] init];
    _aryData = [[NSMutableArray alloc] init];
    _aryWeekdayData = [[NSMutableArray alloc] initWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天", nil];
    _aryWeekIDData = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    
    
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
    [datePickerAccessoryView addSubview:cancelBtn];
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


-(void)loadAllContextualModelByHomeID{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:GetContextualModelList paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        NSMutableArray *currentTempArray = [[NSMutableArray alloc] init];
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if([responseDic objectForKey:@"data"] && ![[responseDic objectForKey:@"data"] isEqual:@""] && ![[responseDic objectForKey:@"data"] isKindOfClass:[NSNull class]]){
                
                NSMutableArray *tempArray = [responseDic objectForKey:@"data"];
                
                for (int i=0; i<[tempArray count]; i++) {
                    
                    NSMutableDictionary *tempDic = [tempArray objectAtIndex:i];
                    
                    ContextualModel *model = [[ContextualModel alloc] init];
                    [model setContextualModelWithDataDic:tempDic];
                    [currentTempArray addObject:model];
                    
                }
                
                _aryContextualModelData = currentTempArray;
                
                [_tableView reloadData];
                
            }
            
        }
        
        [self removeLoadingMessage];
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
        [self removeLoadingMessage];
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

#pragma mark UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        
        // 选择情景模式
        static NSString *cellIdentifier = @"AddTaskFirstCell";
        
        AddTaskFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            
            cell = [[AddTaskFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddTaskFirstCell:_currentSelectedContextual withShowLabel:@"选择情景"];
        
        return cell;

        
    }else if(indexPath.row == 1){
        
        
        static NSString *cellIdentifier = @"AddTaskFirstCell";
        
        AddTaskFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            
            cell = [[AddTaskFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddTaskFirstCell:_currentAppendingWeek withShowLabel:@"选择星期"];
        
        return cell;

        
    }else if (indexPath.row == 2){
        
        //选择时间 时 分
        static NSString *cellIndentifier = @"AddSpaceTaskSecondCell";
        
        AddSpaceTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if(cell == nil){
            
            cell = [[AddSpaceTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddSpaceTaskSecondCellData:@"打开" withSwitchState:_currentOpenState withDetailInfo:_currentOpenTime withActiveState:nil];
        
        return cell;
        
    }else if (indexPath.row == 3){
        
        
        static NSString *cellIndentifier = @"AddSpaceTaskSecondCell";
        
        AddSpaceTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if(cell == nil){
            
            cell = [[AddSpaceTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddSpaceTaskSecondCellData:@"关闭" withSwitchState:_currentClosedState withDetailInfo:_currentClosedTime withActiveState:nil];
        
        return cell;
        
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 2 || indexPath.row == 3){
        
        return 60.f;
    }else{
        
        return 44.f;
    }
}


#pragma mark AddTaskFirstCellDelegate
-(void)addTaskFirstCellOnClickChooseTask:(NSString *)chooseType{

    
    if([chooseType isEqual:@"选择星期"]){
        
        //选择星期
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = 4000;
        for (int i=0; i<[_aryWeekdayData count]; i++) {
            
            [actionSheet addButtonWithTitle:[_aryWeekdayData objectAtIndex:i]];
        }
        
        [actionSheet showInView:self.view];
        
    }else if ([chooseType isEqual:@"选择情景"]){
        
        // 选择对应的情景
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = 5000;
        for (int i=0; i<[_aryContextualModelData count]; i++) {
            
            ContextualModel *model = [_aryContextualModelData objectAtIndex:i];
            
            [actionSheet addButtonWithTitle:model.contextualModelName];
        }
        
        [actionSheet showInView:self.view];
    }
    
}


#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == 4000){
        
        //星期
        
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

        
    }else if (actionSheet.tag == 5000){
        
        //情景
        ContextualModel *model = [_aryContextualModelData objectAtIndex:buttonIndex-1];
        
        //当前选中的情景模式
        _currentSelectedContextual = model.contextualModelName;
        _currentSelectedContextualID = model.contextualModelID;
        
        [_tableView reloadData];
        
    }
    
    
    
}


#pragma mark AddSpaceTaskSecondCellDelegate
-(void)addWeekTaskSecondCellOpenOnClickChooseSwitch:(NSString *)switchState{
    
    _currentSelectedDateIndex = @"1";
    _currentOpenState = switchState;
    
    if([switchState isEqual:@"0"]){
        //  关闭
        [self onClickCancel];
    }else{
        
        [UIView animateWithDuration:.5 animations:^{
            
            [_datePicker setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT-216.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
            
            [datePickerAccessoryView setFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
            
            [_tableView reloadData];
            
        }];
    }
    
}

-(void)addWeekTaskSecondCellCloseOnClickChooseSwitch:(NSString *)switchState{
    
    _currentSelectedDateIndex = @"2";
    _currentClosedState = switchState;
    
    if([switchState isEqual:@"0"]){
        //  关闭
        [self onClickCancel];
        
    }else if ([switchState isEqual:@"1"]){
        //打开
        [UIView animateWithDuration:.5 animations:^{
            
            [_datePicker setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT-216.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
            
            [datePickerAccessoryView setFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
            
            [_tableView reloadData];
            
        }];
    }
}



- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickAdd:(id)sender {
    
    int errorNum = 0;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if(_taskInfoID && ![_taskInfoID isEqual:@""]){
        [paramDic setObject:_taskInfoID forKey:@"id"];
    }else{
        [paramDic setObject:@"-1" forKey:@"id"];
    }
    
    [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
    if(_currentSelectedContextualID && ![_currentSelectedContextualID isEqual:@""]){
        [paramDic setObject:_currentSelectedContextualID forKey:@"switchIndex"];
    }else{
        
        if(errorNum == 0){
            [self showSuccessOrFailedMessage:@"请选择情景"];
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
    
    
    if([_currentOpenState isEqual:@"1"]){
        
        if(_currentOPenDic){
            
            //打开操作激活
            [paramDic setObject:@"1" forKey:@"action1"];
            [paramDic setObject:[Utility changeTianShiFenMiaoToHaoMiao:@"0" withShi:[_currentOPenDic objectForKey:@"hour"] withFen:[_currentOPenDic objectForKey:@"min"] withMiao:@"0"] forKey:@"executionTs1"]; //打开的执行时间 毫秒
            
        }else{
            
            if(errorNum == 0){
                [self showSuccessOrFailedMessage:@"请输入时间"];
            }
            
            errorNum ++;
            
        }
        
    }else{
        [paramDic setObject:@"0" forKey:@"action1"];
    }
    
    if([_currentClosedState isEqual:@"1"]){
        
        if(_currentCloseDic){
            
            //关闭操作激活
            [paramDic setObject:@"1" forKey:@"action2"];
            [paramDic setObject:[Utility changeTianShiFenMiaoToHaoMiao:@"0" withShi:[_currentCloseDic objectForKey:@"hour"] withFen:[_currentCloseDic objectForKey:@"min"] withMiao:@"0"]  forKey:@"executionTs2"]; //关闭的执行时间 毫秒
        }else{
            
            if(errorNum == 0){
                [self showSuccessOrFailedMessage:@"请输入时间"];
            }
            
            errorNum ++;
            

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
        
        [[RequestService defaultRequestService] asyncPostDataWithURL:SaveContexualWeekTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
            
            if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                [self showSuccessOrFailedMessage:@"添加周任务成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } errorBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
        
    }
    
    
}
@end
