//
//  Tools.m
//  BluetoothLED
//
//  Created by 奇鹭 on 2017/12/9.
//  Copyright © 2017年 xieyongxu. All rights reserved.
//

#import "Tools.h"
#import <UIKit/UIKit.h>
extern unsigned char unicode_12_cn_zbuf[1572864];
extern unsigned char unicode_12_cn_cbuf[1572864];
extern unsigned char unicode_12_cn_xbuf[1572864];
extern unsigned char unicode_16_cn_zbuf[2097152];
extern unsigned char unicode_16_cn_cbuf[2097152];
extern unsigned char unicode_16_cn_xbuf[2097152];
extern unsigned char ascii_12_en_zbuf[3072];
extern unsigned char ascii_12_en_cbuf[3072];
extern unsigned char ascii_12_en_xbuf[3072];
extern unsigned char ascii_16_en_zbuf[4096];
extern unsigned char ascii_16_en_cbuf[4096];
extern unsigned char ascii_16_en_xbuf[4096];

typedef NS_ENUM(NSUInteger, toolType) {
    calHeadZore = 1 << 0,
    offsetHeadZore = 1 << 1,
    formatData = 1 << 2,
    calTailZore = 1 << 3,
    offsetTailZore = 1 << 4,
    checkIfBlank = 1 << 5,
};

static Tools *tool = nil;

@implementation Tools

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [Tools new];
    });
    return tool;
}

- (instancetype)init
{
    return [super init];
}

+ (void)open_file_name:(const char *)file list:(unsigned char*)list_buf
{
    long length = -1;
    FILE *fp = fopen(file, "rb");
    if (fp == NULL) {
        return ;
    }
    
    fseek(fp, 0, SEEK_END);
    length = ftell(fp);
    
    rewind(fp);
    
    fread(list_buf, 1, length, fp);
    NSLog(@"文件长度:%ld", length);
    fclose(fp);
}

- (NSMutableArray *)modelArray
{
    if (!_modelArray)
    {
        NSArray *coloursArray = @[UIColor.redColor, UIColor.yellowColor, UIColor.greenColor,UIColor.cyanColor,UIColor.blueColor,UIColor.purpleColor,UIColor.whiteColor];
        
        self.modelArray = [NSMutableArray new];
        
        for (int i=0; i<8; ++i) {
            FormatModal *model = [FormatModal new];
            
            NSInteger textColour = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%dColour", i+1]];
            
            NSString *text = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%dText", i+1]];
            
            NSInteger textEffect = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%dEffect", i+1]];
            
            NSInteger speed = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%dSpeed", i+1]];
            
            NSInteger brightnesss = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%dBrightnesss", i+1]];
            
            model.textSize = @"12";
            
            model.textFont = NSLocalizedString(@"正体", nil);
            
            model.textNumber = i+1;
            
            if (text)
            {
                model.text = text;
            }
            else
            {
                model.text = [NSString stringWithFormat:@"MESSAGE%d", i+1];
            }
            
            if (textColour)
            {
                model.textColour = textColour;
                
                model.textUIColor = coloursArray[textColour-1];
            }
            else
            {
                model.textColour = 1;
                
                model.textUIColor = [UIColor redColor];
            }
            
            if (textEffect)
            {
                model.textEffect = textEffect;
            }
            
            if (speed)
            {
                model.speed = speed;
            }
            
            if (brightnesss)
            {
                model.brightness = brightnesss;
            }
            
            [self.modelArray addObject:model];
        }
    }
    return _modelArray;
}

- (NSMutableArray *)settingModelArray
{
    if (!_settingModelArray)
    {
        NSArray *coloursArray = @[UIColor.redColor, UIColor.yellowColor, UIColor.greenColor,UIColor.cyanColor,UIColor.blueColor,UIColor.purpleColor,UIColor.whiteColor];

        self.settingModelArray = [NSMutableArray new];
        
        for (int i=0; i<8; ++i) {
            FormatModal *model = [FormatModal new];
            
            NSInteger textColour = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%dColour", i+1]];

            NSString *text = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%dText", i+1]];
            
            if (textColour)
            {
                model.textUIColor = coloursArray[textColour-1];
            }
            else
            {
                model.textUIColor = [UIColor redColor];
            }
            
            if (text)
            {
                model.text = text;
            }
            else
            {
                model.text = [NSString stringWithFormat:@"MESSAGE%d", i+1];
            }
            
            [self.settingModelArray addObject:model];
        }
    }
    return _settingModelArray;
}

+ (NSInteger)calculateTextBytes:(NSString *)text
{
    float totalBtyes = 0;
    
    for (int i=0; i<text.length; ++i) {
        NSString *subString = [text substringWithRange:NSMakeRange(i, 1)];
        
        if ([subString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1)
        {
            totalBtyes += 1;
        }
        else
        {
            totalBtyes += 0.5;
        }
    }
    
    return (NSInteger)totalBtyes;
}

+ (NSInteger)calculateTextBits:(FormatModal *)model
{
    NSInteger totalBits = 0;
    totalBits = model.datasArray.count/model.textSizeNumber;

//    for (int i=0; i<model.text.length; ++i) {
//        NSString *subString = [model.text substringWithRange:NSMakeRange(i, 1)];
//
//        if ([subString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1)
//        {
//            totalBits += model.textSizeNumber;
//        }
//        else
//        {
//            totalBits += 8;
//        }
//    }
    
    return totalBits*8;
}

+ (NSInteger)calculateSingleTextBits:(NSString *)text size:(NSInteger)size
{
    NSInteger totalBits = 0;
    
    if ([text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1)
    {
        totalBits += size;
    }
    else
    {
        totalBits += 8;
    }
    
    return totalBits;
}

+ (NSMutableArray *)getDataFromDZKFile:(FormatModal *)model
{
    NSMutableArray *dataArray = [NSMutableArray new];
    
    for (int i=0; i<model.text.length; ++i) {
        NSMutableArray *singleDataArray = [NSMutableArray new];
        
        unichar iChar = [model.text characterAtIndex:i];
        
        NSString *subString = [model.text substringWithRange:NSMakeRange(i, 1)];
        
        if ([subString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1)
        {
            if (model.textSizeNumber == 12)
            {
                NSInteger startPoint = iChar * 24;
                
                switch (model.textFontNumber) {
                    case 0:
                    {
                        for (int j=0; j<24; ++j) {
                            [singleDataArray addObject:@(unicode_12_cn_zbuf[startPoint+j])];
                        }
                    }
                        break;
                    case 1:
                    {
                        for (int j=0; j<24; ++j) {
                            [singleDataArray addObject:@(unicode_12_cn_xbuf[startPoint+j])];
                        }
                    }
                        break;
                    case 2:
                    {
                        for (int j=0; j<24; ++j) {
                            [singleDataArray addObject:@(unicode_12_cn_cbuf[startPoint+j])];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
            else if (model.textSizeNumber == 16)
            {
                NSInteger startPoint = iChar * 32;
                
                switch (model.textFontNumber) {
                    case 0:
                    {
                        for (int j=0; j<32; ++j) {
                            [singleDataArray addObject:@(unicode_16_cn_zbuf[startPoint+j])];
                        }
                    }
                        break;
                    case 1:
                    {
                        for (int j=0; j<32; ++j) {
                            [singleDataArray addObject:@(unicode_16_cn_xbuf[startPoint+j])];
                        }
                    }
                        break;
                    case 2:
                    {
                        for (int j=0; j<32; ++j) {
                            [singleDataArray addObject:@(unicode_16_cn_cbuf[startPoint+j])];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        else
        {
            NSInteger startPoint = iChar * 12;
            
            if (model.textSizeNumber == 12)
            {
                switch (model.textFontNumber) {
                    case 0:
                    {
                        for (int j=0; j<12; ++j) {
                            [singleDataArray addObject:@(ascii_12_en_zbuf[startPoint+j])];
                        }
                    }
                        break;
                    case 1:
                    {
                        for (int j=0; j<12; ++j) {
                            [singleDataArray addObject:@(ascii_12_en_xbuf[startPoint+j])];
                        }
                    }
                        break;
                    case 2:
                    {
                        for (int j=0; j<12; ++j) {
                            [singleDataArray addObject:@(ascii_12_en_cbuf[startPoint+j])];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
            else if (model.textSizeNumber == 16)
            {
                NSInteger startPoint = iChar * 16;
                
                switch (model.textFontNumber) {
                    case 0:
                    {
                        for (int j=0; j<16; ++j) {
                            [singleDataArray addObject:@(ascii_16_en_zbuf[startPoint+j])];
                        }
                    }
                        break;
                    case 1:
                    {
                        for (int j=0; j<16; ++j) {
                            [singleDataArray addObject:@(ascii_16_en_xbuf[startPoint+j])];
                        }
                    }
                        break;
                    case 2:
                    {
                        for (int j=0; j<16; ++j) {
                            [singleDataArray addObject:@(ascii_16_en_cbuf[startPoint+j])];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        
        [dataArray addObject:singleDataArray];
    }
    NSMutableArray *resultArray = [self jointDatas:dataArray formalModel:model];

    return resultArray;
}

+ (NSMutableArray *)jointDatas:(NSMutableArray *)dataArray formalModel:(FormatModal *)model
{
    NSMutableArray *resultDatasArray = [NSMutableArray new];
    
    if (model.textSizeNumber/16)
    {
        for (int i=0; i<model.textSizeNumber; ++i) {
            for (int j=0; j<dataArray.count; ++j) {
                NSMutableArray *singleArray = dataArray[j];
                for (int k=0; k<singleArray.count/model.textSizeNumber; ++k) {
                    [resultDatasArray addObject:singleArray[i*(singleArray.count/model.textSizeNumber)+k]];
                }
            }
        }
        
        return resultDatasArray;
    }
    
    Tools *tempTool = [[Tools alloc]init];
//    NSInteger bits = 0;
//    NSInteger lastDataNumberOfZore = 0;
    
    for (int i=0;i<dataArray.count;++i)
    {
        [tempTool.pixelsArray removeAllObjects];
        
        NSInteger sinCharNumberOfHeadZore = 0;
        
        NSMutableArray *tempArray = dataArray[i];
        
        sinCharNumberOfHeadZore = [[tempTool innerSpecialTools:calHeadZore object:tempArray, model, tempTool, nil] integerValue];

//        NSString *text = [model.text substringWithRange:NSMakeRange(i, 1)];
        
        if (sinCharNumberOfHeadZore >= 1/* && !([text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1)*/)
        {
            [tempTool innerSpecialTools:offsetHeadZore object:tempArray, model, @(sinCharNumberOfHeadZore), nil];
        }
    }
    
    for (int j=0; j<dataArray.count; ++j) {
        BOOL needJoint = NO;
        
        NSMutableArray *currentArray = dataArray[j];
        NSMutableArray *nextArray;
        
        if (j+1<dataArray.count)
        {
            nextArray = [NSMutableArray new];
            nextArray = dataArray[j+1];
        }
        
        if (!resultDatasArray.count)
        {
            for (NSNumber *dataNumber in currentArray) {
                [resultDatasArray addObject:dataNumber];
            }
        }

//        bits += [self calculateSingleTextBits:[model.text substringWithRange:NSMakeRange(j, 1)] size:12];

//        if (bits % 8)
//        {
//            needJoint = YES;
//        }
        
        NSInteger avg = resultDatasArray.count/model.textSizeNumber; //每行几个字节
        NSInteger numberOfzore = 0;
        NSInteger blockInteger = 0;
        
        numberOfzore = [[tempTool innerSpecialTools:formatData object:resultDatasArray, model, nil] integerValue];

        blockInteger = [[tempTool innerSpecialTools:calTailZore object:tempTool, @(numberOfzore), nil] integerValue];
        
        if (blockInteger <= 1)
        {
            needJoint = NO;
        }
        else
        {
            needJoint = YES;
//            if (blockInteger == 8)
//            {
//                blockInteger = lastDataNumberOfZore;
//////                blockInteger = lastDataNumberOfZore>8?8:lastDataNumberOfZore+4;
//            }
//            else
//            {
                blockInteger -= 1;
                
//                lastDataNumberOfZore = blockInteger;
            
//            }
//            if (lastDataNumberOfZore)
//            {
//                blockInteger = lastDataNumberOfZore;
//            }
        }
//        NSLog(@"blockInteger>>>>%ld", blockInteger);
        NSInteger maxIndex = nextArray.count/model.textSizeNumber;
        
        NSInteger originMaxCount = resultDatasArray.count;
        
        for (int i=0; i<model.textSizeNumber; ++i) {
            for (int k=0; k<maxIndex; ++k) {
                NSInteger nextData = [nextArray[i*(nextArray.count/model.textSizeNumber)+k] integerValue];
                
                if (needJoint)
                {
                    NSInteger newMacCount = resultDatasArray.count;
                    //(avg-1) + (i*avg)
//                    NSInteger thisindex = (avg-1)+(i*avg)+k+i;
                    NSInteger thisindex = (avg-1) + (i*avg)+k + (originMaxCount==newMacCount?0:i);

//                    NSLog(@"thisindex>>>>>%ld", thisindex);
                    NSInteger nextIndex = thisindex+1;
                    
                    if(k)
                    {
                        NSInteger secondOffsetData = ([nextArray[i*2] integerValue] << 4) | ([nextArray[i*2+1] integerValue] >> 4);
                        
                        [resultDatasArray replaceObjectAtIndex:thisindex withObject:@(secondOffsetData)];
                    }
                    else
                    {
                        NSInteger singleData = [resultDatasArray[thisindex] integerValue];
                        
                        NSInteger nextData = [nextArray[i*(nextArray.count/model.textSizeNumber)] integerValue];
                        
                        NSInteger firstJointData = singleData | (nextData >> (maxIndex>1?4:(8-blockInteger)));
                        
                        NSInteger secondJointData = nextData << (maxIndex>1?4:blockInteger);
                        
                        [resultDatasArray replaceObjectAtIndex:thisindex withObject:@(firstJointData)];
                        
                        BOOL needInsert = [[tempTool innerSpecialTools:checkIfBlank object:nextArray, @(blockInteger), nil] boolValue];

                        if (maxIndex>1)
                        {
                            needInsert = YES;
                        }

                        if (needInsert)
                        {
                            [resultDatasArray insertObject:@(secondJointData) atIndex:nextIndex];
                        }
                    }
                }
                else
                {
                    if (blockInteger == 0 && !(maxIndex>1))
                    {
                        nextData = nextData >> 1;
                    }
                    [resultDatasArray insertObject:@(nextData) atIndex:i*avg+avg+(i*(nextArray.count/model.textSizeNumber))+k];
                }
            }
        }
    }
    
    return resultDatasArray;
}

- (id)innerSpecialTools:(toolType)toolType object:(id)object, ...NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *listObjectArray = [NSMutableArray new];
    
    va_list list;
    
    va_start(list, object);
    
    id obj;
    
    if (object)
    {
        [listObjectArray addObject:object];
    }
    while((obj = va_arg(list, id)))
    {
        [listObjectArray addObject:obj];
    }
    
    if (toolType & calHeadZore)
    {
        NSInteger sinCharNumberOfzore = 0;
        NSInteger sinCharNumberOfHeadZore = 0;
        
        NSMutableArray *tempArray = (NSMutableArray *)listObjectArray[0];
        
        FormatModal *model = listObjectArray[1];
        
        NSInteger avg = tempArray.count/model.textSizeNumber;
        
        for (int i=0; i<model.textSizeNumber; ++i) {
            
            NSInteger lastDataEachRow = (avg-1) + (i*avg);
            
            NSInteger data = [tempArray[lastDataEachRow] integerValue];
            
            sinCharNumberOfzore |= data;
        }
        
        Tools *tempTool = listObjectArray[2];
        
        [tempTool.pixelsArray removeAllObjects];
        
        [tempTool calculateBinary:sinCharNumberOfzore calculateTimes:8];
        
        for (NSNumber *numberObj in tempTool.pixelsArray) {

            NSInteger headBinaryInteger = [numberObj integerValue];

            if (!headBinaryInteger)
            {
                sinCharNumberOfHeadZore++;
            }
            else
            {
                break;
            }
        }
        
        va_end(list);
        
        return @(sinCharNumberOfHeadZore);
    }
    else if (toolType & offsetHeadZore)
    {
        NSMutableArray *tempArray = (NSMutableArray *)listObjectArray[0];
        
        FormatModal *model = listObjectArray[1];
        
        NSInteger avg = tempArray.count/model.textSizeNumber;
        
        NSInteger sinCharNumberOfHeadZore = [listObjectArray[2] integerValue];
        
        for (int i=0; i<model.textSizeNumber; ++i) {
            
            NSInteger lastDataEachRow = (avg-1) + (i*avg);
            
            NSInteger data = [tempArray[lastDataEachRow] integerValue];
            
            data = data << sinCharNumberOfHeadZore;
            
            [tempArray replaceObjectAtIndex:lastDataEachRow withObject:@(data)];
        }
    }
    else if (toolType & formatData)
    {
        NSInteger numberOfzore = 0;
        
        NSMutableArray *tempArray = (NSMutableArray *)listObjectArray[0];
        
        FormatModal *model = listObjectArray[1];
        
        NSInteger avg = tempArray.count/model.textSizeNumber;
        
        for (int i=0; i<model.textSizeNumber; ++i) {
            //            NSInteger firstDataEachRow = i * avg; //每行最左边的字节
            NSInteger lastDataEachRow = (avg-1) + (i*avg);
            
            NSInteger data = [tempArray[lastDataEachRow] integerValue];
            
            numberOfzore |= data;
        }
        va_end(list);
        
        return @(numberOfzore);
    }
    else if (toolType & calTailZore)
    {
        __block typeof (NSInteger) blockInteger = 0;
        
        Tools *tempTool = listObjectArray[0];
        
        NSInteger numberOfzore = [listObjectArray[1] integerValue];
        
        [tempTool.pixelsArray removeAllObjects];
        
        [tempTool calculateBinary:numberOfzore calculateTimes:8];
        
//        NSLog(@"pixelsArray:%@", tempTool.pixelsArray);
        
        [tempTool.pixelsArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSNumber *binary, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSInteger binaryInteger = [binary integerValue];
            
            if (!binaryInteger)
            {
                blockInteger++;
            }
            else
            {
                *stop = YES;
            }
        }];
        va_end(list);
        
        return @(blockInteger);
    }
    else if (toolType & offsetTailZore)
    {
        //往后按位偏移
    }
    else if (toolType & checkIfBlank)
    {
        //检查偏移后的字符是否为空
        NSMutableArray *nextArray = (NSMutableArray *)listObjectArray[0];

        NSInteger blockInteger = [listObjectArray[1] integerValue];
        
        Byte tempNumber = 0;
        
        BOOL needInsert = NO;
        
        for (NSNumber *number in nextArray)
        {
            if ([number unsignedCharValue])
            {
                tempNumber = 1;
                break;
            }
        }
        
        if (!tempNumber)
        {
            needInsert = YES;
            
            va_end(list);
            
            return @(needInsert);
        }
        
        for (NSNumber *number in nextArray)
        {
            if ((Byte)([number unsignedCharValue] << blockInteger))
            {
                needInsert = YES;
                
                va_end(list);
                
                return @(needInsert);
            }
        }
        
        va_end(list);
        
        return @(needInsert);
    }
    
    va_end(list);

    return 0;
}

- (void)calculateBinary:(NSInteger)hex calculateTimes:(NSInteger)times
{
    if (times -= 1)
    {
        [self calculateBinary:hex / 2 calculateTimes:times];
    }
    
    NSInteger binary = hex % 2;
    
    [self.pixelsArray addObject:@(binary)];
}

- (NSMutableArray *)pixelsArray
{
    if (!_pixelsArray)
    {
        self.pixelsArray = [NSMutableArray new];
    }
    return _pixelsArray;
}

@end
