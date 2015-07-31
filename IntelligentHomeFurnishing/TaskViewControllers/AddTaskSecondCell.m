//
//  AddTaskSecondCell.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/29.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AddTaskSecondCell.h"
#import "Utility.h"

@implementation AddTaskSecondCell

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"AddTaskSecondCell" owner:self options:nil] lastObject];
    }
    
    return self;
    
}


-(void)loadAddTaskSecondCell:(NSString *)showInfo withSwitch:(NSString *)switchState withDelayInfo:(NSString *)delayInfo withActiveState:(BOOL)activeState{
    
    [self layoutAddTaskSecondView];
    
    _currentShowInfo = showInfo;
    
    _showLabel.text = showInfo;
    
    if(activeState){
         self.backgroundColor = [UIColor whiteColor];
        _showDetailSwitch.enabled = YES;
    }else{
        _showDetailSwitch.enabled = NO;
        //当前未激活设置颜色为灰色
        self.backgroundColor = [Utility colorWithHexString:@"#ebebeb"];
    }
    
    if([switchState isEqual:@"0"]){
        
        _showDetailSwitch.on = NO;
       
        
    }else{
        
        _showDetailSwitch.on = YES;
       
        
    }
    
    if(delayInfo && ![delayInfo isEqual:@""]){
        
        if([delayInfo intValue]<0){
            delayInfo = [NSString stringWithFormat:@"%d",-[delayInfo intValue]];
            _showDelayInfoLabel.text = [NSString stringWithFormat:@"提前%@分钟",delayInfo];
        }else{
            _showDelayInfoLabel.text = [NSString stringWithFormat:@"推迟%@分钟",delayInfo];
        }
        
    }
    
}

+(CGFloat)heightForAddTaskSecondCell{
    
    return 60.f;
}

-(void)layoutAddTaskSecondView{
    
    [_showDetailSwitch setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_showDetailSwitch.bounds.size.width, _showDetailSwitch.frame.origin.y, _showDetailSwitch.bounds.size.width, _showDetailSwitch.bounds.size.height)];
    
    [_showDelayInfoLabel setFrame:CGRectMake(_showDelayInfoLabel.frame.origin.x, _showDelayInfoLabel.frame.origin.y, DEVICE_AVALIABLE_WIDTH-10-_showDelayInfoLabel.frame.origin.x, _showDelayInfoLabel.bounds.size.height)];
    
}


- (IBAction)onClickChooseSwitch:(id)sender {
    
    UISwitch *currentSwitch = (UISwitch *)sender;
    
    if(currentSwitch.on){
        [_delegate addTaskSecondCellOnClickSwitch:_currentShowInfo withSwitchState:@"1"];
    }else{
        [_delegate addTaskSecondCellOnClickSwitch:_currentShowInfo withSwitchState:@"0"];
    }
    
    
    
}
@end
