//
//  ContexualModelViewController.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/8.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "ContextualModelCollectionViewCell.h"
#import "ContextualModelDetailViewController.h"

@interface ContexualModelViewController : BaseTabBarViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ContextualModelCollectionViewCellDelegate>{
    
    UICollectionView *_collectionView;
    
    NSMutableArray *_aryData;
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UILabel *_navTitleLabel;
    
    IBOutlet UIButton *_addBtn;
    
    int num ;
    
}

- (IBAction)onClickAddContextualModel:(id)sender;


- (IBAction)onClickShow:(id)sender;



@end
