//
//  IntelligentTaskViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntelligentTaskViewController.h"
#import "Utility.h"
#import "RequestService.h"
#import "IntegratedDeviceInfo.h"
#import "TaskInfo.h"

@interface IntelligentTaskViewController (){
    
    IntegratedDeviceInfo *_currentSelectedDeviceInfo ;
    
}

@end

@implementation IntelligentTaskViewController

- (void)viewDidLoad {
   
   [super viewDidLoad];
   
   //适配
   [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
   
   _aryData = [[NSMutableArray alloc] init];
   _aryTaskData = [[NSMutableArray alloc] init];
   _aryContextualTaskData = [[NSMutableArray alloc] init];
   _aryControlList = [[NSMutableArray alloc] init];
   _aryTaskList = [[NSMutableArray alloc] init];
   _arySwitchData = [[NSMutableArray alloc] init];
   _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT - 64.f -52.f)];
   _tableView.delegate = self;
   _tableView.dataSource = self;
   _tableView.sectionFooterHeight = 0;
   _tableView.sectionHeaderHeight = 0;
   _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   [self.view addSubview:_tableView];
   
   
   [_segment setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH/2-_segment.bounds.size.width/2, _segment.frame.origin.y, _segment.bounds.size.width, _segment.bounds.size.height)];
    [_addBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_addBtn.bounds.size.width, _addBtn.frame.origin.y, _addBtn.bounds.size.width, _addBtn.bounds.size.height)];
   
    _isOpen = NO;
   
    [_addBtn setHidden:YES];
    
   
   
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    UILabel *label = (UILabel *)[_tabBarView viewWithTag:201];
    [label setTextColor:[UIColor orangeColor]];
    
    UIImageView *imageView = (UIImageView *)[_tabBarView viewWithTag:301];
    [imageView setImage:[UIImage imageNamed:@"任务选中"]];
   
   
   [self showLoadingMessage:@"加载中..."];
   
   //加载集成器列表
//   [self loadMyHomeAllIntegratedDevice];
   
   //加载集成器列表对应的所有的任务列表
   [self loadAllControlAllTask];
   
   
   
   [_tableView reloadData];
   
   if(_segment.selectedSegmentIndex == 0){
      
      if(_currentSelectedDeviceInfo && ![_currentSelectedDeviceInfo isEqual:@""]){
         [self loadAllTaskByDeviceID];
      }
      
   }else{
      
      //加载情景模式下任务
      [self loadAllContextualTaskByHomeID];
      
   }
   
}




-(void)loadAllControlAllTask{
   
   NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
   
   if([APPDELEGATE user].userHomeID && ![[APPDELEGATE user].userHomeID isEqual:@""]){
      [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
   }
   
   [[RequestService defaultRequestService] asyncGetDataWithURL:GetControlAllTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
      
      NSMutableArray *currentTempArray = [[NSMutableArray alloc] init];
      
      if([[responseDic objectForKey:@"status"] intValue] == 1){
         
         
         /* 集成器列表 */
         if([responseDic objectForKey:@"ccList"] && ![[responseDic objectForKey:@"ccList"] isEqual:@""] && ![[responseDic objectForKey:@"ccList"] isKindOfClass:[NSNull class]] && [[responseDic objectForKey:@"ccList"] count]>0){
            
            NSMutableArray *tempArray = [responseDic objectForKey:@"ccList"];
            
            for (int i=0; i<[tempArray count]; i++){
               
               NSMutableDictionary *tempDic = [tempArray objectAtIndex:i];
               
               IntegratedDeviceInfo *deviceInfo = [[IntegratedDeviceInfo alloc] init];
               [deviceInfo setIntegratedDeviceWithDataDic:tempDic];
               [currentTempArray addObject:deviceInfo];
               
            }
            
            _aryControlList = currentTempArray;
            
         }
         
         
         /* 集成器对应所有任务列表 */
         if([responseDic objectForKey:@"ccTaskList"] && ![[responseDic objectForKey:@"ccTaskList"] isEqual:@""] && ![[responseDic objectForKey:@"ccTaskList"] isKindOfClass:[NSNull class]]){
            
            _taskWithControlDic = [responseDic objectForKey:@"ccTaskList"];
            
         }
         
         [_tableView reloadData];
      }
      
      [self removeLoadingMessage];
      
   } errorBlock:^(NSString *errorMessage) {
      NSLog(@"%@",errorMessage);
      [self removeLoadingMessage];
   }];
   
   
}


-(void)loadMyHomeAllIntegratedDevice{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:UserTaskAllIntegratedDevices paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        NSMutableArray *currentTempArray = [[NSMutableArray alloc] init];
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if([responseDic objectForKey:@"data"] && ![[responseDic objectForKey:@"data"] isEqual:@""] && ![[responseDic objectForKey:@"data"] isKindOfClass:[NSNull class]] && [[responseDic objectForKey:@"data"] count]>0){
                
                NSMutableArray *tempArray = [responseDic objectForKey:@"data"];
                
                for (int i=0; i<[tempArray count]; i++) {
                    
                    NSMutableDictionary *tempDic = [tempArray objectAtIndex:i];
                    
                    IntegratedDeviceInfo *deviceInfo = [[IntegratedDeviceInfo alloc] init];
                    [deviceInfo setIntegratedDeviceWithDataDic:tempDic];
                    [currentTempArray addObject:deviceInfo];
                }
                
                _aryData = currentTempArray;
                [_tableView reloadData];
                
            }else{
               [_tableView reloadData];
            }
            
        }
       
       [_tableView reloadData];
        [self removeLoadingMessage];
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
        [self removeLoadingMessage];
       [_tableView reloadData];
    }];
    
}

//获取情景模式
-(void)loadAllContextualTaskByHomeID{
   
   NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
   [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
   
   [[RequestService defaultRequestService] asyncGetDataWithURL:GetContextualModelTaskList paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
      
      NSMutableArray *currentTempArray = [[NSMutableArray alloc] init];
      
      if([[responseDic objectForKey:@"status"] intValue] == 1){
         
         if([responseDic objectForKey:@"data"] && ![[responseDic objectForKey:@"data"] isEqual:@""] && ![[responseDic objectForKey:@"data"] isKindOfClass:[NSNull class]] && [[responseDic objectForKey:@"data"] count]>0){
            
            NSMutableArray *tempArray = [responseDic objectForKey:@"data"];
            
            for (int i=0; i<[tempArray count]; i++) {
               
               NSMutableDictionary *tempDic = [tempArray objectAtIndex:i];
               
               TaskInfo *taskInfo = [[TaskInfo alloc] init];
               
               [taskInfo setTaskInfoWithDataDic:tempDic];
               
               [currentTempArray addObject:taskInfo];
               
            }
            
            _aryContextualTaskData = currentTempArray;
            
            
            
         }else{
            
            
         }
   
      }
      
      [_tableView reloadData];
      
   } errorBlock:^(NSString *errorMessage) {
      NSLog(@"%@",errorMessage);
      [_tableView reloadData];
   }];
   
}

-(void)loadAllTaskByDeviceID{
  
   //根据得到的集成器请求对应的数据
   NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
   
   [paramDic setObject:_currentSelectedDeviceInfo.integratedDeviceID forKey:@"centerControllerId"];
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
      
      
      [_tableView reloadData];
      
   } errorBlock:^(NSString *errorMessage) {
      NSLog(@"%@",errorMessage);
      
      [_tableView reloadData];
   }];

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
   if(_segment.selectedSegmentIndex == 0){
       return [_aryControlList count];
   }else{
       return 1;
   }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
 
   
   if(_segment.selectedSegmentIndex == 0){
      
      if(_isOpen){
         if(_selectIndex.section == section){
            
            //当前选中某一个section则展开 得到对应section的任务
//            return [_aryTaskData count]+1;
            IntegratedDeviceInfo *deviceInfo = [_aryControlList objectAtIndex:section];
            
            if([_taskWithControlDic objectForKey:deviceInfo.integratedDeviceID] && ![[_taskWithControlDic objectForKey:deviceInfo.integratedDeviceID] isEqual:@""] && ![[_taskWithControlDic objectForKey:deviceInfo.integratedDeviceID] isKindOfClass:[NSNull class]] && [[_taskWithControlDic objectForKey:deviceInfo.integratedDeviceID] count]>0){
               
               
               return [[_taskWithControlDic objectForKey:deviceInfo.integratedDeviceID] count]+1;
            }else{
               
               return 0;
            }
           
         }
      }
      
      return 1;
      
   }else{
      
      return [_aryContextualTaskData count];
   }
    
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
   if(_segment.selectedSegmentIndex == 0){
      
      if(_isOpen && _selectIndex.section == indexPath.section && indexPath.row!=0){
         static NSString *cellIdentifier = @"Cell";
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
         if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, DEVICE_AVALIABLE_WIDTH, 1)];
            [label setBackgroundColor:[UIColor colorWithRed:222.f/255.f green:222.f/255.f blue:222.f/255.f alpha:1]];
            [cell addSubview:label];
         }
         cell.backgroundColor = [UIColor whiteColor];
         
//         TaskInfo *taskInfo = [_aryTaskData objectAtIndex:indexPath.row-1];
         IntegratedDeviceInfo *deviceInfo = [_aryControlList objectAtIndex:indexPath.section];
         
         NSMutableArray *currentArray = [_taskWithControlDic objectForKey:deviceInfo.integratedDeviceID];
         
         TaskInfo *taskInfo = [[TaskInfo alloc] init];
         
         [taskInfo setTaskInfoWithDataDic:[currentArray objectAtIndex:indexPath.row - 1]];
         
         
         NSString *taskInfoName = @"";
         
         if([taskInfo.taskType isEqual:@"1"]){
            
            if([taskInfo.taskType2 isEqual:@"2"]){
               
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(周)[%@]-%@于每周%@的",taskInfo.taskIndex,taskInfo.taskInfoID,taskInfo.taskWeek]];
               
            }else{
               
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(周)[%@]-%@于每周%@的",taskInfo.taskIndex,taskInfo.taskSwitchIndex,taskInfo.taskWeek]];
               
            }
            
            
            if(taskInfo.taskAction1 && ![taskInfo.taskAction1 isEqual:@""]){
               
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"%@打开",[Utility changeTimeNumToDate:taskInfo.taskExecutionTs1]]];
            }
            
            if(taskInfo.taskAction2 && ![taskInfo.taskAction2 isEqual:@""]){
               
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"%@关闭",[Utility changeTimeNumToDate:taskInfo.taskExecutionTs2]]];
            }
            
         }else if ([taskInfo.taskType isEqual:@"3"]){
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(太阳时)[%@]开关%@(高位在前)于",taskInfo.taskIndex,taskInfo.taskSwitchIndex]];
            
            if(taskInfo.taskAction1 && ![taskInfo.taskAction1 isEqual:@""]){
               taskInfoName = [taskInfoName stringByAppendingString:@"日出"];
               if([taskInfo.taskExecutionTs1 intValue]<0){
                  taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"前%@分钟",taskInfo.taskExecutionTs1]];
               }else{
                  taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"后%@分钟",taskInfo.taskExecutionTs1]];
               }
            }
            
            if([taskInfo.taskAction1 intValue] == 1){
               taskInfoName = [taskInfoName stringByAppendingString:@"打开"];
            }else{
               taskInfoName = [taskInfoName stringByAppendingString:@"关闭"];
            }
            
            
            if(taskInfo.taskAction2 && ![taskInfo.taskAction2 isEqual:@""]){
               taskInfoName = [taskInfoName stringByAppendingString:@"日出"];
               if([taskInfo.taskExecutionTs2 intValue]<0){
                  taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"前%@分钟",taskInfo.taskExecutionTs2]];
               }else{
                  taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"后%@分钟",taskInfo.taskExecutionTs2]];
               }
            }
            
            if([taskInfo.taskAction2 intValue] == 1){
               taskInfoName = [taskInfoName stringByAppendingString:@"打开"];
            }else{
               taskInfoName = [taskInfoName stringByAppendingString:@"关闭"];
            }
            
         }else{
            
            if([taskInfo.taskType2 isEqual:@"2"]){
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(间隔)[%@]-%@于%@%@",taskInfo.taskIndex,taskInfo.taskInfoID,[Utility changeTimeNumToDate:taskInfo.taskExecutionTs1],[taskInfo.taskAction1 intValue] == 1? @"打开": @"关闭"]];
            }else{
               
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(间隔)[%@]-%@于%@%@",taskInfo.taskIndex,taskInfo.taskSwitchIndex,[Utility changeTimeNumToDate:taskInfo.taskExecutionTs1],[taskInfo.taskAction1 intValue] == 1? @"打开": @"关闭"]];
            }
            
            if(taskInfo.taskAction2 && ![taskInfo.taskAction2 isEqual:@""]){
               
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"在%@后%@",[Utility changeTimeNumToDate:taskInfo.taskExecutionTs2],[taskInfo.taskAction2 intValue] == 1? @"打开": @"关闭"]];
               
            }
            
            if(taskInfo.taskPeriod){
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"之后间隔%@执行一次",[Utility changeTimeNumToDate:taskInfo.taskPeriod]]];
            }
            
            
         }
         
         cell.textLabel.text = taskInfoName;
         cell.textLabel.textColor = [Utility colorWithHexString:@"#8a8a8a"];
         return cell;
         
      }else{
         
         IntegratedDeviceInfo *deviceInfo = [_aryControlList objectAtIndex:indexPath.section];
         
         //第一行显示头部
         static NSString *cellIdentifier = @"Cell1";
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
         if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, DEVICE_AVALIABLE_WIDTH, 1)];
            [label setBackgroundColor:[UIColor colorWithRed:222.f/255.f green:222.f/255.f blue:222.f/255.f alpha:1]];
            [cell addSubview:label];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-20-20, 10, 40, 20)];
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [btn setTitle:@"添加" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            btn.tag = indexPath.section+1;
            [btn addTarget:self action:@selector(onClickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            
         }
         
         
         cell.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];
         cell.textLabel.text = deviceInfo.integratedDeviceName;
         cell.textLabel.textColor = [Utility colorWithHexString:@"#333333"];
         return cell;
      }

      
   }else{
      
      //情景模式
      
      static NSString *cellIdentifier = @"Cell";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if(cell == nil){
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         
      }
      
      TaskInfo *taskInfo = [_aryContextualTaskData objectAtIndex:indexPath.row];
      
      NSString *taskInfoName = @"";
      
      if([taskInfo.taskType isEqual:@"1"]){
         
         if([taskInfo.taskType2 isEqual:@"2"]){
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(周)%@-%@于每周%@的",taskInfo.taskIndex,taskInfo.taskInfoID,taskInfo.taskWeek]];
            
         }else{
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(周)%@-%@于每周%@的",taskInfo.taskIndex,taskInfo.taskSwitchIndex,taskInfo.taskWeek]];
            
         }
         
         
         if(taskInfo.taskAction1 && ![taskInfo.taskAction1 isEqual:@""]){
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"%@打开",[Utility changeTimeNumToDate:taskInfo.taskExecutionTs1]]];
         }
         
         if(taskInfo.taskAction2 && ![taskInfo.taskAction2 isEqual:@""]){
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"%@关闭",[Utility changeTimeNumToDate:taskInfo.taskExecutionTs2]]];
         }
         
      }else if ([taskInfo.taskType isEqual:@"3"]){
         
         taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(太阳时)%@开关%@(高位在前)于",taskInfo.taskIndex,@"替代"]];
         
         if(taskInfo.taskAction1 && ![taskInfo.taskAction1 isEqual:@""]){
            taskInfoName = [taskInfoName stringByAppendingString:@"日出"];
            if([taskInfo.taskExecutionTs1 intValue]<0){
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"前%@分钟",taskInfo.taskExecutionTs1]];
            }else{
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"后%@分钟",taskInfo.taskExecutionTs1]];
            }
         }
         
         if([taskInfo.taskAction1 intValue] == 1){
            taskInfoName = [taskInfoName stringByAppendingString:@"打开"];
         }else{
            taskInfoName = [taskInfoName stringByAppendingString:@"关闭"];
         }
         
         
         if(taskInfo.taskAction2 && ![taskInfo.taskAction2 isEqual:@""]){
            taskInfoName = [taskInfoName stringByAppendingString:@"日出"];
            if([taskInfo.taskExecutionTs2 intValue]<0){
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"前%@分钟",taskInfo.taskExecutionTs2]];
            }else{
               taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"后%@分钟",taskInfo.taskExecutionTs2]];
            }
         }
         
         if([taskInfo.taskAction2 intValue] == 1){
            taskInfoName = [taskInfoName stringByAppendingString:@"打开"];
         }else{
            taskInfoName = [taskInfoName stringByAppendingString:@"关闭"];
         }
         
      }else{
         
         if([taskInfo.taskType2 isEqual:@"2"]){
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(间隔)%@-%@于%@%@",taskInfo.taskIndex,taskInfo.taskInfoID,[Utility changeTimeNumToDate:taskInfo.taskExecutionTs1],[taskInfo.taskAction1 intValue] == 1? @"打开": @"关闭"]];
         }else{
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(间隔)%@-%@于%@%@",taskInfo.taskIndex,taskInfo.taskSwitchIndex,[Utility changeTimeNumToDate:taskInfo.taskExecutionTs1],[taskInfo.taskAction1 intValue] == 1? @"打开": @"关闭"]];
         }
         
         if(taskInfo.taskAction2 && ![taskInfo.taskAction2 isEqual:@""]){
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"在%@后%@",[Utility changeTimeNumToDate:taskInfo.taskExecutionTs2],[taskInfo.taskAction2 intValue] == 1? @"打开": @"关闭"]];
            
         }
         
         if(taskInfo.taskPeriod){
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"之后间隔%@执行一次",[Utility changeTimeNumToDate:taskInfo.taskPeriod]]];
         }
         
         
      }
      
      cell.textLabel.text = taskInfoName;
      
      cell.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];
      
      cell.textLabel.textColor = [Utility colorWithHexString:@"#333333"];
      return cell;

      
   }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   if(_segment.selectedSegmentIndex == 0){
      
      if(indexPath.row == 0){
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
         
         IntegratedDeviceInfo *deviceInfo = [_aryControlList objectAtIndex:indexPath.section];
         
         NSMutableArray *currentArray = [_taskWithControlDic objectForKey:deviceInfo.integratedDeviceID];
         
         NSMutableDictionary *tempDic = [currentArray objectAtIndex:indexPath.row-1];
         
         //选中其中某一行
         TaskInfo *taskInfo = [[TaskInfo alloc] init];
         
         [taskInfo setTaskInfoWithDataDic:tempDic];

         
         if([taskInfo.taskType isEqual:@"3"]){
            
           //修改太阳时任务
            IntelligentAddTaskViewController *viewController = [[IntelligentAddTaskViewController alloc] init];
            viewController.type = @"1";
            viewController.taskInfoID = taskInfo.taskInfoID;
            viewController.intelligentDeviceID = taskInfo.taskCenterControllerID;
            [self.navigationController pushViewController:viewController animated:YES];
         }else if ([taskInfo.taskType isEqual:@"1"]){
            
            //修改周任务
            IntelligentAddWeekTaskViewController *viewController = [[IntelligentAddWeekTaskViewController alloc] init];
            viewController.taskInfoID = taskInfo.taskInfoID;
            viewController.type = @"3";
            viewController.intelligentDeviceID = taskInfo.taskCenterControllerID;
            [self.navigationController pushViewController:viewController animated:YES];
            
            
         }else{
            
            //修改间隔任务
            IntelligentAddSpaceTaskViewController *viewController = [[IntelligentAddSpaceTaskViewController alloc] init];
            viewController.type = @"2";
            viewController.intelligentDeviceID = taskInfo.taskCenterControllerID;
             viewController.taskInfoID = taskInfo.taskInfoID;
            [self.navigationController pushViewController:viewController animated:YES];
         }
         
      }
      
   }else{
      //情景模式下修改
      
//      NSLog(@"%d-------%d",indexPath.section,indexPath.row);
      
      TaskInfo *taskInfo = [_aryContextualTaskData objectAtIndex:indexPath.row];
      //情景模式
//      parentType = @"2";
      
      if([taskInfo.taskType isEqual:@"3"]){
         
         //第一项 太阳时任务
         IntelligentContextualAddTaskViewController *viewController = [[IntelligentContextualAddTaskViewController alloc] init];
         
         viewController.type = @"1";
         viewController.taskInfoID = taskInfo.taskInfoID;
         [self.navigationController pushViewController:viewController animated:YES];
         
      }else if ([taskInfo.taskType isEqual:@"1"]){
         
         //第三项 周任务
         IntelligentContextualWeekTaskViewController *viewController = [[IntelligentContextualWeekTaskViewController alloc] init];
         viewController.taskInfoID = taskInfo.taskInfoID;
         viewController.type = @"3";
         [self.navigationController pushViewController:viewController animated:YES];
         
      }else{
         
         //第二项 间隔任务
         IntelligentContextualAddSpaceTaskViewController *viewController = [[IntelligentContextualAddSpaceTaskViewController alloc] init];
         
         viewController.type = @"2";
         viewController.taskInfoID = taskInfo.taskInfoID;
         [self.navigationController pushViewController:viewController animated:YES];

      }
      
   }
   
   
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
   
   
   int section = self.selectIndex.section;
   
   int contentCount;
   
   /* 得到对应数据 */
   IntegratedDeviceInfo *deviceInfo = [_aryControlList objectAtIndex:section];
   
   //加载所有开关
   [self loadIntelligentAllSwitch:deviceInfo.integratedDeviceID];
   
   NSMutableArray *currentArray = [_taskWithControlDic objectForKey:deviceInfo.integratedDeviceID];
   
   contentCount = [currentArray count];
   
   if(contentCount > 0){
      
      self.isOpen = firstDoInsert;
      
      [_tableView beginUpdates];
      
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
      
      

      
   }else{
      
      _isOpen = NO;
//      [self didSelectCellRowFirstDo:NO nextDo:NO];
      _selectIndex = nil;
      [self showSuccessOrFailedMessage:@"暂无数据"];
      
   }
   
   if (nextDoInsert) {
      self.isOpen = YES;
      self.selectIndex = [_tableView indexPathForSelectedRow];
      [self didSelectCellRowFirstDo:YES nextDo:NO];
   }
   
   if (self.isOpen) {
      [_tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
   }

}


//加载所有开关
-(void)loadIntelligentAllSwitch:(NSString *)_intelligentDeviceID{
   
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
            
         }
         
      }
      
   } errorBlock:^(NSString *errorMessage) {
      NSLog(@"%@",errorMessage);
   }];
   
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
       
       if(_segment.selectedSegmentIndex == 0){
          
          _currentDeleteIndexPath = indexPath;
          
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对应开关是否关闭" message:nil delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"开启", nil];
          
          [alertView show];
          
          
       }else{
          
          //删除对应行
          TaskInfo *taskInfo = [_aryContextualTaskData objectAtIndex:indexPath.row];
          
          NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
          [paramDic setObject:taskInfo.taskInfoID forKey:@"taskId"];
          
          [[RequestService defaultRequestService] asyncPostDataWithURL:DeleteCurrentTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
             
             if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                //删除成功
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [_aryContextualTaskData removeObject:taskInfo];
                [_tableView endUpdates];
             }
             
          } errorBlock:^(NSString *errorMessage) {
             NSLog(@"%@",errorMessage);
          }];

          
       }
        
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
   if(buttonIndex == 0){
      //关闭
      //删除对应行
      TaskInfo *taskInfo = [_aryTaskData objectAtIndex:_currentDeleteIndexPath.row];
      
      NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
      [paramDic setObject:taskInfo.taskInfoID forKey:@"taskId"];
      [paramDic setObject:@"0" forKey:@"keepStatus"];//删除任务后 当前开关保持的状态
      
      [[RequestService defaultRequestService] asyncPostDataWithURL:DeleteCurrentTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
         
         if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            //删除成功
             [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_currentDeleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_aryTaskData removeObject:taskInfo];
            [_tableView endUpdates];
            
            
         }
         
      } errorBlock:^(NSString *errorMessage) {
         NSLog(@"%@",errorMessage);
      }];

   }else{
      //开启
      //删除对应行
      TaskInfo *taskInfo = [_aryTaskData objectAtIndex:_currentDeleteIndexPath.row];
      
      NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
      [paramDic setObject:taskInfo.taskInfoID forKey:@"taskId"];
      [paramDic setObject:@"1" forKey:@"keepStatus"];//删除任务后 当前开关保持的状态
      
      [[RequestService defaultRequestService] asyncPostDataWithURL:DeleteCurrentTask paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
         
         if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            //删除成功
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_currentDeleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_aryTaskData removeObject:taskInfo];
            [_tableView endUpdates];
            
            [_tableView reloadData];
            
         }
         
      } errorBlock:^(NSString *errorMessage) {
         NSLog(@"%@",errorMessage);
      }];
   }
   
}

#pragma mark 添加任务
-(void)onClickAddBtn:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    int section = (int)btn.tag;
   
   //集成器
   IntegratedDeviceInfo *deviceInfo = [_aryControlList objectAtIndex:section-1];
   
    _currentSelectedDeviceInfo = deviceInfo;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择添加任务类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.tag = 8000;
    [actionSheet addButtonWithTitle:@"太阳时任务"];
    [actionSheet addButtonWithTitle:@"间隔任务"];
    [actionSheet addButtonWithTitle:@"周任务"];
    [actionSheet showInView:self.view];
    
}


#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   
   
   if(buttonIndex == 0){
      
      // 点击取消
      
      
   }else{
       
   }
    
    NSString *parentType = @"";
    
    if(actionSheet.tag == 8000){
        
        //开关任务
        parentType = @"1";
        
        if(buttonIndex == 1){
            //第一项 太阳时任务
            IntelligentAddTaskViewController *viewController = [[IntelligentAddTaskViewController alloc] init];
            viewController.parentType= parentType;
            viewController.type = @"1";
            viewController.intelligentDeviceID = _currentSelectedDeviceInfo.integratedDeviceID;
            
            [self.navigationController pushViewController:viewController animated:YES];
        }else if (buttonIndex == 2){
            
            //第二项 间隔任务
            IntelligentAddSpaceTaskViewController *viewController = [[IntelligentAddSpaceTaskViewController alloc] init];
            viewController.parentType= parentType;
            viewController.type = @"2";
            viewController.intelligentDeviceID = _currentSelectedDeviceInfo.integratedDeviceID;
            
            [self.navigationController pushViewController:viewController animated:YES];
        }else if (buttonIndex == 3){
            //第三项 周任务
            IntelligentAddWeekTaskViewController *viewController = [[IntelligentAddWeekTaskViewController alloc] init];
            viewController.parentType= parentType;
            viewController.type = @"3";
            viewController.intelligentDeviceID = _currentSelectedDeviceInfo.integratedDeviceID;
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            //取消
        }

    }else if(actionSheet.tag == 9000){
        
        //情景模式
        parentType = @"2";
        
        if(buttonIndex == 1){
            //第一项 太阳时任务
            IntelligentContextualAddTaskViewController *viewController = [[IntelligentContextualAddTaskViewController alloc] init];
            viewController.parentType= parentType;
            viewController.type = @"1";
            
            [self.navigationController pushViewController:viewController animated:YES];
        }else if (buttonIndex == 2){
            
            //第二项 间隔任务
            IntelligentContextualAddSpaceTaskViewController *viewController = [[IntelligentContextualAddSpaceTaskViewController alloc] init];
            viewController.parentType= parentType;
            viewController.type = @"2";
            
            [self.navigationController pushViewController:viewController animated:YES];
        }else if (buttonIndex == 3){
            //第三项 周任务
            IntelligentContextualWeekTaskViewController *viewController = [[IntelligentContextualWeekTaskViewController alloc] init];
            viewController.parentType= parentType;
            viewController.type = @"3";
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            //取消
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

- (IBAction)onClickChooseSegment:(id)sender {
   
   UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
   
   if(segmentControl.selectedSegmentIndex == 0){
      
       [_addBtn setHidden:YES];
      //集成器任务
      [self loadMyHomeAllIntegratedDevice]; //加载集成器列表
      
   }else{
       [_addBtn setHidden:NO];
      //情景模式任务
      [self loadAllContextualTaskByHomeID];
   }
   
}

- (IBAction)onClickAddContextualTask:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择添加任务类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.tag = 9000;
    [actionSheet addButtonWithTitle:@"太阳时任务"];
    [actionSheet addButtonWithTitle:@"间隔任务"];
    [actionSheet addButtonWithTitle:@"周任务"];
    [actionSheet showInView:self.view];
}





@end
