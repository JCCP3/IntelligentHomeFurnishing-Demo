//
//  UserAboutViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/20.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@interface UserAboutViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    UITableView *_tableView;
    
    NSArray *_aryData;
    
}

- (IBAction)onClickBack:(id)sender;


@end
