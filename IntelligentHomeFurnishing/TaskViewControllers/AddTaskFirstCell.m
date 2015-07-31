//
//  AddTaskFirstCell.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/29.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AddTaskFirstCell.h"

@implementation AddTaskFirstCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self = [[[NSBundle mainBundle] loadNibNamed:@"AddTaskFirstCell" owner:self options:nil] lastObject];
    }
    
    return self;
}

-(void)loadAddTaskFirstCell:(NSString *)detailInfo withShowLabel:(NSString *)showLabelString{
    
    _chooseShowLabel.text = showLabelString;
    
    _chooseType = showLabelString;
    
    if([showLabelString isEqual:@"选择开关"]){
        
        [self layoutAddTaskFirstCell]; //适配
        
        if(detailInfo && ![detailInfo isEqual:@""]){
            _chooseDetailLabel.text = detailInfo;
        }else{
            _chooseDetailLabel.text = @"请选择开关时可以多选";
        }
        
    }else if ([showLabelString isEqual:@"选择任务"]){
        
        
        [self layoutAddTaskFirstCell]; //适配
        
        if(detailInfo && ![detailInfo isEqual:@""]){
            _chooseDetailLabel.text = detailInfo;
        }else{
            _chooseDetailLabel.text = @"请选择任务";
        }
        
    }else if ([showLabelString isEqual:@"选择星期"]){
        
        [self layoutAddTaskFirstCell]; //适配
        
        if(detailInfo && ![detailInfo isEqual:@""]){
            _chooseDetailLabel.text = detailInfo;
        }else{
            _chooseDetailLabel.text = @"请选择星期时可以多选";
        }
        
    }else if ([showLabelString isEqual:@"选择情景"]){
        
        [self layoutAddTaskFirstCell]; //适配
        
        if(detailInfo && ![detailInfo isEqual:@""]){
            _chooseDetailLabel.text = detailInfo;
        }else{
            _chooseDetailLabel.text = @"请选择情景";
        }
        
    }
    
    
    
}

+(CGFloat)heightForTaskFirstCell{
    return 44.f;
}

-(void)layoutAddTaskFirstCell{
    
    [_chooseDetailLabel setFrame:CGRectMake(_chooseDetailLabel.frame.origin.x, _chooseDetailLabel.frame.origin.y, DEVICE_AVALIABLE_WIDTH-10-_chooseDetailLabel.frame.origin.x, _chooseDetailLabel.bounds.size.height)];
    
    [_chooseDetailBtn setFrame:CGRectMake(_chooseDetailBtn.frame.origin.x, _chooseDetailBtn.frame.origin.y, _chooseDetailLabel.bounds.size.width, _chooseDetailLabel.bounds.size.height)];
    
}


- (IBAction)onClickChoose:(id)sender {
    
    if([_chooseType isEqual:@"选择开关"]){
        
        [_delegate addTaskFirstCellOnClickChoose:_chooseType];
    }else if([_chooseType isEqual:@"选择任务"]){
        [_delegate addTaskFirstCellOnClickChooseTask:_chooseType];
    }else{
        [_delegate addTaskFirstCellOnClickChooseTask:_chooseType];
    }

    
    
}
@end
