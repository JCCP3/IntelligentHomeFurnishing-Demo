//
//  AppServerSettingViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@interface AppServerSettingViewController : BaseViewController{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    IBOutlet UILabel *_serverAddressLabel;
    
    IBOutlet UILabel *_serverPortLabel;
    
    IBOutlet UILabel *_serverManagerPwdLabel;
    
    
    IBOutlet UIButton *_rightBtn;
    
    
    IBOutlet UITextField *_serverAddressTextField;
    
    IBOutlet UITextField *_serverPortTextField;
    
    
    IBOutlet UITextField *_serverManagerPwdTextField;
    
    IBOutlet UIView *_showView;
    
    
    
}


- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickSettingAppServer:(id)sender;


@end
