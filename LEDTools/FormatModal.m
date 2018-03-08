//
//  FormatModal.m
//  BluetoothLED
//
//  Created by 奇鹭 on 2017/12/9.
//  Copyright © 2017年 xieyongxu. All rights reserved.
//

#import "FormatModal.h"
#import "Tools.h"
@implementation FormatModal

- (id)copyWithZone:(NSZone *)zone
{
    FormatModal *model = [[[self class] allocWithZone:zone] init];
    
    model.text = self.text;
    
    model.textUIColor = self.textUIColor;
    
    model.textNumber = self.textNumber;
    
    model.textColour = self.textColour;
    
    model.textEffect = self.textEffect;
    
    model.speed = self.speed;
    
    model.brightness = self.brightness;
    
    return model;
}

- (NSString *)textLength
{
    NSString *length = [NSString stringWithFormat:@"%ld/250", (long)[Tools calculateTextBytes:self.text]];
    
    return length;
}

- (NSInteger)textSizeNumber
{
    NSInteger number = [self.textSize integerValue];
    
    return number;
}

- (NSInteger)textFontNumber
{
    NSArray *fontArray = @[NSLocalizedString(@"正体", nil) ,NSLocalizedString(@"斜体", nil) ,NSLocalizedString(@"粗体", nil)];
    
    NSInteger number = [fontArray indexOfObject:NSLocalizedString(self.textFont, nil)];
    
    return number;
}

- (NSMutableArray *)pixelArray
{
    for (int i=0; i<self.datasArray.count; ++i) {
        [[Tools shareInstance]calculateBinary:[self.datasArray[i] integerValue] calculateTimes:8];
    }

    return [Tools shareInstance].pixelsArray;
}

- (NSInteger)textwidthNumber
{
    NSInteger number = [Tools calculateTextBits:self];
    
    return number;
}

- (NSInteger)textEffect
{
    if (!_textEffect)
    {
        self.textEffect = 1;
    }
    return _textEffect;
}

- (NSInteger)textNumber
{
    if (!_textNumber)
    {
        self.textNumber = 1;
    }
    return _textNumber;
}

- (NSInteger)textColour
{
    if (!_textColour)
    {
        self.textColour = 1;
    }
    return _textColour;
}

- (NSInteger)cellHeight
{
    if (!_cellHeight)
    {
        self.cellHeight = 44;
    }
    return _cellHeight;
}

- (NSInteger)speed
{
    if (!_speed)
    {
        self.speed = 1;
    }
    return _speed;
}

- (NSInteger)brightness
{
    if (!_brightness)
    {
        self.brightness = 1;
    }
    return _brightness;
}
@end
