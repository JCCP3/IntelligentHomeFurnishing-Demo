//
//  AddTaskThirdCell.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/29.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AddTaskThirdCell.h"

@implementation AddTaskThirdCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self = [[[NSBundle mainBundle] loadNibNamed:@"AddTaskThirdCell" owner:self options:nil] lastObject];
    }
    
    return self;
}

-(void)loadAddTaskThirdCellData:(NSString *)info{
    
    [self layoutAddTaskThirdView];
    
    _showTextField.text = info;
    
}

-(void)layoutAddTaskThirdView{
    
    [_showTextField setFrame:CGRectMake(_showTextField.frame.origin.x, _showTextField.frame.origin.y, DEVICE_AVALIABLE_WIDTH-10-_showTextField.frame.origin.x, _showTextField.bounds.size.height)];
    
}


+(CGFloat)heightForAddTaskThirdCell{
    return 44.f;
}

@end
