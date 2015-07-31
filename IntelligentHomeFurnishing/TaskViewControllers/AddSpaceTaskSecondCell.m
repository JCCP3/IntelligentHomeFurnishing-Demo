//
//  AddSpaceTaskSecondCell.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/1.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AddSpaceTaskSecondCell.h"
#import "Utility.h"

@implementation AddSpaceTaskSecondCell

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"AddSpaceTaskSecondCell" owner:self options:nil] lastObject];
    }
    
    return self;
}


-(void)loadAddSpaceTaskSecondCellData:(NSString *)showLabelString withSwitchState:(NSString *)switchState withDetailInfo:(NSString *)detailInfo withActiveState:(BOOL)active{
    
    [self layoutAddSpaceTaskSecondCell]; //适配
    
    _showLabel.text = showLabelString;
    
    _currentShow = showLabelString;
    
    
    if([showLabelString isEqual:@"首次执行时间"]){
        
        //必须要输入 不用管激活不激活
        
    }else{
        
        //其他的就要判断是否激活
        if(active){
            
            //激活了
            _showSwitch.enabled = YES;
            self.backgroundColor = [UIColor whiteColor];
            
        }else{
            
            _showSwitch.enabled = NO;
            //未激活
            self.backgroundColor = [Utility colorWithHexString:@"#ebebeb"];
        }
        
        
        
    }
    
    if([switchState isEqual:@"1"]){
        _showSwitch.on = YES;
       
    }else{
        _showSwitch.on = NO;
        
    }
    
    if(detailInfo && ![detailInfo isEqual:@""]){
        _showDetailLabel.text = detailInfo;
    }else{
        if([showLabelString isEqual:@"首次执行时间"]){
            _showDetailLabel.text = @"请选择首次执行时间";
        }else if ([showLabelString isEqual:@"持续时间"]){
            _showDetailLabel.text = @"请选择持续时间";
        }else if([showLabelString isEqual:@"自定义周期"]){
            _showDetailLabel.text = @"请选择自定义周期";
        }else if ([showLabelString isEqual:@"打开"]){
            _showDetailLabel.text = @"打开";
        }else if ([showLabelString isEqual:@"关闭"]){
            _showDetailLabel.text = @"关闭";
        }
        
    }
    
}

-(void)layoutAddSpaceTaskSecondCell{
    
    [_showSwitch setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_showSwitch.bounds.size.width, _showSwitch.frame.origin.y, _showSwitch.bounds.size.width, _showSwitch.bounds.size.height)];
    
    [_showLabel setFrame:CGRectMake(_showLabel.frame.origin.x, _showLabel.frame.origin.y, DEVICE_AVALIABLE_WIDTH-_showSwitch.bounds.size.width-10-_showLabel.frame.origin.x, _showLabel.bounds.size.height)];
    
    [_showDetailLabel setFrame:CGRectMake(_showDetailLabel.frame.origin.x, _showDetailLabel.frame.origin.y, DEVICE_AVALIABLE_WIDTH-_showSwitch.bounds.size.width-10-_showDetailLabel.frame.origin.x, _showDetailLabel.bounds.size.height)];
    
}

+(CGFloat)heightForAddSpaceTaskSecondCell{
    return 60.f;
}

- (IBAction)onClickChooseSwitch:(id)sender {
    
    if([_currentShow isEqual:@"首次执行时间"]){
    
        UISwitch *currentSwitch = (UISwitch *)sender;
        
        if(currentSwitch.on){
            
            [_delegate addSpaceTaskSecondCellOnClickChooseSwitch:@"1"];
           
        }else{
            [_delegate addSpaceTaskSecondCellOnClickChooseSwitch:@"0"];
        }
        
        
    }else if ([_currentShow isEqual:@"持续时间"]){
        
        UISwitch *currentSwitch = (UISwitch *)sender;
        
        if(currentSwitch.on){
            
            [_delegate addSpaceTaskSecondCellCombineOnClickChooseSwitch:@"1"];
        }else{
            [_delegate addSpaceTaskSecondCellCombineOnClickChooseSwitch:@"0"];
        }
        
    }else if([_currentShow isEqual:@"自定义周期"]){
        
        UISwitch *currentSwitch = (UISwitch *)sender;
        
        if(currentSwitch.on){
            
            [_delegate addSpaceTaskSecondCellRepateOnClickChooseSwitch:@"1"];
        }else{
            [_delegate addSpaceTaskSecondCellRepateOnClickChooseSwitch:@"0"];
        }
        
    }else if([_currentShow isEqual:@"打开"]){
        
        UISwitch *currentSwitch = (UISwitch *)sender;
        
        if(currentSwitch.on){
            
            [_delegate addWeekTaskSecondCellOpenOnClickChooseSwitch:@"1"];
        }else{
            [_delegate addWeekTaskSecondCellOpenOnClickChooseSwitch:@"0"];
        }
        
    }else if([_currentShow isEqual:@"关闭"]){
        
        UISwitch *currentSwitch = (UISwitch *)sender;
        
        if(currentSwitch.on){
            
            [_delegate addWeekTaskSecondCellCloseOnClickChooseSwitch:@"1"];
        }else{
            [_delegate addWeekTaskSecondCellCloseOnClickChooseSwitch:@"0"];
        }
        
    }
    
}

@end
