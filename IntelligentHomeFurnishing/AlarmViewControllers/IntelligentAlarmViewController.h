//
//  IntelligentAlarmViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "AlarmCell.h"

@interface IntelligentAlarmViewController : BaseTabBarViewController<UITableViewDataSource,UITableViewDelegate,AlarmCellDelegate>{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    UITableView *_tableView;
    
    NSMutableArray *_aryData;
    
}

@end
