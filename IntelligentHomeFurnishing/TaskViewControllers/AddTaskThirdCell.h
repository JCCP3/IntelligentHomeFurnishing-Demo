//
//  AddTaskThirdCell.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/29.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTaskThirdCellDelegate <NSObject>

-(void)addTaskThirdCellOnClickChooseTime;

@end

@interface AddTaskThirdCell : UITableViewCell{
    
    IBOutlet UILabel *_showLabel;
    
    IBOutlet UITextField *_showTextField;
  
}


@property (nonatomic ,assign)id<AddTaskFirstCellDelegate> delegate;


-(void)loadAddTaskThirdCellData:(NSString *)info;

+(CGFloat)heightForAddTaskThirdCell;


@end
