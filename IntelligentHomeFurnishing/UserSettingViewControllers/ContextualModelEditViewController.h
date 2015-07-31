//
//  ContextualModelEditViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/12.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@interface ContextualModelEditViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextViewDelegate>{
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    UITableView *_tableView;
    
    NSMutableArray *_aryOpenData;
    
    NSMutableArray *_aryCloseData;
    
    NSMutableArray *_aryContextualModelType;
    
    SwitchInfo *_currentSelectedSwitchInfo;
    
    
    IBOutlet UIButton *_submitBtn;
    
    IBOutlet UIView *_footerView;
    
    IBOutlet UITextField *_contextualModelNameTextField;
    
    
    IBOutlet UITextView *_contextualModelDescTextView;
    
    
    IBOutlet UILabel *_contextualModelTypeLabel;
    
    IBOutlet UITextField *_contextualModelTypeTextField;
    
    IBOutlet UIButton *_contextualModelTypeBtn;
    
    
    UILabel *_placeHoldLabel;
    
    int _currentSelectedType; //当前选中的type

    UIImageView *imageView;
    
}

@property (nonatomic ,strong)NSIndexPath *selectIndex;

@property (nonatomic ,assign)BOOL isOpen;

@property (nonatomic ,strong)ContextualModel *contextualModel;

- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickSubmit:(id)sender;

- (IBAction)onClickChooseType:(id)sender;


@end
