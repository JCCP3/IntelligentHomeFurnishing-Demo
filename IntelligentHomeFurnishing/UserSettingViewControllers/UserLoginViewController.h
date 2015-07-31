//
//  UserLoginViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@interface UserLoginViewController : BaseViewController{
    
    
    IBOutlet UILabel *_userAccountLabel;
    
    IBOutlet UITextField *_userAccountTextField;
    
    IBOutlet UILabel *_userPwdLabel;
    
    IBOutlet UITextField *_userPwdTextField;
    
    IBOutlet UIButton *_loginBtn;
    
    IBOutlet UILabel *_descLabel;
    
    IBOutlet UIButton *_settingBtn;
    
    int count;
    
    IBOutlet UIButton *_rememberPwdBtn;
    
    IBOutlet UILabel *_rememberPwdLabel;
    
    BOOL _isChooseSavePwd;
    
    IBOutlet UISwitch *_switchBtn;
    
}


- (IBAction)onClickSettingSystem:(id)sender;

- (IBAction)onClickLogin:(id)sender;

- (IBAction)onClickRememberPwd:(id)sender;

- (IBAction)onClickRemember:(id)sender;


@end
