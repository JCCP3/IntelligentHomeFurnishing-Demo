//
//  IntegratedDevicesCell.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchInfo.h"

@protocol IntegratedDevicesDelegate <NSObject>

-(void)integratedDevicesOnClickCloseSwitch:(SwitchInfo *)switchInfo withIndexPath:(NSIndexPath *)indexPath;

-(void)integratedDevicesOnClickOpenSwitch:(SwitchInfo *)switchInfo withIndexPath:(NSIndexPath *)indexPath;

@end

@interface IntegratedDevicesCell : UITableViewCell{
    
    IBOutlet UIButton *_offBtn;
    
    IBOutlet UIButton *_onBtn;
    
    //开关名称
    IBOutlet UILabel *_integratedSwitchNameLabel;
    
    SwitchInfo *_switchInfo;
    
    
    IBOutlet UIImageView *_showStateImageView;
    
    NSIndexPath *_indexPath;
    
}

@property (nonatomic, assign)id<IntegratedDevicesDelegate> delegate;

@property (nonatomic ,strong)NSIndexPath *indexPath;

-(void)loadIntegratedDevicesCell:(SwitchInfo *)switchInfo withIndexPath:(NSIndexPath *)indexPath;

+(CGFloat)heightForIntegratedDeviceCell;

//关开关
- (IBAction)onClickCloseSwitch:(id)sender;

//开开关
- (IBAction)onClickOpenSwitch:(id)sender;

@end
