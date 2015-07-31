//
//  IntelligentIntegratedDevicesViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "IntegratedDevicesCell.h"

@interface IntelligentIntegratedDevicesViewController : BaseTabBarViewController<UITableViewDataSource,UITableViewDelegate,IntegratedDevicesDelegate>{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    UITableView *_tableView;
    
    NSMutableArray *_aryData;
    
    NSMutableArray *_aryIntegratedDevices;
    
    IBOutlet UIView *_showIntegratedDevicesView;
    
    
    IBOutlet UILabel *_integratedDeviceNameLabel;
    
    IBOutlet UILabel *_insideTempLabel;
    
    IBOutlet UILabel *_insideWetLabel;
    
    
    IBOutlet UILabel *_voltageLabel;
     
    IBOutlet UILabel *_outsideTempLabel;
    
    IBOutlet UILabel *_outsideWetLabel;
    
    
    IBOutlet UIButton *_nextBtn;
    
    NSInteger _pageIndex;
    
}

- (IBAction)onClickChooseNextIntegratedDevice:(id)sender;

-(void)reloadCurrentTableView:(NSDictionary *)tempDic;

-(void)reloadMultiTableView:(NSDictionary *)tempDic;

-(void)reloadHeaderView;

-(void)reloadCenterControllerStatus:(NSDictionary *)tempDic;

@end
