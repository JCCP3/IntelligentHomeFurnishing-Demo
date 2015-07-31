//
//  IntelligentAlarmViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntelligentAlarmViewController.h"
#import "RequestService.h"
#import "ContextualModel.h"

@interface IntelligentAlarmViewController ()

@end

@implementation IntelligentAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    _aryData  = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f-52.f)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    /* 添加长按手势*/
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onClickLongPress:)];
    longPressGesture.minimumPressDuration = 1.f;
    [_tableView addGestureRecognizer:longPressGesture];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    UILabel *label = (UILabel *)[_tabBarView viewWithTag:202];
    [label setTextColor:[UIColor orangeColor]];
    
    UIImageView *imageView = (UIImageView *)[_tabBarView viewWithTag:302];
    [imageView setImage:[UIImage imageNamed:@"报警选中"]];
    
    [self showLoadingMessage:@"加载中..."];
    //加载情景模式数据
    [self loadIntelligentAlarmList];
}


-(void)loadIntelligentAlarmList{
    
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
                
                _aryData = currentTempArray;
                
                [_tableView reloadData];
                
            }
            
        }
        
        [self removeLoadingMessage];
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
        [self removeLoadingMessage];
    }];
    
    
}

//手势
-(void)onClickLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:_tableView];
    
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:point];
    
    ContextualModel *model = [_aryData objectAtIndex:indexPath.row];
    
    [self showSuccessOrFailedMessage:model.contextualModelDesc];
    
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
    
    static NSString *cellIdentifier = @"AlarmCell";
    
    AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[AlarmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    
    [cell loadAlarmCell:[_aryData objectAtIndex:indexPath.row]];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AlarmCell heightForAlarmCell];
}


#pragma mark AlarmCellDelegate
-(void)alarmCellOnClickOn:(ContextualModel *)model{
    
    //得到对应的对象 开
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:model.contextualModelID forKey:@"modelId"];
    [paramDic setObject:@"1" forKey:@"flag"];
    [[RequestService defaultRequestService] asyncPostDataWithURL:DoContextualModel paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            model.contextualIsClosed = @"0"; //开着的
            [_tableView reloadData];
            
        }else{
            [self showSuccessOrFailedMessage:[responseDic objectForKey:@"error"]];
        }
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}

-(void)alarmCellOnClickOff:(ContextualModel *)model{
    
    //得到对应的对象 关
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:model.contextualModelID forKey:@"modelId"];
    [paramDic setObject:@"0" forKey:@"flag"];
    [[RequestService defaultRequestService] asyncPostDataWithURL:DoContextualModel paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            //关成功了
            model.contextualIsClosed = @"1";
            [_tableView reloadData];
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

@end
