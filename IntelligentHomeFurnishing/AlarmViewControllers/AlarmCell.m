//
//  AlarmCell.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/22.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AlarmCell.h"

@implementation AlarmCell

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"AlarmCell" owner:self options:nil] lastObject];
    }
    
    return self;
    
}

-(void)loadAlarmCell:(ContextualModel *)model{
    
    //适配
    [self layoutAlarmCellView];
    
    _contextualModel = model;
    
    _alarmLabel.text = model.contextualModelName;
    
}

-(void)layoutAlarmCellView{
    
    if(_contextualModel.contextualIsClosed){
        
        //开着的
        self.backgroundColor = [UIColor orangeColor];
        
    }else{
        
        //关着的
        self.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];;
    }
    
    [_alarmLabel setFrame:CGRectMake(_alarmLabel.frame.origin.x, _alarmLabel.frame.origin.y, DEVICE_AVALIABLE_WIDTH, _alarmLabel.bounds.size.height)];
    _alarmLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [_offBtn setFrame:CGRectMake(_offBtn.frame.origin.x, _offBtn.frame.origin.y, _offBtn.bounds.size.width, _offBtn.bounds.size.height)];
    [_onBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-30-_onBtn.bounds.size.width, _onBtn.frame.origin.y, _onBtn.bounds.size.width, _onBtn.bounds.size.height)];
    
}

+(CGFloat)heightForAlarmCell{
    
    return 65.f;
}

- (IBAction)onClickOff:(id)sender {
    
    [_delegate alarmCellOnClickOff:_contextualModel];
    
}

- (IBAction)onClickOn:(id)sender {
    
    [_delegate alarmCellOnClickOn:_contextualModel];
}
@end
