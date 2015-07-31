//
//  UserCenterInfoViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/24.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@interface UserCenterInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    UITableView *_tableView;
}

- (IBAction)onClickBack:(id)sender;


@end
