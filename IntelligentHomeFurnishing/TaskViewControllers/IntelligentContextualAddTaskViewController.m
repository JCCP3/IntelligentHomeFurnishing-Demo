//
//  IntelligentContextualAddTaskViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/2.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntelligentContextualAddTaskViewController.h"
#import "Utility.h"

@interface IntelligentContextualAddTaskViewController ()

@end

@implementation IntelligentContextualAddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    [self layoutIntelligentContextualAddTaskView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    
    //根据HomeID获取所有情景
    [self loadAllContextualModelByHomeID];
    
    if(_taskInfoID && ![_taskInfoID isEqual:@""]){
        
        //加载得到任务详情
        [self loadTaskInfoData];
    }else{
        
        //当前是添加
        //默认开关都关闭 添加的时候
        _currentSunUpSwithState = @"0";
        _currentSunDownSwitchState = @"0";
        _currentSunDownDelay = @"";
        _currentSunUpDelay = @"";
        
    }
}

-(void)loadTaskInfoData{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_taskInfoID forKey:@"taskId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:GetCurrentTaskInfo paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if([responseDic objectForKey:@"data"] && ![[responseDic objectForKey:@"data"] isEqual:@""]){
                
                NSMutableDictionary *tempDic = [responseDic objectForKey:@"data"];
                
                _currentTaskInfo = [[TaskInfo alloc] init];
                [_currentTaskInfo setTaskInfoWithDataDic:tempDic];
                
                
                //得到对应任务对象详情
                
                
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
                
                
                
            }
            
        }
        
        [_tableView reloadData];
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
    
}

-(void)layoutIntelligentContextualAddTaskView{
    
    _aryContextualModelData = [[NSMutableArray alloc] init];
    
    [_addBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_addBtn.bounds.size.width, _addBtn.frame.origin.y, _addBtn.bounds.size.width, _addBtn.bounds.size.height)];
    
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
        
        [cell loadAddTaskFirstCell:_currentSelectedContextualModel withShowLabel:@"选择情景"];
        
        return cell;
        
    }else if(indexPath.row == 1){
        
        static NSString *cellIdentifier = @"AddTaskSecondCell";
        
        AddTaskSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            
            cell = [[AddTaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.delegate = self;
        [cell loadAddTaskSecondCell:@"日出时间" withSwitch:_currentSunUpSwithState withDelayInfo:_currentSunUpDelay withActiveState:_isEnableSunUp];
        
        return cell;
        
    }else if(indexPath.row == 2){
        
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
        return 60.f;
    }else{
        return 44.f;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 1){
        
        if(!_isEnableSunUp){
            //日出时间
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否激活日出时间" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"日落推迟" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 2000;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *sunDownTextField = [alertView textFieldAtIndex:0];
            sunDownTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            sunDownTextField.placeholder = @"提前请输入负数";
            [alertView show];
        }
    }
    
}

#pragma mark AddTaskFirstCellDelegate
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


#pragma mark AddTaskSecondCellDelegate

/* 选择开关 仅仅为了表示打开或者关闭 */
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
            _currentSunUpSwithState = switchState;
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
            
            //日出
            UITextField *sunUpTextField = [alertView textFieldAtIndex:0];
            
            if(![sunUpTextField.text isEqual:@""]){
                
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
        
        //是否激活日luo操作
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
    
    if([APPDELEGATE user].userHomeID && ![[APPDELEGATE user].userHomeID isEqual:@""]){
        [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
    }
    
    if(_CurrentSelectedContextualModelID && ![_CurrentSelectedContextualModelID isEqual:@""]){
        //情景模式ID
        [paramDic setObject:_CurrentSelectedContextualModelID forKey:@"modelId"];
    }else{
        
        if(errorNum == 0){
            [self showSuccessOrFailedMessage:@"请选择情景模式"];
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
            
            [paramDic setObject:_currentSunUpDelay forKey:@"closedDelayMinutes"]; //日出操作提前分钟数

        }else if([_currentSunUpSwithState isEqual:@"0"]){
            
            //开关关闭操作
            if([_currentSunUpDelay intValue]<0){
                [paramDic setObject:@"-1" forKey:@"closedDelay"];
            }else{
                [paramDic setObject:@"1" forKey:@"closedDelay"];
            }
            
            [paramDic setObject:@"0" forKey:@"closedFromRaiseOrSet"]; //日出操作关闭
            
            [paramDic setObject:_currentSunUpDelay forKey:@"closedDelayMinutes"]; //日出操作提前分钟数
            
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
            
            [paramDic setObject:_currentSunDownDelay forKey:@"openedDelayMinutes"];
            
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
        
        [[RequestService defaultRequestService] asyncPostDataWithURL:SaveContexualSunTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
            
            if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                [self showSuccessOrFailedMessage:@"保存情景模式成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        } errorBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
        
    }

}


@end
