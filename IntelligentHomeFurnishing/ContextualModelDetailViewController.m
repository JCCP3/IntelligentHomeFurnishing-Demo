//
//  ContextualModelDetailViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/9.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "ContextualModelDetailViewController.h"
#import "NSString+SBJSON.h"
#import "MJRefresh.h"

@interface ContextualModelDetailViewController ()

@end

@implementation ContextualModelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _aryData = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
//    /* 上下拉刷新 */
//    [_tableView addHeaderWithCallback:^{
//       
//        //上拉刷新 展示所有开关列表
//        [self loadMyHomeIntegratedDevices];
//    }];
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    //获取对应情景模式的开关列表
    [self loadSwitchListByModelID];
    
}

//获取对应情景模式的开关列表
-(void)loadSwitchListByModelID{

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_currentModelID forKey:@"modelId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:GetContextualModelSwitchList paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            //所有开关列表
            for (int i=0; i<[[responseDic objectForKey:@"data"] count]; i++) {
                
                NSMutableDictionary *tempDic = [[responseDic objectForKey:@"data"] objectAtIndex:i];
                
                SwitchInfo *switchInfo = [[SwitchInfo alloc] init];
                
                [switchInfo setSwitchInfoWithDataDic:tempDic];
                
                [tempArray addObject:switchInfo];
            }
            
            _aryData = tempArray;
            [_tableView reloadData];
            
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}



-(void)loadMyHomeIntegratedDevices{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:UserHome paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            //所有开关列表
            for (int i=0; i<[[[responseDic objectForKey:@"switchList"] JSONValue] count]; i++) {
                
                NSMutableDictionary *tempDic = [[[responseDic objectForKey:@"switchList"] JSONValue] objectAtIndex:i];
                
                SwitchInfo *switchInfo = [[SwitchInfo alloc] init];
                
                [switchInfo setSwitchInfoWithDataDic:tempDic];
                
                [tempArray addObject:switchInfo];
            }
            
            _aryData = tempArray;
            [_tableView reloadData];
            
            [_tableView headerEndRefreshing];
            
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

- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_aryData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier = @"IntegratedDevicesCell";
    
    IntegratedDevicesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[IntegratedDevicesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    
    [cell loadIntegratedDevicesCell:[_aryData objectAtIndex:indexPath.row] withIndexPath:indexPath];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [IntegratedDevicesCell heightForIntegratedDeviceCell];
}


#pragma mark 开关操作 开或者关

-(void)integratedDevicesOnClickOpenSwitch:(SwitchInfo *)switchInfo{
    
    //开开关
    //    switchInfo.switchStatus = @"1";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:switchInfo.switchAtCenterControllerID forKey:@"centerControllerId"];
    [paramDic setObject:@"1" forKey:@"action"];//开开关
    [paramDic setObject:switchInfo.switchIndex forKey:@"switchIndex"];
    
    [[RequestService defaultRequestService] asyncPostDataWithURL:DoSwitchCommand paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if(_isShowALL){
                [self loadMyHomeIntegratedDevices];
            }else{
                [self loadSwitchListByModelID];
            }
            //修改成功
//            [self loadMyHomeIntegratedDevices];
            
        }else{
            [self showSuccessOrFailedMessage:[responseDic objectForKey:@"error"]];
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
    
    
    
}


-(void)integratedDevicesOnClickCloseSwitch:(SwitchInfo *)switchInfo{
    //关开关
    //    switchInfo.switchStatus = @"0";
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:switchInfo.switchAtCenterControllerID forKey:@"centerControllerId"];
    [paramDic setObject:@"0" forKey:@"action"];//开开关
    [paramDic setObject:switchInfo.switchIndex forKey:@"switchIndex"];
    
    [[RequestService defaultRequestService] asyncPostDataWithURL:DoSwitchCommand paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            //修改成功
//            [self loadMyHomeIntegratedDevices];
            
            if(_isShowALL){
                [self loadMyHomeIntegratedDevices];
            }else{
                [self loadSwitchListByModelID];
            }
            
        }else{
            
            [self showSuccessOrFailedMessage:[responseDic objectForKey:@"error"]];
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
    
}




@end
