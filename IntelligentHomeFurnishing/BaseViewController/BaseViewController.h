//
//  BaseViewController.h
//  WisdomPension
//
//  Created by JC_CP3 on 15/5/5.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

//基类
@interface BaseViewController : UIViewController{
     MBProgressHUD *_mbProgressHUD;
}

-(void)adaptationHeaderView:(UIView *)_headerView withSepaLabel:(UILabel *)_sepaLabel withNavTitleLabel:(UILabel *)_navTitleLabel;

-(void)showSuccessOrFailedMessage:(NSString *)message;

-(void)showLoadingMessage:(NSString *)message;

-(void)removeLoadingMessage;

@end
