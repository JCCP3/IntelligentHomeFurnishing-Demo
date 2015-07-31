//
//  contextualModelCollectionViewCell.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/8.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContextualModel.h"

@protocol ContextualModelCollectionViewCellDelegate <NSObject>

-(void)contextualModelCollectionViewCellOnClickShow:(ContextualModel *)model;

-(void)contextualModelOnClickShowDetail:(ContextualModel *)model;

@end

@interface ContextualModelCollectionViewCell : UICollectionViewCell{
    
    IBOutlet UIImageView *_imageView;
    
    IBOutlet UILabel *_bottomLabel;
    
    ContextualModel *_currentContextualModel;
    
    IBOutlet UIButton *_showBtn;
    
}

@property (nonatomic ,assign)id<ContextualModelCollectionViewCellDelegate> delegate;


-(void)loadContextualModelCollectionViewCell:(ContextualModel *)contextualModel;

+(CGFloat)heightForContextualModelCell;

// 显示详情
- (IBAction)onClickShowDetail:(id)sender;


@end
