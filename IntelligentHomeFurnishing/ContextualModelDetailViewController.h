//
//  ContextualModelDetailViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/9.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "IntegratedDevicesCell.h"

@interface ContextualModelDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,IntegratedDevicesDelegate>{
    
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    UITableView *_tableView;
    
    NSMutableArray *_aryData;
    
    //是否触发显示全部
    BOOL _isShowALL;
}

@property (nonatomic ,strong)NSString *currentModelID;//当前情景模式ID

- (IBAction)onClickBack:(id)sender;


@end
