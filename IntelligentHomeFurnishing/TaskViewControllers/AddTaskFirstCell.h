//
//  AddTaskFirstCell.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/29.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"

@protocol AddTaskFirstCellDelegate <NSObject>

//选择开关
-(void)addTaskFirstCellOnClickChoose:(NSString *)chooseType;

//选择任务
-(void)addTaskFirstCellOnClickChooseTask:(NSString *)chooseType;

@end

@interface AddTaskFirstCell : UITableViewCell{
    
    IBOutlet UILabel *_chooseShowLabel;
    
    IBOutlet UILabel *_chooseDetailLabel;
    
    IBOutlet UIButton *_chooseDetailBtn;
    
    
}


@property (nonatomic ,assign)id<AddTaskFirstCellDelegate> delegate;

@property (nonatomic ,strong)NSString *chooseType;

-(void)loadAddTaskFirstCell:(NSString *)detailInfo withShowLabel:(NSString *)showLabelString;

+(CGFloat)heightForTaskFirstCell;

- (IBAction)onClickChoose:(id)sender;


@end
