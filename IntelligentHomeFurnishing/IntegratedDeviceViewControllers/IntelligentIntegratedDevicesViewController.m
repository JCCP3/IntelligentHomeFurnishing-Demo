//
//  IntelligentIntegratedDevicesViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntelligentIntegratedDevicesViewController.h"
#import "RequestService.h"
#import "IntegratedDeviceInfo.h"
#import "NSString+SBJSON.h"
#import "MJRefresh.h"
#import <AVFoundation/AVFoundation.h>

@interface IntelligentIntegratedDevicesViewController ()

@end

@implementation IntelligentIntegratedDevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    [self layoutIgentIntegratedDevicesView];
    
    _pageIndex = 0; //第一个
    _aryData = [[NSMutableArray alloc] init];
    _aryIntegratedDevices = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f+50.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f-50.f-52.f)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //添加下拉刷新
    [_tableView addHeaderWithCallback:^{
        //刷新
        [self loadMyHomeIntegratedDevices];
    }];
    [self.view addSubview:_tableView];
    
//    NSDictionary *tempDic = @{@"centerControllerId":@"13",@"centerControllerTerminalUID": @"201407100001",
//                                     @"centerControllerName": @"1#控制器",
//                                     @"centerControllerStatus": @"0",
//                                     @"switchIndex": @"2",
//                                     @"switchName": @"2号灯",
//                                     @"switchStatus": @"0"};
//    
//    //封装假数据
//    for(int i=0;i<10;i++){
//        
//        SwitchInfo *switchInfo = [[SwitchInfo alloc] init];
//        
//        [switchInfo setSwitchInfoWithDataDic:[tempDic mutableCopy]];
//        
//        [_aryData addObject:switchInfo];
//        
//    }
//
//    [_tableView reloadData];
//    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void)receiveNotification:(id)sender
{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[APPDELEGATE user].userID forKey:@"homeUserId"];
    [paramDic setObject:@"1" forKey:@"pushStatus"];
    //收
    [[RequestService defaultRequestService] asyncPostDataWithURL:ChangeNotification paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"code"] intValue] == 0){
            
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}

- (void)closeNotification:(id)sender
{
    //关
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[APPDELEGATE user].userID forKey:@"homeUserId"];
    [paramDic setObject:@"0" forKey:@"pushStatus"];
    //收
    [[RequestService defaultRequestService] asyncPostDataWithURL:ChangeNotification paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"code"] intValue] == 0){
            
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    UILabel *label = (UILabel *)[_tabBarView viewWithTag:200];
    [label setTextColor:[UIColor orangeColor]];
    
    UIImageView *imageView = (UIImageView *)[_tabBarView viewWithTag:300];
    [imageView setImage:[UIImage imageNamed:@"我的家庭选中"]];
    
    [self showLoadingMessage:@"加载中..."];
    
    [self loadMyHomeIntegratedDevices];
    
}

//适配UIView
-(void)layoutIgentIntegratedDevicesView{
    
    [_showIntegratedDevicesView setFrame:CGRectMake(_showIntegratedDevicesView.frame.origin.x, _showIntegratedDevicesView.frame.origin.y, DEVICE_AVALIABLE_WIDTH, _showIntegratedDevicesView.bounds.size.height)];
    
    [_integratedDeviceNameLabel setFrame:CGRectMake(_integratedDeviceNameLabel.frame.origin.x, _integratedDeviceNameLabel.frame.origin.y, _integratedDeviceNameLabel.bounds.size.width, _integratedDeviceNameLabel.bounds.size.height)];
    
    CGFloat spaceWidth = (DEVICE_AVALIABLE_WIDTH-20-35-_integratedDeviceNameLabel.bounds.size.width-_insideTempLabel.bounds.size.width-_insideWetLabel.bounds.size.width)/2;
    
    [_insideTempLabel setFrame:CGRectMake(_integratedDeviceNameLabel.frame.origin.x+_integratedDeviceNameLabel.bounds.size.width+spaceWidth, _insideTempLabel.frame.origin.y, _insideTempLabel.bounds.size.width, _insideTempLabel.bounds.size.height)];
    
    [_insideWetLabel setFrame:CGRectMake(_insideTempLabel.frame.origin.x+_insideTempLabel.bounds.size.width+spaceWidth, _insideWetLabel.frame.origin.y, _insideWetLabel.bounds.size.width, _insideWetLabel.bounds.size.height)];
    
    
    //下方
    [_outsideTempLabel setFrame:CGRectMake(_voltageLabel.frame.origin.x+_voltageLabel.bounds.size.width+spaceWidth, _outsideTempLabel.frame.origin.y, _outsideTempLabel.bounds.size.width, _outsideTempLabel.bounds.size.height)];
    
    [_outsideWetLabel setFrame:CGRectMake(_outsideTempLabel.frame.origin.x+_outsideTempLabel.bounds.size.width+spaceWidth, _outsideWetLabel.frame.origin.y, _outsideWetLabel.bounds.size.width, _outsideWetLabel.bounds.size.height)];
    
    [_nextBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-_nextBtn.bounds.size.width, _nextBtn.frame.origin.y, _nextBtn.bounds.size.width, _nextBtn.bounds.size.height)];
    
}

-(void)loadMyHomeIntegratedDevices{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:UserHome paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        
        NSMutableArray *currentTempArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if([[responseDic objectForKey:@"ccIds"] JSONValue] && ![[[responseDic objectForKey:@"ccIds"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"ccIds"] JSONValue] count]>0){
                
                
                for (int i = 0; i<[[[responseDic objectForKey:@"ccIds"] JSONValue] count]; i++) {
                    
                    IntegratedDeviceInfo *deviceInfo = [[IntegratedDeviceInfo alloc] init];
                    
                    deviceInfo.integratedDeviceID = [NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"ccIds"] JSONValue] objectAtIndex:i] intValue]];
                    
                    //集成器名称
                    if([[responseDic objectForKey:@"ccNames"] JSONValue] && ![[[responseDic objectForKey:@"ccNames"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"ccNames"] JSONValue] count]>0 && [[[responseDic objectForKey:@"ccNames"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"ccNames"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]]){
                        deviceInfo.integratedDeviceName =[[[responseDic objectForKey:@"ccNames"] JSONValue] objectAtIndex:i];
                    }
                    
                    //集成器电流
                    if([[responseDic objectForKey:@"esCurrentList"] JSONValue] && ![[[responseDic objectForKey:@"esCurrentList"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"esCurrentList"] JSONValue] count]>0&&[[[responseDic objectForKey:@"esCurrentList"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"esCurrentList"] JSONValue] objectAtIndex:i]isEqual:[NSNull null]]){
                        
                        deviceInfo.integratedDeviceCurrentDianLiu =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"esCurrentList"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    //集成器电压
                    if([[responseDic objectForKey:@"esVoltageList"] JSONValue] && ![[[responseDic objectForKey:@"esVoltageList"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"esVoltageList"] JSONValue] count]>0&&[[[responseDic objectForKey:@"esVoltageList"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"esVoltageList"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]]){
                        
                        deviceInfo.integratedDeviceCurrentDianYa =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"esVoltageList"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    //集成器室内湿度
                    
                    if([[responseDic objectForKey:@"humidityList"] JSONValue] && ![[[responseDic objectForKey:@"humidityList"] JSONValue] isEqual:@""] && ![[[[responseDic objectForKey:@"humidityList"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]] && [[[responseDic objectForKey:@"humidityList"] JSONValue] count]>0&&[[[responseDic objectForKey:@"humidityList"] JSONValue] objectAtIndex:i]){
                        
                        deviceInfo.integratedDeviceInsideWet =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"humidityList"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    
                    
                    //集成器室内温度
                    if([[responseDic objectForKey:@"temperatureList"] JSONValue] && ![[[responseDic objectForKey:@"temperatureList"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"temperatureList"] JSONValue] count]>0&&[[[responseDic objectForKey:@"temperatureList"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"temperatureList"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]]){
                        
                        deviceInfo.integratedDeviceInsideTemp =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"temperatureList"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    
                    
                    //集成器室外湿度
                    if([[responseDic objectForKey:@"humidityList2"] JSONValue] && ![[[responseDic objectForKey:@"humidityList2"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"humidityList2"] JSONValue] count]>0&&[[[responseDic objectForKey:@"humidityList2"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"humidityList2"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]]){
                        
                        deviceInfo.integratedDeviceOutsideWet =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"humidityList2"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    //集成器室外温度
                    if([[responseDic objectForKey:@"temperatureList2"] JSONValue] && ![[[responseDic objectForKey:@"temperatureList2"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"temperatureList2"] JSONValue] count]>0&&[[[responseDic objectForKey:@"temperatureList2"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"temperatureList2"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]]){
                        
                        deviceInfo.integratedDeviceOutsideTemp =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"temperatureList2"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    [currentTempArray addObject:deviceInfo];
                    
                }
                
                _aryIntegratedDevices = currentTempArray;
                
            }
            
            
            //所有开关列表
            for (int i=0; i<[[[responseDic objectForKey:@"switchList"] JSONValue] count]; i++) {
                
                NSMutableDictionary *tempDic = [[[responseDic objectForKey:@"switchList"] JSONValue] objectAtIndex:i];
                
                SwitchInfo *switchInfo = [[SwitchInfo alloc] init];
                
                [switchInfo setSwitchInfoWithDataDic:tempDic];
                
                [tempArray addObject:switchInfo];
            }
            
            _aryData = tempArray;
            
            // 布局
            [self layoutIntelligentView];
            
            [_tableView reloadData];
        }
        
        [_tableView headerEndRefreshing];
        [self removeLoadingMessage];
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
        [_tableView headerEndRefreshing];
        [self removeLoadingMessage];
    }];
}

//布局
-(void)layoutIntelligentView{
    
    if([_aryIntegratedDevices count] == 1){
        //只有一个
        [_nextBtn setTitle:@"刷新" forState:UIControlStateNormal];
    }else if (_pageIndex < [_aryIntegratedDevices count]-1){
        [_nextBtn setTitle:@"下一个" forState:UIControlStateNormal];
    }else{
        [_nextBtn setTitle:@"第一个" forState:UIControlStateNormal];
    }
    
    IntegratedDeviceInfo *deviceInfo = [_aryIntegratedDevices objectAtIndex:_pageIndex];
    _integratedDeviceNameLabel.text = deviceInfo.integratedDeviceName;
    if(deviceInfo.integratedDeviceInsideTemp){
        _insideTempLabel.text = [NSString stringWithFormat:@"(内)温度%@℃",deviceInfo.integratedDeviceInsideTemp];
    }else{
        _insideTempLabel.text = @"(内)温度0℃";
    }
    
    
    if(deviceInfo.integratedDeviceInsideWet){
        
        _insideWetLabel.text = [NSString stringWithFormat:@"(内)湿度%@%%",deviceInfo.integratedDeviceInsideWet];
        
    }else{
        
        _insideWetLabel.text = @"(内)湿度0%";
    }
    
    if(deviceInfo.integratedDeviceOutsideTemp){
        _outsideTempLabel.text = [NSString stringWithFormat:@"(外)温度%@℃",deviceInfo.integratedDeviceOutsideTemp];
        
    }else{
        _outsideTempLabel.text = @"(外)温度0℃";
        
    }
    
    if(deviceInfo.integratedDeviceOutsideWet){
        _outsideWetLabel.text = [NSString stringWithFormat:@"(外)湿度%@%%",deviceInfo.integratedDeviceOutsideWet];
    }else{
        _outsideWetLabel.text = @"(外)湿度0%";
    }
    

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
//    return [IntegratedDevicesCell heightForIntegratedDeviceCell];
    return (DEVICE_AVALIABLE_HEIGHT-64.f-52.f-50.f)/8;
}


#pragma mark IntegratedDevicesDelegate
-(void)integratedDevicesOnClickOpenSwitch:(SwitchInfo *)switchInfo withIndexPath:(NSIndexPath *)indexPath{
    
    [self playSound];
    
    //开开关
//    switchInfo.switchStatus = @"1";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:switchInfo.switchAtCenterControllerID forKey:@"centerControllerId"];
    [paramDic setObject:@"1" forKey:@"action"];//开开关
    [paramDic setObject:switchInfo.switchIndex forKey:@"switchIndex"];
    
    [[RequestService defaultRequestService] asyncPostDataWithURL:DoSwitchCommand paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            //修改成功
//            [self loadMyHomeIntegratedDevices];
//            switchInfo.switchStatus = @"1";
//            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }else{
            [self showSuccessOrFailedMessage:[responseDic objectForKey:@"error"]];
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
    
    
    
}

-(void)integratedDevicesOnClickCloseSwitch:(SwitchInfo *)switchInfo withIndexPath:(NSIndexPath *)indexPath{
    //关开关
//    switchInfo.switchStatus = @"0";
    
    [self playSound];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:switchInfo.switchAtCenterControllerID forKey:@"centerControllerId"];
    [paramDic setObject:@"0" forKey:@"action"];//开开关
    [paramDic setObject:switchInfo.switchIndex forKey:@"switchIndex"];
    
    [[RequestService defaultRequestService] asyncPostDataWithURL:DoSwitchCommand paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            //修改成功
//            [self loadMyHomeIntegratedDevices];
//            switchInfo.switchStatus = @"0";
//            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }else{
            
            [self showSuccessOrFailedMessage:[responseDic objectForKey:@"error"]];
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickChooseNextIntegratedDevice:(id)sender {
    
    if([_aryIntegratedDevices count] == 1){
        [_nextBtn setTitle:@"刷新" forState:UIControlStateNormal];
        //只有一个
        [self showSuccessOrFailedMessage:@"刷新成功"];
        
    }else if(_pageIndex == [_aryIntegratedDevices count]-1){
        //最后一页 显示第一个
        _pageIndex = 0;
    }else{
        _pageIndex += 1;
    }
    
    [_tableView setContentOffset:CGPointMake(0, _pageIndex*8*((DEVICE_AVALIABLE_HEIGHT-64-52-50)/8)) animated:YES];
    
    //布局
    [self layoutIntelligentView];
    
}

#pragma mark 刷新当前UITableView
-(void)reloadCurrentTableView:(NSDictionary *)tempDic{
    
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[_aryData count]; i++) {
        
        SwitchInfo *currentSwitchInfo = [_aryData objectAtIndex:i];
        
        NSString *currentSwitchIndex = [NSString stringWithFormat:@"%d",[[tempDic objectForKey:@"switchIndex"] intValue]+1];
        NSString *currentSwitchCenterControllerID = [NSString stringWithFormat:@"%d",[[tempDic objectForKey:@"centerControllerId"] intValue]];
        NSString *currentSwitchStatus= [NSString stringWithFormat:@"%d",[[tempDic objectForKey:@"switchStatus"] intValue]];
        
        if([currentSwitchInfo.switchIndex isEqual:currentSwitchIndex] && [currentSwitchInfo.switchAtCenterControllerID isEqual:currentSwitchCenterControllerID]){
            currentSwitchInfo.switchStatus = currentSwitchStatus;
            currentSwitchInfo.switchIsCloseSoon = NO;
            currentSwitchInfo.switchIsOpenSoon = NO;
            [rowArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    for (int j=0; j<[rowArray count]; j++) {
        
        NSString *rowString = [rowArray objectAtIndex:j];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[rowString intValue] inSection:0];
        
        [indexPathArray addObject:indexPath];
    }
    
    
    [_tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    
}

-(void)reloadCenterControllerStatus:(NSDictionary*)tempDic{
    
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[_aryData count]; i++) {
        
        SwitchInfo *currentSwitchInfo = [_aryData objectAtIndex:i];
        
        if([currentSwitchInfo.switchAtCenterControllerID isEqual:[NSString stringWithFormat:@"%d",[[tempDic objectForKey:@"centerControllerId"] intValue]]]){
            
            currentSwitchInfo.switchAtCenterControllerStatus = [NSString stringWithFormat:@"%d",[[tempDic objectForKey:@"loginStatus"] intValue]];
            [rowArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    for (int j=0; j<[rowArray count]; j++) {
        
        NSString *rowString = [rowArray objectAtIndex:j];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[rowString intValue] inSection:0];
        
        [indexPathArray addObject:indexPath];
    }
    
    [_tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    
}

-(void)reloadMultiTableView:(NSDictionary *)tempDic{
    
    
}

//温度等状态
-(void)reloadHeaderView{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:UserHome paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        
        NSMutableArray *currentTempArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if([[responseDic objectForKey:@"ccIds"] JSONValue] && ![[[responseDic objectForKey:@"ccIds"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"ccIds"] JSONValue] count]>0){
                
                
                for (int i = 0; i<[[[responseDic objectForKey:@"ccIds"] JSONValue] count]; i++) {
                    
                    IntegratedDeviceInfo *deviceInfo = [[IntegratedDeviceInfo alloc] init];
                    
                    deviceInfo.integratedDeviceID = [NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"ccIds"] JSONValue] objectAtIndex:i] intValue]];
                    
                    //集成器名称
                    if([[responseDic objectForKey:@"ccNames"] JSONValue] && ![[[responseDic objectForKey:@"ccNames"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"ccNames"] JSONValue] count]>0 && [[[responseDic objectForKey:@"ccNames"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"ccNames"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]]){
                        deviceInfo.integratedDeviceName =[[[responseDic objectForKey:@"ccNames"] JSONValue] objectAtIndex:i];
                    }
                    
                    //集成器电流
                    if([[responseDic objectForKey:@"esCurrentList"] JSONValue] && ![[[responseDic objectForKey:@"esCurrentList"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"esCurrentList"] JSONValue] count]>0&&[[[responseDic objectForKey:@"esCurrentList"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"esCurrentList"] JSONValue] objectAtIndex:i]isEqual:[NSNull null]]){
                        
                        deviceInfo.integratedDeviceCurrentDianLiu =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"esCurrentList"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    //集成器电压
                    if([[responseDic objectForKey:@"esVoltageList"] JSONValue] && ![[[responseDic objectForKey:@"esVoltageList"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"esVoltageList"] JSONValue] count]>0&&[[[responseDic objectForKey:@"esVoltageList"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"esVoltageList"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]]){
                        
                        deviceInfo.integratedDeviceCurrentDianYa =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"esVoltageList"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    //集成器室内湿度
                    
                    if([[responseDic objectForKey:@"humidityList"] JSONValue] && ![[[responseDic objectForKey:@"humidityList"] JSONValue] isEqual:@""] && ![[[[responseDic objectForKey:@"humidityList"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]] && [[[responseDic objectForKey:@"humidityList"] JSONValue] count]>0&&[[[responseDic objectForKey:@"humidityList"] JSONValue] objectAtIndex:i]){
                        
                        deviceInfo.integratedDeviceInsideWet =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"humidityList"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    
                    
                    //集成器室内温度
                    if([[responseDic objectForKey:@"temperatureList"] JSONValue] && ![[[responseDic objectForKey:@"temperatureList"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"temperatureList"] JSONValue] count]>0&&[[[responseDic objectForKey:@"temperatureList"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"temperatureList"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]]){
                        
                        deviceInfo.integratedDeviceInsideTemp =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"temperatureList"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    
                    
                    //集成器室外湿度
                    if([[responseDic objectForKey:@"humidityList2"] JSONValue] && ![[[responseDic objectForKey:@"humidityList2"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"humidityList2"] JSONValue] count]>0&&[[[responseDic objectForKey:@"humidityList2"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"humidityList2"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]]){
                        
                        deviceInfo.integratedDeviceOutsideWet =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"humidityList2"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    //集成器室外温度
                    if([[responseDic objectForKey:@"temperatureList2"] JSONValue] && ![[[responseDic objectForKey:@"temperatureList2"] JSONValue] isEqual:@""] && [[[responseDic objectForKey:@"temperatureList2"] JSONValue] count]>0&&[[[responseDic objectForKey:@"temperatureList2"] JSONValue] objectAtIndex:i] && ![[[[responseDic objectForKey:@"temperatureList2"] JSONValue] objectAtIndex:i] isEqual:[NSNull null]]){
                        
                        deviceInfo.integratedDeviceOutsideTemp =[NSString stringWithFormat:@"%d",[[[[responseDic objectForKey:@"temperatureList2"] JSONValue] objectAtIndex:i] intValue]];
                        
                    }
                    
                    [currentTempArray addObject:deviceInfo];
                    
                }
                
                _aryIntegratedDevices = currentTempArray;
                
            }
            
            // 布局
            [self layoutIntelligentView];
            
        }
        
        [_tableView headerEndRefreshing];
        [self removeLoadingMessage];
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
        [_tableView headerEndRefreshing];
        [self removeLoadingMessage];
    }];
    
}


//在button的点击事件里加下面的方法（name： 要播放的声音文件名 extension：声音文件格式）
- (void)playSound
{
    SystemSoundID pmph;
    NSURL *tapSound = [[NSBundle mainBundle] URLForResource:@"defeat" withExtension:@"wav"];
    CFURLRef baseURL = (__bridge CFURLRef)tapSound;
    AudioServicesCreateSystemSoundID(baseURL, &pmph);
    AudioServicesPlaySystemSound(pmph);
}

@end
