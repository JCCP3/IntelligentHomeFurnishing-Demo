//
//  IntelligentUserSettingViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntelligentUserSettingViewController.h"
#import "UserAboutViewController.h"
#import "UserLoginViewController.h"
#import "UserCenterInfoViewController.h"

@interface IntelligentUserSettingViewController ()

@end

@implementation IntelligentUserSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //适配
    _aryData = [[NSMutableArray alloc] init];
    
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f-52.f) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [_aryData addObject:@"关于"];
    [_aryData addObject:@"个人信息"];
    [_aryData addObject:@"园丁服务"];
    [_aryData addObject:@"庭院与花卉社交平台"];
//    [_aryData addObject:@"推送通知"];
    [_aryData addObject:@"退出当前账号"];
    [_tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    UILabel *label = (UILabel *)[_tabBarView viewWithTag:203];
    [label setTextColor:[UIColor orangeColor]];
    
    UIImageView *imageView = (UIImageView *)[_tabBarView viewWithTag:303];
    [imageView setImage:[UIImage imageNamed:@"设置选中"]];
    
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
    
    
    static NSString *cellIdentifier = @"UserSettingCell";
    
    UserSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UserSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    
    cell.leftShowLabel.text = [_aryData objectAtIndex:indexPath.row];
    
    if(indexPath.row != 4){
        
        cell.rightSwitch.hidden = YES;
        
    }else{
        
        cell.rightSwitch.hidden = YES;
        
        
    }
    
    [cell loadCurrentSwitchState];
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        
        //关于
        UserAboutViewController *viewController = [[UserAboutViewController alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else if (indexPath.row == 4){
        
        //退出当前账号
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定退出当前账号?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        
    }else if(indexPath.row == 1){
        
        //个人中心
        UserCenterInfoViewController *viewController = [[UserCenterInfoViewController alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else{
        
        
    }
    
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
        //取消
    }else{
        
        //确定
        [APPDELEGATE setIntegratedDeviceViewController:nil];
        [APPDELEGATE setTaskViewController:nil];
        [APPDELEGATE setContextualModelViewController:nil];
        [APPDELEGATE setUserSettingViewController:nil];
        
        [APPDELEGATE destoryUser];
        
        //登陆界面
        UserLoginViewController *viewController = [[UserLoginViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [APPDELEGATE window].rootViewController = navController;
        
    }
    
}

#pragma mark UserSettingCellDelegate
-(void)userSettingChooseSwitch:(UISwitch *)switchState{
    
    if(switchState.on){
        [APPDELEGATE setNotificationSwitch:@"1"];
    }else{
        [APPDELEGATE setNotificationSwitch:@"0"];
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

@end
