//
//  IntelligentContextualAddSpaceTaskViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/2.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntelligentContextualAddSpaceTaskViewController.h"
#import "Utility.h"

@interface IntelligentContextualAddSpaceTaskViewController ()

@end

@implementation IntelligentContextualAddSpaceTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    
    //默认
    _currentFirstDoTimeSwitchState = @"0"; //默认不选中
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [self layoutIntelligentContexualAddSpaceTaskView];
    
    //默认
    _currentCombineState = @"0";
    _currentRepeatState = @"0";
    
    //获取所有情景模式
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
-(void)layoutIntelligentContexualAddSpaceTaskView{
    
    [_addBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_addBtn.bounds.size.width, _addBtn.frame.origin.y, _addBtn.bounds.size.width, _addBtn.bounds.size.height)];
    
    _aryData = [[NSMutableArray alloc] init];
    _aryContextualModelData = [[NSMutableArray alloc] init];
    
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

#pragma mark UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
        
        [cell loadAddTaskFirstCell:_currentSelectedContextualModel withShowLabel:@"选择情景"];
        
        return cell;
        
    }else if (indexPath.row == 1){
        
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

        
    }else if (indexPath.row == 2){
        
        // 结合
        static NSString *cellIndentifier = @"AddSpaceTaskSecondCell";
        
        AddSpaceTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if(cell == nil){
            
            cell = [[AddSpaceTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddSpaceTaskSecondCellData:@"持续时间" withSwitchState:_currentCombineState withDetailInfo:[_currentCombineDay stringByAppendingString:_currentCombineTime] withActiveState:nil];
        
        return cell;

    }else if (indexPath.row == 3){
        
        //重复
        static NSString *cellIndentifier = @"AddSpaceTaskSecondCell";
        
        AddSpaceTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if(cell == nil){
            
            cell = [[AddSpaceTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        
        [cell loadAddSpaceTaskSecondCellData:@"自定义周期" withSwitchState:_currentRepeatState withDetailInfo:[_currentRepeatDay stringByAppendingString:_currentRepeatTime] withActiveState:nil];
        
        return cell;
        
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
        return 60.f;
    }
    return 44.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 2){
        
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
        
    }else if (indexPath.row == 3){
        
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
        
        
    }else if (indexPath.row == 1){
        
        //首次执行时间
        _currentSelectedDateIndex = @"1";
        [UIView animateWithDuration:.5 animations:^{
            
            [_datePicker setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT-216.f, DEVICE_AVALIABLE_WIDTH, 216.f)];
            
            [datePickerAccessoryView setFrame:CGRectMake(0, _datePicker.frame.origin.y-40.f, DEVICE_AVALIABLE_WIDTH, 40.f)];
            
        }];
        
    }
    
}


#pragma mark AddTaskFirstCell
-(void)addTaskFirstCellOnClickChooseTask:(NSString *)chooseType{
    
    // 选择对应的情景
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (int i=0; i<[_aryContextualModelData count]; i++) {
        
        ContextualModel *model = [_aryContextualModelData objectAtIndex:i];
        
        [actionSheet addButtonWithTitle:model.contextualModelName];
    }
    
    [actionSheet showInView:self.view];
    
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
        //点击取消
        
    }else{
        
        ContextualModel *model = [_aryContextualModelData objectAtIndex:buttonIndex-1];
        
        //当前选中的情景模式
        _currentSelectedContextualModel = model.contextualModelName;
        _CurrentSelectedContextualModelID = model.contextualModelID;
        
        [_tableView reloadData];
        
    }
    
}

#pragma mark AddSpaceTaskSecondCellDelegate
-(void)addSpaceTaskSecondCellOnClickChooseSwitch:(NSString *)switchState{
    
    
//    _currentSelectedDateIndex = @"1";
    
    _currentFirstDoTimeSwitchState = switchState; //首次执行时间 开或者关
    
    if([switchState isEqual:@"0"]){
        //  关闭
//        [self onClickCancel];
        
    }else if ([switchState isEqual:@"1"]){
        
        //打开 弹出框
        
    }
    
}

//结合
-(void)addSpaceTaskSecondCellCombineOnClickChooseSwitch:(NSString *)switchState{
    
//    _currentSelectedDateIndex = @"2";
    
    _currentCombineState = switchState; //开或者关
    
    if([switchState isEqual:@"0"]){
        //  关闭
//        [self onClickCancel];
        
    }else if ([switchState isEqual:@"1"]){
    
    }
    
}

-(void)addSpaceTaskSecondCellRepateOnClickChooseSwitch:(NSString *)switchState{
    
//    _currentSelectedDateIndex = @"3";
    
    _currentRepeatState = switchState; //开或者关
    
    if([switchState isEqual:@"0"]){
        //  关闭
//        [self onClickCancel];
    }else if ([switchState isEqual:@"1"]){
        
    }
    
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
                
                [self showSuccessOrFailedMessage:@"请输入持续天数"];
            }
            
        }
        
    }else if (alertView.tag == 10086){
        
        //结合
        if(buttonIndex == 0){
            
            _isEnableCombine = NO;
            
        }else{
            
            _isEnableCombine = YES;
            
        }
        
        [_tableView reloadData];
        
    }else if (alertView.tag == 10010){
        
        //重复
        
        if(buttonIndex == 0){
            
            _isEnableRepeat = NO;
            
        }else{
            
            _isEnableRepeat = YES;
            
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
    
    if(_CurrentSelectedContextualModelID && ![_CurrentSelectedContextualModelID isEqual:@""]){
        [paramDic setObject:_CurrentSelectedContextualModelID forKey:@"switchIndex"];
    }else{
        
        if(errorNum == 0){
            [self showSuccessOrFailedMessage:@"请选择情景"];
            errorNum++;
        }
        
    }
    
    [paramDic setObject:@"2" forKey:@"type"];
    
    if(_currentGetFirstDoTime && ![_currentGetFirstDoTime isEqual:@""]){
        
        //首次执行日期的字符串
        [paramDic setObject:_currentGetFirstDoTime forKey:@"executionDate"];
        
    }else{
        
        if(errorNum == 0){
            [self showSuccessOrFailedMessage:@"请输入日期"];
        }
        
        errorNum ++;
    }
    
    
    /* 
     
     action1:对应首次执行是否打开
     
     action2:结合时间是否打开
     
     */
    
    
    /*
     
     action1 对应首次执行开关 开或者关
     action2 对应结合执行开关 开或者关
     
     */
    
    //首次执行时间 开或者关
    [paramDic setObject:_currentFirstDoTimeSwitchState forKey:@"action1"];
    
    
    
    
    //首次执行时间
    if(_firstDoDateDic){
        [paramDic setObject:[Utility changeTianShiFenMiaoToHaoMiao:@"0" withShi:[_firstDoDateDic objectForKey:@"hour"] withFen:[_firstDoDateDic objectForKey:@"min"] withMiao:[_firstDoDateDic objectForKey:@"sec"]] forKey:@"executionTs1"]; //首次执行开关的 时分秒的毫秒数
    }else{
        
        if(errorNum == 0){
            [self showSuccessOrFailedMessage:@"请输入日期"];
        }
        
        errorNum ++;
    }

    if(_isEnableCombine){
        
        //激活结合执行开关
        [paramDic setObject:_currentCombineState forKey:@"action2"];
        
        if(_combineDateDic){
            
            [paramDic setObject:[Utility changeTianShiFenMiaoToHaoMiao:_combineDay withShi:[_combineDateDic objectForKey:@"hour"] withFen:[_combineDateDic objectForKey:@"min"] withMiao:[_combineDateDic objectForKey:@"sec"]] forKey:@"executionTs2"]; //天时分秒的毫秒数
        }else{
            
            if(errorNum == 0){
                [self showSuccessOrFailedMessage:@"请输入时间"];
            }
            
            errorNum ++;
        }
        
    }
    
    
    if(_isEnableRepeat){
        
        if(_repeatDateDic){
            
            [paramDic setObject:[Utility changeTianShiFenMiaoToHaoMiao:_repeateDay withShi:[_repeatDateDic objectForKey:@"hour"] withFen:[_repeatDateDic objectForKey:@"min"] withMiao:[_repeatDateDic objectForKey:@"sec"]] forKey:@"period"]; //循环周期
        }else{
            
            if(errorNum == 0){
                [self showSuccessOrFailedMessage:@"请输入周期"];
            }
            
            errorNum ++;
            
        }
    }
    
    if(errorNum == 0){
        
        [[RequestService defaultRequestService] asyncPostDataWithURL:SaveContexualSpacingTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
            
            if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                [self showSuccessOrFailedMessage:@"保存间隔任务成功"];
                
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
