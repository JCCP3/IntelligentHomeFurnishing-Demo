//
//  IntegratedDevicesCell.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntegratedDevicesCell.h"
#import "Utility.h"

@implementation IntegratedDevicesCell

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"IntegratedDevicesCell" owner:self options:nil] lastObject];
    }
    
    return self;
    
}


-(void)loadIntegratedDevicesCell:(SwitchInfo *)switchInfo withIndexPath:(NSIndexPath *)indexPath{
    
    //适配
    [self layoutIntegratedDevicesCellView];
    
    _switchInfo = switchInfo;
    
    _indexPath = indexPath;

    //开关名称
    if(switchInfo.switchName && ![switchInfo.switchName isEqual:@""]){
        _integratedSwitchNameLabel.text = switchInfo.switchName;
    }
    
    if([switchInfo.switchAtCenterControllerStatus intValue] == 0)
    {
        //开关不可用
        _offBtn.enabled = NO;
        _onBtn.enabled = NO;
        self.backgroundColor = [Utility colorWithHexString:@"#bdb9b9"];
        [_showStateImageView setImage:[UIImage imageNamed:@"灯暗"]];
        
    }else{
        //开关可用
        _offBtn.enabled = YES;
        _onBtn.enabled = YES;
        if([switchInfo.switchStatus isEqual:@"0"]){
            //关
            if(switchInfo.switchIsOpenSoon){
                self.backgroundColor = [Utility colorWithHexString:@"ffce74"];
            }else{
                self.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];
                [_showStateImageView setImage:[UIImage imageNamed:@"灯暗"]];
            }
            
        }else if([switchInfo.switchStatus isEqual:@"1"]){
            //开
            if(switchInfo.switchIsCloseSoon){
                self.backgroundColor = [Utility colorWithHexString:@"ddc69d"];
            }else{
                self.backgroundColor = [UIColor orangeColor];
                [_showStateImageView setImage:[UIImage imageNamed:@"灯亮"]];
            }
            
            
        }else if ([switchInfo.switchStatus isEqual:@"2"]){
            
            //等待关闭
            
        }else if ([switchInfo.switchStatus isEqual:@"3"]){
            //等待开启
        }

        
    }
    
}

-(void)layoutIntegratedDevicesCellView{
    
    [_integratedSwitchNameLabel setFrame:CGRectMake(_integratedSwitchNameLabel.frame.origin.x, self.bounds.size.height/2-_integratedSwitchNameLabel.bounds.size.height/2, DEVICE_AVALIABLE_WIDTH, _integratedSwitchNameLabel.bounds.size.height)];
    _integratedSwitchNameLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [_offBtn setFrame:CGRectMake(_offBtn.frame.origin.x, _offBtn.frame.origin.y, DEVICE_AVALIABLE_WIDTH/2-44/2, self.bounds.size.height)];
    [_onBtn setFrame:CGRectMake(_offBtn.bounds.size.width+44, _onBtn.frame.origin.y,DEVICE_AVALIABLE_WIDTH-_offBtn.bounds.size.width-44, _onBtn.bounds.size.height)];
    
    [_showStateImageView setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH/2-_showStateImageView.bounds.size.width/2, ((DEVICE_AVALIABLE_HEIGHT-64.f-52.f-50.f)/8)-12-3, _showStateImageView.bounds.size.width, _showStateImageView.bounds.size.height)];
    
}


+(CGFloat)heightForIntegratedDeviceCell{
    return (DEVICE_AVALIABLE_HEIGHT-64.f-52.f-50.f)/8;
}


- (IBAction)onClickCloseSwitch:(id)sender {
    
//    //当前时打开
//    if([_switchInfo.switchStatus intValue] == 1){
//        
//        
//    }
    
    //即将关闭
    _switchInfo.switchIsCloseSoon = YES;
    _switchInfo.switchIsOpenSoon = NO;
    self.backgroundColor = [Utility colorWithHexString:@"ddc69d"];
    [_delegate integratedDevicesOnClickCloseSwitch:_switchInfo withIndexPath:_indexPath];
    
}

- (IBAction)onClickOpenSwitch:(id)sender {
    
//    if ([_switchInfo.switchStatus intValue] == 0){
//        
//        
//    }
    _switchInfo.switchIsOpenSoon = YES;
    _switchInfo.switchIsCloseSoon = NO;
    self.backgroundColor = [Utility colorWithHexString:@"ffce74"];
    [_delegate integratedDevicesOnClickOpenSwitch:_switchInfo withIndexPath:_indexPath];
   
}

@end
