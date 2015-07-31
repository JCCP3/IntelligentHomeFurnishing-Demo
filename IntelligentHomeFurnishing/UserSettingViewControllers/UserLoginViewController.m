//
//  UserLoginViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "UserLoginViewController.h"
#import "RequestService.h"
#import "User.h"
#import "IntelligentIntegratedDevicesViewController.h"
#import "AppServerSettingViewController.h"
#import "NSString+SBJSON.h"
#import "APService.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //适配
    [self layoutUserLoginView];
    
    [_userAccountTextField becomeFirstResponder]; //获取第一响应
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickResign)];
    [self.view addGestureRecognizer:tap];
    
    //默认选中记住密码
    _rememberPwdBtn.selected = YES;
    [_rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"记住密码选中"] forState:UIControlStateNormal];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    count = 0;
    
    self.navigationController.navigationBarHidden = YES;
    
}


//释放第一响应
-(void)onClickResign{
    
    [_userAccountTextField resignFirstResponder];
    [_userPwdTextField resignFirstResponder];
    
}


-(void)layoutUserLoginView{
    
    CGFloat spaceWidth = (DEVICE_AVALIABLE_WIDTH-(300-24))/2;
    
    [_userAccountLabel setFrame:CGRectMake(_userAccountLabel.frame.origin.x*AutoSizeScaleX, _userAccountLabel.frame.origin.y*AutoSizeScaleY, _userAccountLabel.bounds.size.width*AutoSizeScaleX, _userAccountLabel.bounds.size.height*AutoSizeScaleY)];
    
    [_settingBtn setFrame:CGRectMake(_settingBtn.frame.origin.x*AutoSizeScaleX, _settingBtn.frame.origin.y*AutoSizeScaleY, _settingBtn.bounds.size.width*AutoSizeScaleX, _settingBtn.bounds.size.height*AutoSizeScaleY)];
    
    [_descLabel setFrame:CGRectMake(0, _descLabel.frame.origin.y*AutoSizeScaleY, _descLabel.bounds.size.width*AutoSizeScaleX, _descLabel.bounds.size.height*AutoSizeScaleY)];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    
    [_userAccountTextField setFrame:CGRectMake(_userAccountTextField.frame.origin.x*AutoSizeScaleX, _userAccountTextField.frame.origin.y*AutoSizeScaleY, _userAccountTextField.bounds.size.width*AutoSizeScaleX, _userAccountTextField.bounds.size.height*AutoSizeScaleY)];
    
    [_userPwdLabel setFrame:CGRectMake(_userPwdLabel.frame.origin.x*AutoSizeScaleX, _userPwdLabel.frame.origin.y*AutoSizeScaleY, _userPwdLabel.bounds.size.width*AutoSizeScaleX, _userPwdLabel.bounds.size.height*AutoSizeScaleY)];
    
    [_userPwdTextField setFrame:CGRectMake(_userPwdTextField.frame.origin.x*AutoSizeScaleX, _userPwdTextField.frame.origin.y*AutoSizeScaleY, _userPwdTextField.bounds.size.width*AutoSizeScaleX, _userPwdTextField.bounds.size.height*AutoSizeScaleY)];
    
    [_loginBtn setFrame:CGRectMake(_loginBtn.frame.origin.x*AutoSizeScaleX, _loginBtn.frame.origin.y*AutoSizeScaleY, _loginBtn.bounds.size.width*AutoSizeScaleX, _loginBtn.bounds.size.height*AutoSizeScaleY)];
    _loginBtn.layer.cornerRadius = 5.f;
    
//    [_rememberPwdBtn setFrame:CGRectMake(_userPwdTextField.frame.origin.x, _rememberPwdBtn.frame.origin.y, _rememberPwdBtn.bounds.size.width, _rememberPwdBtn.bounds.size.height)];
    
    [_switchBtn setFrame:CGRectMake(_switchBtn.frame.origin.x*AutoSizeScaleX, _switchBtn.frame.origin.y*AutoSizeScaleY, _switchBtn.bounds.size.width*AutoSizeScaleX, _switchBtn.bounds.size.height*AutoSizeScaleY)];
    
    [_rememberPwdLabel setFrame:CGRectMake(_rememberPwdLabel.frame.origin.x*AutoSizeScaleX, _rememberPwdLabel.frame.origin.y*AutoSizeScaleY, _rememberPwdLabel.bounds.size.width*AutoSizeScaleX, _rememberPwdLabel.bounds.size.height*AutoSizeScaleY)];
    
    
    if([APPDELEGATE checkUserIsLogin]){
        
        _isChooseSavePwd = [APPDELEGATE user].isUserRememberPwd;
        
        if([APPDELEGATE user].isUserRememberPwd){
            _userAccountTextField.text = [APPDELEGATE user].userName;
            _userPwdTextField.text = [APPDELEGATE user].userPwd;
            _rememberPwdBtn.selected = YES;
            [_rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"记住密码选中"] forState:UIControlStateNormal];
        }else{
            [_rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"记住密码未选中"] forState:UIControlStateNormal];
        }
        
    }else{
        [_rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"记住密码未选中"] forState:UIControlStateNormal];
    }
    
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

- (IBAction)onClickSettingSystem:(id)sender {
    
    count++;
    
    if(count == 8){
        AppServerSettingViewController *viewController = [[AppServerSettingViewController alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

- (IBAction)onClickLogin:(id)sender {
    
    int errorNum = 0;
    
    if([_userAccountTextField.text isEqual:@""]){
        if(errorNum == 0){
            [self showSuccessOrFailedMessage:@"请输入账户信息"];
        }
        errorNum++;
    }
    
    if([_userPwdTextField.text isEqual:@""]){
        if(errorNum == 0){
            [self showSuccessOrFailedMessage:@"请输入密码信息"];
        }
        
        errorNum++;
    }
    
    if(errorNum == 0){
        
        //登陆
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        
        [paramDic setObject:_userAccountTextField.text forKey:@"user.name"];
        [paramDic setObject:_userPwdTextField.text forKey:@"user.password"];
        
        [[RequestService defaultRequestService] asyncGetDataWithURL:UserLogin paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
            
            if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                // 登录成功
                if([responseDic objectForKey:@"user"] && ![[responseDic objectForKey:@"user"] isEqual:@""]){
                    
                    NSMutableDictionary *tempDic = [[responseDic objectForKey:@"user"] JSONValue];
                    
                    
                    //登录成功 显示首页
                    [self showSuccessOrFailedMessage:@"登陆成功"];
                    
                    /*  记住密码 */
                    if(_isChooseSavePwd){
                        [tempDic setObject:@"1" forKey:@"rememberPwd"];
                    }else{
                        [tempDic setObject:@"0" forKey:@"rememberPwd"];
                    }
                    
                    //得到对应的userID给别名
                    [APService setAlias:[NSString stringWithFormat:@"%d",[[tempDic objectForKey:@"id"] intValue]] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                    
                    //设置当前登录用户
                    [APPDELEGATE setCurrentLoginUser:tempDic];
                    
//                    IntelligentIntegratedDevicesViewController *viewController = [APPDELEGATE integratedDeviceViewController];
//                    
//                    if(!viewController){
//                        viewController = [[IntelligentIntegratedDevicesViewController alloc] init];
//                        [APPDELEGATE setIntegratedDeviceViewController:viewController];
//                    }
                    
                    IntelligentIntegratedDevicesViewController *viewController = [[IntelligentIntegratedDevicesViewController alloc] init];
                    
                    [APPDELEGATE setIntegratedDeviceViewController:viewController];
                    
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
                    
                    [APPDELEGATE window].rootViewController = navController;
                    
                    
                    
                }else{
                    
                     [self showSuccessOrFailedMessage:@"登陆失败"];
                }
                
            }else{
                [self showSuccessOrFailedMessage:[responseDic objectForKey:@"error"]];
            }
            
        } errorBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];

        
    }
    
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (IBAction)onClickRememberPwd:(id)sender {

    UIButton *btn = (UIButton *)sender;
    
    btn.selected = !btn.selected;
    
    _isChooseSavePwd = btn.selected;
    
    if(btn.selected){
        [_rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"记住密码选中"] forState:UIControlStateNormal];
    }else{
        [_rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"记住密码未选中"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)onClickRemember:(id)sender {
    
    UISwitch *currentSwitch = (UISwitch *)sender;
    
    _isChooseSavePwd = currentSwitch.on;
    
    if(currentSwitch.on){
        //选中
        
    }else{
        //未选中
    }
    
}

@end
