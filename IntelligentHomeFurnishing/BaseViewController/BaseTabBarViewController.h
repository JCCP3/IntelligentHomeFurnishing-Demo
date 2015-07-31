//
//  BaseTabBarViewController.h
//  WisdomPension
//
//  Created by JC_CP3 on 15/5/5.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTabBarViewController : BaseViewController{
    
    UIView *_tabBarView;
    
    IBOutlet UIButton *_homePageBtn;
    
    IBOutlet UIButton *_contactsBtn;
    
    IBOutlet UIButton *_notificationBtn;
    
    IBOutlet UIButton *_userCenterBtn;
    
    IBOutlet UIImageView *_homePageImageView;
    
    IBOutlet UIImageView *_contactsImageView;
    
    IBOutlet UIImageView *_notificationImageView;
    
    IBOutlet UIImageView *_userCenterImageView;
    
    IBOutlet UILabel *_homePageLabel;
    
    IBOutlet UILabel *_contactsLabel;
    
    IBOutlet UILabel *_notificationLabel;
    
    IBOutlet UILabel *_userCenterLabel;
    
    IBOutlet UILabel *_sepaLabel;
    
    
}


- (IBAction)onClickChangeAppFunction:(id)sender;

@end
