//
//  IntelligentUserSettingViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "UserSettingCell.h"

@interface IntelligentUserSettingViewController : BaseTabBarViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UserSettingCellDelegate>{
    
    IBOutlet UILabel *_navTitleLabel;
    
    IBOutlet UIView *_headerView;
    
    UITableView *_tableView;
    
    NSMutableArray *_aryData;
    __weak IBOutlet UIButton *请问;
}

@end
