//
//  ContextualModelEditViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/12.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "ContextualModelEditViewController.h"
#import "NSString+SBJSON.h"
#import "Utility.h"

@interface ContextualModelEditViewController ()

@end

@implementation ContextualModelEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    
    _aryOpenData = [[NSMutableArray alloc] init];
    _aryCloseData = [[NSMutableArray alloc] init];
    _aryContextualModelType = [[NSMutableArray alloc] init];
    _aryContextualModelType = [[NSMutableArray alloc] initWithObjects:@"水类型一",@"水类型二",@"水类型三",@"电类型一",@"电类型二",@"电类型三",@"其他类型一",@"其他类型二",@"其他类型三", nil];
    
    _contextualModelTypeTextField.enabled = NO;
    
    
    [_submitBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_submitBtn.bounds.size.width, _submitBtn.frame.origin.y, _submitBtn.bounds.size.width, _submitBtn.bounds.size.height)];
    
    [_contextualModelNameTextField setFrame:CGRectMake(_contextualModelNameTextField.frame.origin.x, _contextualModelNameTextField.frame.origin.y, DEVICE_AVALIABLE_WIDTH-20-_contextualModelNameTextField.frame.origin.x, _contextualModelNameTextField.bounds.size.height)];
    
    
    [_contextualModelDescTextView setFrame:CGRectMake(_contextualModelDescTextView.frame.origin.x, _contextualModelDescTextView.frame.origin.y, DEVICE_AVALIABLE_WIDTH-20-_contextualModelDescTextView.frame.origin.x, _contextualModelDescTextView.bounds.size.height)];
    _contextualModelDescTextView.delegate = self;
    _contextualModelDescTextView.layer.borderColor = [Utility colorWithHexString:@"#bdbdbd"].CGColor;
    _contextualModelDescTextView.layer.borderWidth = 1;
    
    [_contextualModelTypeTextField setFrame:CGRectMake(_contextualModelTypeTextField.frame.origin.x, _contextualModelTypeTextField.frame.origin.y, DEVICE_AVALIABLE_WIDTH-20-_contextualModelTypeTextField.frame.origin.x, _contextualModelTypeTextField.bounds.size.height)];
    
    [_contextualModelTypeBtn setFrame:CGRectMake(_contextualModelTypeBtn.frame.origin.x, _contextualModelTypeBtn.frame.origin.y, DEVICE_AVALIABLE_WIDTH-20-_contextualModelTypeBtn.frame.origin.x, _contextualModelTypeBtn.bounds.size.height)];
    
    _currentSelectedType = 0;
    
    [_footerView setFrame:CGRectMake(0, 0, DEVICE_AVALIABLE_WIDTH, _footerView.bounds.size.height)];
    _tableView.tableHeaderView = _footerView;
    
//    [_placeHoldLabel setFrame:CGRectMake(0, 0, 100, 21.f)];
//    _placeHoldLabel.text = @"请输入描述文字";
//    _placeHoldLabel.textColor = [UIColor lightGrayColor];
//    _placeHoldLabel.font = [UIFont systemFontOfSize:13.f];
//    [_contextualModelDescTextView addSubview:_placeHoldLabel];
    
    //获取所有开关列表
    [self loadMyHomeIntegratedDevices];
    
    
    
}


//获取所有开关列表
-(void)loadMyHomeIntegratedDevices{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:UserHome paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *secondTempArray = [[NSMutableArray alloc] init];
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            //所有开关列表
            for (int i=0; i<[[[responseDic objectForKey:@"switchList"] JSONValue] count]; i++) {
                
                NSMutableDictionary *tempDic = [[[responseDic objectForKey:@"switchList"] JSONValue] objectAtIndex:i];
                
                SwitchInfo *switchInfo = [[SwitchInfo alloc] init];
                
                [switchInfo setSwitchInfoWithDataDic:tempDic];
                
                if(!_contextualModel){
                    
                    //当前是添加
                    switchInfo.switchStatus = @"2";
                }
                
                [tempArray addObject:switchInfo];
            }
            
            
            
            
            
            for (int i=0; i<[[[responseDic objectForKey:@"switchList"] JSONValue] count]; i++) {
                
                NSMutableDictionary *tempDic = [[[responseDic objectForKey:@"switchList"] JSONValue] objectAtIndex:i];
                
                SwitchInfo *switchInfo1 = [[SwitchInfo alloc] init];
                
                [switchInfo1 setSwitchInfoWithDataDic:tempDic];
                
                if(!_contextualModel){
                    
                    //当前是添加
                    switchInfo1.switchStatus = @"2";
                }
                
                [secondTempArray addObject:switchInfo1];
            }
            
            
            /*  加载情景模式  */
            if(_contextualModel){
                
                //修改
                [self loadCurrentContextualModelDetail];
                
            }else{
                //保存
            }
            
            _aryOpenData = tempArray;
            _aryCloseData = secondTempArray;
            [_tableView reloadData];
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
        
    }];
}


-(void)loadCurrentContextualModelDetail{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:_contextualModel.contextualModelID forKey:@"modelId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:GetContextualModelDetail paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if([responseDic objectForKey:@"data"] && ![[responseDic objectForKey:@"data"] isEqual:@""]){
                
                _contextualModel = [[ContextualModel alloc] init];
                
                [_contextualModel setContextualModelWithDataDic:[responseDic objectForKey:@"data"]];
                
                [self layoutCurrentView];
            }
            
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
    
}

-(void)layoutCurrentView{
    
    _contextualModelNameTextField.text = _contextualModel.contextualModelName;
    
    _contextualModelDescTextView.text = _contextualModel.contextualModelDesc;
    
    //类型
    _contextualModelTypeTextField.text = [_aryContextualModelType objectAtIndex:[_contextualModel.contextualModelType intValue]-1];
    
    _currentSelectedType = [_contextualModel.contextualModelType intValue];
    
    NSMutableArray *_aryOpenJiChengQi = [[_contextualModel.contextualOpenCommand componentsSeparatedByString:@";"] mutableCopy];
    
    for (int i=0; i<[_aryOpenJiChengQi count]; i++) {
        
        NSString *jiChengQiStr = [_aryOpenJiChengQi objectAtIndex:i];
        
        NSMutableArray *_arySwitch = [[jiChengQiStr componentsSeparatedByString:@":"] mutableCopy];
        
        NSString *str = [_arySwitch objectAtIndex:0]; //集成器ID号
        
        NSString *secondStr = [_arySwitch objectAtIndex:1];
        
        NSMutableArray *_arySwitchState = [[NSMutableArray alloc] init];
        
        for (int j = 0; j<secondStr.length; j++) {
            
            NSString *subString = [secondStr substringWithRange:NSMakeRange(j, 1)];
            
            [_arySwitchState addObject:subString];
            
        }
        
        /* 灯的下角标从1开始 */
        
        for (int l=0; l<[_arySwitchState count]; l++) {
            
            NSString *currentState = [_arySwitchState objectAtIndex:l];
            
            for (int k=0; k<[_aryOpenData count]; k++) {
                
                SwitchInfo *currentSwitchInfo = [_aryOpenData objectAtIndex:k];
                
                if([currentSwitchInfo.switchIndex intValue] == l+1 && [currentSwitchInfo.switchAtCenterControllerID isEqual:str]){
                    
                    // 得到对应的Switch
                    currentSwitchInfo.switchStatus = currentState;
                    
                }
                
            }
            
        }
        
    }
    
    
    /*  关闭操作  */
    
    NSMutableArray *_aryCloseJiChengQi = [[_contextualModel.contextualCloseCommand componentsSeparatedByString:@";"] mutableCopy];
    
    for (int i=0; i<[_aryCloseJiChengQi count]; i++) {
        
        NSString *jiChengQiStr = [_aryOpenJiChengQi objectAtIndex:i];
        
        NSMutableArray *_arySwitch = [[jiChengQiStr componentsSeparatedByString:@":"] mutableCopy];
        
        NSString *str = [_arySwitch objectAtIndex:0]; //集成器ID号
        
        NSString *secondStr = [_arySwitch objectAtIndex:1];
        
        NSMutableArray *_arySwitchState = [[NSMutableArray alloc] init];
        
        for (int j = 0; j<secondStr.length; j++) {
            
            NSString *subString = [secondStr substringWithRange:NSMakeRange(j, 1)];
            
            [_arySwitchState addObject:subString];
            
        }
        
        for (int l=0; l<[_arySwitchState count]; l++) {
            
            NSString *currentState = [_arySwitchState objectAtIndex:l];
            
            for (int k=0; k<[_aryCloseData count]; k++) {
                
                SwitchInfo *currentSwitchInfo = [_aryCloseData objectAtIndex:k];
                
                if([currentSwitchInfo.switchIndex intValue] == l+1 && [currentSwitchInfo.switchAtCenterControllerID isEqual:str]){
                    
                    // 得到对应的Switch
                    currentSwitchInfo.switchStatus = currentState;
                    
                }
                
            }
            
        }
        
    }

    
     [_tableView reloadData];
}

-(void)onClickResignFirstResponder{
    
    [_contextualModelNameTextField resignFirstResponder];
    
    [_contextualModelDescTextView resignFirstResponder];
    
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isOpen){
        if(_selectIndex.section == section){
            //当前选中某一个section则展开
            if(section == 0){
                //打开情景模式操作
                return [_aryOpenData count]+1;
            }else{
                //关闭情景模式操作
                return [_aryCloseData count]+1;
            }
        }
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_isOpen && _selectIndex.section == indexPath.section && indexPath.row!=0){
        
        if(indexPath.section == 0){
            
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, DEVICE_AVALIABLE_WIDTH, 1)];
                [label setBackgroundColor:[UIColor colorWithRed:222.f/255.f green:222.f/255.f blue:222.f/255.f alpha:1]];
                [cell addSubview:label];
            }
            cell.backgroundColor = [UIColor whiteColor];
            
            SwitchInfo *switchInfo;
            
            if(indexPath.section == 0)
            {
                switchInfo = [_aryOpenData objectAtIndex:indexPath.row-1];
            }else if (indexPath.section == 1){
                switchInfo = [_aryCloseData objectAtIndex:indexPath.row-1];
            }
            
            cell.textLabel.text = switchInfo.switchName;
            
            if(switchInfo.switchStatus && ![switchInfo.switchStatus isEqual:@""]){
                
                switch ([switchInfo.switchStatus intValue]) {
                        
                    case 1:
                        cell.detailTextLabel.text = @"打开";
                        break;
                        
                    case 0:
                        cell.detailTextLabel.text = @"关闭";
                        break;
                        
                    case 2:
                        cell.detailTextLabel.text = @"无操作";
                        break;
                        
                    default:
                        break;
                        
                }
                
            }else{
                cell.detailTextLabel.text = @"无操作";
            }
            
            return cell;

            
        }else if (indexPath.section == 1){
            
            
            static NSString *cellIdentifier = @"Cell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, DEVICE_AVALIABLE_WIDTH, 1)];
                [label setBackgroundColor:[UIColor colorWithRed:222.f/255.f green:222.f/255.f blue:222.f/255.f alpha:1]];
                [cell addSubview:label];
            }
            cell.backgroundColor = [UIColor whiteColor];
            
            SwitchInfo *switchInfo;
            
            if(indexPath.section == 0)
            {
                switchInfo = [_aryOpenData objectAtIndex:indexPath.row-1];
            }else if (indexPath.section == 1){
                switchInfo = [_aryCloseData objectAtIndex:indexPath.row-1];
            }
            
            cell.textLabel.text = switchInfo.switchName;
            
            if(switchInfo.switchStatus && ![switchInfo.switchStatus isEqual:@""]){
                
                switch ([switchInfo.switchStatus intValue]) {
                        
                    case 1:
                        cell.detailTextLabel.text = @"打开";
                        break;
                        
                    case 0:
                        cell.detailTextLabel.text = @"关闭";
                        break;
                        
                    case 2:
                        cell.detailTextLabel.text = @"无操作";
                        break;
                        
                    default:
                        break;
                        
                }
                
            }else{
                cell.detailTextLabel.text = @"无操作";
            }
            
            return cell;

            
        }
        
        
    }else{
        
        //第一行显示头部
        static NSString *cellIdentifier = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];
        
        if(indexPath.section == 0){
            cell.textLabel.text = @"情景模式打开操作";
        }else{
            cell.textLabel.text = @"情景模式关闭操作";
        }
        cell.textLabel.textColor = [Utility colorWithHexString:@"#333333"];
        return cell;
    }
    
    
    return nil;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self onClickResignFirstResponder];
    
    if(indexPath.row == 0){
        //选中第一行
        if([indexPath isEqual:_selectIndex]){
            _isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            _selectIndex = nil;
        }else{
            //点击选中
            if(!_selectIndex){
                _selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
            }else{
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
    }else{
        
        if(indexPath.section == 0){
            _currentSelectedSwitchInfo = [_aryOpenData objectAtIndex:indexPath.row-1];
        }else{
            _currentSelectedSwitchInfo = [_aryCloseData objectAtIndex:indexPath.row-1];
        }
        
        
        //选中其中某一行
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择开关操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = 1000;
        [actionSheet addButtonWithTitle:@"打开"];
        [actionSheet addButtonWithTitle:@"关闭"];
        [actionSheet addButtonWithTitle:@"无操作"];
        [actionSheet showInView:self.view];
        
    }
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    
    self.isOpen = firstDoInsert;
    
    //    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:self.selectIndex];
    //
    ////    [cell changeArrowWithUp:firstDoInsert];
    
    [_tableView beginUpdates];
    
    int section = self.selectIndex.section;
    
    int contentCount;
    
    if(section == 0){
        SwitchInfo *switchInfo = [_aryOpenData objectAtIndex:section];
        contentCount = (int)[_aryOpenData count];
    }else if (section == 1){
        SwitchInfo *switchInfo = [_aryCloseData objectAtIndex:section];
        contentCount = (int)[_aryCloseData count];
    }
    
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }

    
    if (firstDoInsert)
    {   [_tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [_tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    
    
    [_tableView endUpdates];
    
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [_tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    
    if (self.isOpen) {
        [_tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}



- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickSubmit:(id)sender {
    
    int error = 0;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if(_contextualModel){
        [paramDic setObject:_contextualModel.contextualModelID forKey:@"id"];
    }else{
        [paramDic setObject:@"-1" forKey:@"id"];
    }
    
    if(_contextualModelNameTextField.text && ![_contextualModelNameTextField.text isEqual:@""]){
        [paramDic setObject:_contextualModelNameTextField.text forKey:@"name"];
    }else{
        
        if(error == 0){
            [self showSuccessOrFailedMessage:@"请输入情景模式名称"];
        }
        
        error ++;
    }
    
    if(_contextualModelDescTextView.text && ![_contextualModelDescTextView.text isEqual:@""]){
        [paramDic setObject:_contextualModelDescTextView.text forKey:@"description"];
    }else{
        
        if(error == 0){
            [self showSuccessOrFailedMessage:@"请输入情景模式描述"];
        }
        
        error ++;
    }
    
    if(_currentSelectedType && _currentSelectedType != 0){
        [paramDic setObject:[NSString stringWithFormat:@"%d",_currentSelectedType] forKey:@"type"];
    }else{
        if(error == 0){
            [self showSuccessOrFailedMessage:@"请选择情景模式类型"];
        }
        
        error ++;
    }
    
    
    
//    /*  获取集中器个数  */
//    NSString *firstCommand = @"";
//    
//    SwitchInfo *firstSwitchInfo = [_aryOpenData objectAtIndex:0];
//    
//    firstCommand = firstSwitchInfo.switchAtCenterControllerID;
//    
//    int count = 1;
//    
//    for (int i=0; i<[_aryOpenData count]; i++) {
//        
//        SwitchInfo *switchInfo = [_aryOpenData objectAtIndex:i];
//        
//        if(![switchInfo.switchAtCenterControllerID isEqual:firstCommand]){
//            
//            count++; //有第二个不同的则＋1
//            
//            firstCommand = switchInfo.switchAtCenterControllerID;
//            
//        }
//        
//    }
//    
    
    
    
    
    /*  count 即为集中器个数  */
    
    NSString *bossString = @"";
    
    SwitchInfo *firstSwitchInfo1 = [_aryOpenData objectAtIndex:0];
    
    NSString *firstCommand1 = firstSwitchInfo1.switchAtCenterControllerID;
    NSString *firstCommand2 = firstSwitchInfo1.switchAtCenterControllerID;

    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:@"2",@"2",@"2",@"2", @"2",@"2",@"2",@"2",nil];
    
     NSString *_currentSwitchCenter = @"";
    
    for (int i=0; i<[_aryOpenData count]; i++) {
        
        SwitchInfo *switchInfo = [_aryOpenData objectAtIndex:i];
        
        if(![switchInfo.switchAtCenterControllerID isEqual:firstCommand1]){
            
            firstCommand1 = switchInfo.switchAtCenterControllerID; //得到新版集中器ID
            
            //换代
            for (int j=0; j<[tempArray count]; j++) {
                
                bossString = [bossString stringByAppendingString:[tempArray objectAtIndex:j]];
                
            }
            
            bossString = [NSString stringWithFormat:@"%@:%@",_currentSwitchCenter,bossString];
            
            tempArray = [[NSMutableArray alloc] initWithObjects:@"2",@"2",@"2",@"2", @"2",@"2",@"2",@"2",nil];
            
            //设置当前第一个不同的集中器
            [tempArray setObject:switchInfo.switchStatus atIndexedSubscript:[switchInfo.switchIndex intValue]-1];
            
        }else{
            
            _currentSwitchCenter = firstCommand1;
            
            if(i==[_aryOpenData count]-1){
                
                /* 假若当前只有一个集中器 */
                SwitchInfo *lastSwitchInfo = [_aryOpenData objectAtIndex:[_aryOpenData count]-1];
                
                if([lastSwitchInfo.switchAtCenterControllerID isEqual:firstCommand2]){
                    
                    //最后一个和第一个相同
                    [tempArray setObject:lastSwitchInfo.switchStatus atIndexedSubscript:[lastSwitchInfo.switchIndex intValue]-1];
                    
                }else{
                    
                    //最后一个集中器
                    [tempArray setObject:switchInfo.switchStatus atIndexedSubscript:[switchInfo.switchIndex intValue]-1];
                    
                    bossString = [bossString stringByAppendingString:[NSString stringWithFormat:@";%@:",_currentSwitchCenter]];
                    
                    //最后一个
                    //换代
                    for (int k=0; k<[tempArray count]; k++) {
                        
                        bossString = [bossString stringByAppendingString:[tempArray objectAtIndex:k]];
                        
                    }
                    
                    
                    
                    tempArray = [[NSMutableArray alloc] initWithObjects:@"2",@"2",@"2",@"2", @"2",@"2",@"2",@"2",nil];
                    
                }
            
                
            }else{
                
                // 替换
                [tempArray setObject:switchInfo.switchStatus atIndexedSubscript:[switchInfo.switchIndex intValue]-1];
                

            }
            
        }
        
    }
    
    
    NSLog(@"%@",bossString);
    
    
    
    
    /* 情景模式关闭命令  */
    
    NSString *bossCloseString = @"";
    
    SwitchInfo *firstSwitchInfo2 = [_aryCloseData objectAtIndex:0];
    
    NSString *firstCommand3 = firstSwitchInfo2.switchAtCenterControllerID;
    NSString *firstCommand4 = firstSwitchInfo2.switchAtCenterControllerID;
    
    
    NSMutableArray *tempArray1 = [[NSMutableArray alloc] initWithObjects:@"2",@"2",@"2",@"2", @"2",@"2",@"2",@"2",nil];
    
    NSString *_currentSwitchCenter1 = @"";
    
    for (int i=0; i<[_aryCloseData count]; i++) {
        
        SwitchInfo *switchInfo = [_aryCloseData objectAtIndex:i];
        
        if(![switchInfo.switchAtCenterControllerID isEqual:firstCommand3]){
            
            firstCommand3 = switchInfo.switchAtCenterControllerID;
            
            //换代
            for (int j=0; j<[tempArray1 count]; j++) {
                
                bossCloseString = [bossCloseString stringByAppendingString:[tempArray1 objectAtIndex:j]];
                
            }
            
            bossCloseString = [NSString stringWithFormat:@"%@:%@",_currentSwitchCenter1,bossCloseString];
            
            tempArray1 = [[NSMutableArray alloc] initWithObjects:@"2",@"2",@"2",@"2", @"2",@"2",@"2",@"2",nil];
            
            //设置当前第一个不同的集中器
            [tempArray1 setObject:switchInfo.switchStatus atIndexedSubscript:[switchInfo.switchIndex intValue]-1];
            
        }else{
            
            _currentSwitchCenter1 = firstCommand3;
            
            if(i==[_aryCloseData count]-1){
                
                /* 假若当前只有一个集中器 */
                SwitchInfo *lastSwitchInfo = [_aryCloseData objectAtIndex:[_aryCloseData count]-1];
                
                if([lastSwitchInfo.switchAtCenterControllerID isEqual:firstCommand4]){
                    
                    //最后一个和第一个相同
                    [tempArray1 setObject:lastSwitchInfo.switchStatus atIndexedSubscript:[lastSwitchInfo.switchIndex intValue]-1];
                    
                }else{
                    
                    [tempArray1 setObject:switchInfo.switchStatus atIndexedSubscript:[switchInfo.switchIndex intValue]-1];
                    
                    bossCloseString = [bossCloseString stringByAppendingString:[NSString stringWithFormat:@";%@:",_currentSwitchCenter1]];
                    
                    //最后一个
                    //换代
                    for (int k=0; k<[tempArray1 count]; k++) {
                        
                        bossCloseString = [bossCloseString stringByAppendingString:[tempArray1 objectAtIndex:k]];
                        
                    }
                    
                    
                    
                    tempArray1 = [[NSMutableArray alloc] initWithObjects:@"2",@"2",@"2",@"2", @"2",@"2",@"2",@"2",nil];
                    
                }
                
                
            }else{
                
                // 替换
                [tempArray1 setObject:switchInfo.switchStatus atIndexedSubscript:[switchInfo.switchIndex intValue]-1];
                
                
            }
            
        }
        
    }
    
    
    NSLog(@"%@",bossCloseString);


    
    if(error == 0){
        
        
        //情景模式打开 关闭命令
        [paramDic setObject:bossString forKey:@"openCommand"];
        [paramDic setObject:bossCloseString forKey:@"closeCommand"];
        [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
        
        
        [[RequestService defaultRequestService] asyncPostDataWithURL:SaveUpdateContextualModel paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
            
            if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                //添加情景模式成功
                [self showSuccessOrFailedMessage:@"添加情景模式成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        } errorBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
    }

    
    
}


- (IBAction)onClickChooseType:(id)sender {
    
    [self onClickResignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择情景模式类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    for(int i=0;i<[_aryContextualModelType count];i++){
        
        [actionSheet addButtonWithTitle:[_aryContextualModelType objectAtIndex:i]];
        
    }
    
    actionSheet.tag = 2000;
    [actionSheet showInView:self.view];
    
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == 1000){
        
        if(buttonIndex == 0){
            
            //取消
            
        }else if (buttonIndex == 1){
            
            //打开
            _currentSelectedSwitchInfo.switchStatus = @"1";
            
        }else if(buttonIndex == 2){
            
            //关闭
            _currentSelectedSwitchInfo.switchStatus = @"0";
            
        }else if (buttonIndex == 3){
            
            //无操作
            _currentSelectedSwitchInfo.switchStatus = @"2";
            
        }
        
        [_tableView reloadData];

    }else if (actionSheet.tag == 2000){
        
        //选择类型
        
        if(buttonIndex != 0){
            
            NSString *type = [_aryContextualModelType objectAtIndex:buttonIndex-1];
            
            _contextualModelTypeTextField.text = type;
            
            _currentSelectedType = (int)buttonIndex;
            
            /* 出现一闪而过的图片 */
            if(buttonIndex == 1 || buttonIndex== 2 || buttonIndex == 3){
                
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH/2-93/2, DEVICE_AVALIABLE_HEIGHT/2-117/2, 93, 117.f)];
                
                [imageView setImage:[UIImage imageNamed:@"水开关"]];
            
                [self.view addSubview:imageView];
                
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
                
            }else if (buttonIndex == 4 || buttonIndex == 5 || buttonIndex == 6){
                
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH/2-93/2, DEVICE_AVALIABLE_HEIGHT/2-117/2, 93, 117.f)];
                
                [imageView setImage:[UIImage imageNamed:@"电开关"]];
                
                [self.view addSubview:imageView];
                
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
                
                
            }else if (buttonIndex == 7 || buttonIndex == 8 || buttonIndex == 9){
                
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH/2-93/2, DEVICE_AVALIABLE_HEIGHT/2-117/2, 93, 117.f)];
                
                [imageView setImage:[UIImage imageNamed:@"其他"]];
                
                [self.view addSubview:imageView];
                
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
                
            }else{
                
            }

            
        }
        
    }
    
}

-(void)delayMethod{
    
    [imageView removeFromSuperview];
}

#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
   
    if (textView.text.length == 0) {
        _placeHoldLabel.text = @"请填写情景模式描述";
    }else{
        _placeHoldLabel.text = @"";
    }
    
}


@end
