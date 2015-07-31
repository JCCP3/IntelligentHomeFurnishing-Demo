//
//  AddSpaceTaskFirstCell.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/1.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AddSpaceTaskFirstCell.h"
#import "Utility.h"

@implementation AddSpaceTaskFirstCell

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"AddSpaceTaskFirstCell" owner:self options:nil] lastObject];
    }
    
    return self;
    
}

-(void)loadAddSpaceTaskFirstCell:(NSString *)switchState{
    
    [self layoutAddSpaceTaskView]; //适配
    
    if([switchState isEqual:@"1"]){
        _switch.on = YES;
        self.backgroundColor = [UIColor whiteColor];
    }else{
        _switch.on = NO;
        self.backgroundColor = [Utility colorWithHexString:@"#ebebeb"];
    }
}

+(CGFloat)heightForAddSpageTaskFirstCell{
    return 44.f;
}


-(void)layoutAddSpaceTaskView{
    
    [_switch setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_switch.bounds.size.width, _switch.frame.origin.y, _switch.bounds.size.width, _switch.bounds.size.height)];
    
    
}

- (IBAction)onClickChooseSwitch:(id)sender {
    
    UISwitch *currentSwitch = (UISwitch *)sender;
    
    if(currentSwitch.on){
        [_delegate addSpaceTaskFirstCellOnClickChooseSwitch:@"1"];
    }else{
        [_delegate addSpaceTaskFirstCellOnClickChooseSwitch:@"0"];
    }
    
}
@end
