//
//  AppServerSettingViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AppServerSettingViewController.h"

@interface AppServerSettingViewController ()

@end

@implementation AppServerSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickResignFirstResponder)];
    [self.view addGestureRecognizer:tap];
    
    
    [_serverAddressTextField becomeFirstResponder];//成为第一响应
    
    [self layoutAppServerSettingView];
    
    
    
    
}

-(void)layoutAppServerSettingView{
    
    if([APPDELEGATE checkCurrentAppServer]){
        _serverAddressTextField.text = [APPDELEGATE appServerURL];
        _serverPortTextField.text = [APPDELEGATE appServerPort];
    }
    
    [_showView setFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f)];
    [_showView setBackgroundColor:[UIColor whiteColor]];
    
    [_serverAddressTextField setFrame:CGRectMake(_serverAddressTextField.frame.origin.x, _serverAddressTextField.frame.origin.y, DEVICE_AVALIABLE_WIDTH-30-_serverAddressTextField.frame.origin.x, _serverAddressTextField.bounds.size.height)];
    
    [_serverPortTextField setFrame:CGRectMake(_serverPortTextField.frame.origin.x, _serverPortTextField.frame.origin.y, DEVICE_AVALIABLE_WIDTH-30-_serverPortTextField.frame.origin.x, _serverPortTextField.bounds.size.height)];
    
    [_serverManagerPwdTextField setFrame:CGRectMake(_serverManagerPwdTextField.frame.origin.x, _serverManagerPwdTextField.frame.origin.y, DEVICE_AVALIABLE_WIDTH-30-_serverManagerPwdTextField.frame.origin.x, _serverManagerPwdTextField.bounds.size.height)];
    
    [_rightBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_rightBtn.bounds.size.width, _rightBtn.frame.origin.y, _rightBtn.bounds.size.width, _rightBtn.bounds.size.height)];
    
    
}

-(void)clickResignFirstResponder{
    
    [_serverAddressTextField resignFirstResponder];
    
    [_serverPortTextField resignFirstResponder];
    
    [_serverManagerPwdTextField resignFirstResponder];
    
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

- (IBAction)onClickSettingAppServer:(id)sender {
    
    if([_serverAddressTextField.text isEqual:@""] || [_serverPortTextField.text isEqual:@""] || [_serverManagerPwdTextField.text isEqual:@""]){
        [self showSuccessOrFailedMessage:@"服务配置信息未填写完整"];
    }else if (![_serverManagerPwdTextField.text isEqual:@"lcy"]){
        [self showSuccessOrFailedMessage:@"管理员密码不正确"];
    }else{
        
        [APPDELEGATE setCurrentAppServer:_serverAddressTextField.text withPort:_serverPortTextField.text];
        
        [self showSuccessOrFailedMessage:@"保存成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
   
}
@end
