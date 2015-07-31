//
//  AddSpaceTaskFirstCell.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/1.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddSpaceTaskFirstCellDelegate <NSObject>

-(void)addSpaceTaskFirstCellOnClickChooseSwitch:(NSString *)switchState;

@end

@interface AddSpaceTaskFirstCell : UITableViewCell{
    
    IBOutlet UILabel *_showLabel;
    
    IBOutlet UISwitch *_switch;
    
}

@property (nonatomic ,assign)id<AddSpaceTaskFirstCellDelegate> delegate;

-(void)loadAddSpaceTaskFirstCell:(NSString *)switchState;

+(CGFloat)heightForAddSpageTaskFirstCell;

- (IBAction)onClickChooseSwitch:(id)sender;


@end
