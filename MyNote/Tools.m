//
//  Tools.m
//  MyNote
//
//  Created by xd_ on 15-4-15.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "Tools.h"
#import "MBProgressHUD.h"
#import "CategoryTool.h"



@implementation Tools

#define upBtnCancelTag 7
#define upBtnEnter 8



static MBProgressHUD *HUD;
static UIApplication *app;
static void (^callbackBlock)(int tag);

/**
 *获取现在的日期
 */
+(NSString *)getNowTime{
    NSDateFormatter *fornatter = [[NSDateFormatter alloc] init];
    [fornatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *nowDate = [fornatter stringFromDate:[NSDate date]];
    
    NSLog(@"DATE:%@",nowDate);
    return nowDate;
}
/**
 *把datapicker的时间转化成年月日（int）
 */
+(NSArray *)getTimeArrFromDataPicker:(NSString *)datapicker_time{
    NSString *year = [[datapicker_time componentsSeparatedByString:@"年"]  objectAtIndex:0] ;
    NSString *month = [[[[datapicker_time componentsSeparatedByString:@"年"]  objectAtIndex:1] componentsSeparatedByString:@"月"]  objectAtIndex:0] ;
    NSString *day = [[[[[[datapicker_time componentsSeparatedByString:@"年"]  objectAtIndex:1] componentsSeparatedByString:@"月"]  objectAtIndex:1] componentsSeparatedByString:@"日"]  objectAtIndex:0] ;
    
    NSArray *timeArr = [[NSArray alloc] initWithObjects:year,month,day,nil];
    NSLog(@"年月日:%@,%@,%@",year,month,day);
    return timeArr;
}

+(NSArray *)getCategoryArr:(NSString *)cateString{
//    NSLog(@"cateString=%@",cateString);
    NSArray *arr = [cateString componentsSeparatedByString:@"-"];
//    NSLog(@"arr=:%@",arr);
//    NSLog(@"arr的长度:%lu",(unsigned long)[arr count]);
    NSArray *result;
    if ([arr count] == 1) {
        result = [[NSArray alloc] initWithObjects:@"",cateString, nil];
        return result;
    }else{
        result = [[NSArray alloc] initWithObjects:[arr objectAtIndex:0],[arr objectAtIndex:1], nil];
        return result;
    }
}

//加载器
+ (void)showHUD:(NSString *)msg{
    app = [UIApplication sharedApplication];
    [self showIndicator];
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText = msg;
    [HUD show:YES];
}
+ (void)removeHUD{
    
    [HUD hide:YES];
    [HUD removeFromSuperViewOnHide];
    [self showIndicator];
}
+ (void)showIndicator{
    if (app != nil) {
        if (app.isNetworkActivityIndicatorVisible) {
            app.networkActivityIndicatorVisible = NO;
        }else {
            app.networkActivityIndicatorVisible = YES;
        }
    }
}

+(UIImage *)getImageFromColor:(UIColor *)color withView:(UIView *)btn{
    CGRect rect = CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(void)addBtnForKeyBoard:(UITextField *)textField withCallback:(void (^)(int tag))callback{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AddDateBtn" owner:nil options:nil];
    UIView *chirdView = [views objectAtIndex:0];
    chirdView.frame = CGRectMake(0, 0, Screen_width, 30);
    textField.inputAccessoryView = chirdView;
        
    UIButton *cancelBtn = (UIButton *)[chirdView viewWithTag:upBtnCancelTag];
    UIButton *enterBtn = (UIButton *)[chirdView viewWithTag:upBtnEnter];
    
    [cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [enterBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    callbackBlock = callback;
}

+(void)btnAction:(UIButton *)btn{
    if (btn.tag == upBtnCancelTag) {
        callbackBlock(upBtnCancelTag);
    }else if(btn.tag == upBtnEnter){
        callbackBlock(upBtnEnter);
    }
    
}

+(int)getWeekOfFirstDayOfMonth{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowDateComps = [[NSDateComponents alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    nowDateComps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate];
    
    int year = (int)[nowDateComps year];
    int month = [nowDateComps month];
    
    NSString *firstWeekDayMonth = [[NSString alloc] initWithFormat:@"%d",year];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%s","-"]];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%d",month]];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%s","-"]];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%d",1]];
    
    NSDate *weekOfFirstDayOfMonth = [dateFormatter dateFromString:firstWeekDayMonth];
    
    NSDateComponents *newCom = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:weekOfFirstDayOfMonth];
    //    nowDateComps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:weekOfFirstDayOfMonth];
    
    NSString *locationString=[dateFormatter stringFromDate:weekOfFirstDayOfMonth];
    NSLog(@"日期-----%@",locationString);
    //   0 NSLog(@"weekofmonth:%d",(int)[nowDateComps weekOfMonth]);
    
    
    return  (int)[newCom weekday] - 1;
}

+(int)getDaysOfMonth:(int)year withMonth:(int)month{
    
    NSInteger days = 0;
    //1,3,5,7,8,10,12
    NSArray *bigMoth = [[NSArray alloc] initWithObjects:@"1",@"3",@"5",@"7",@"8",@"10",@"12", nil];
    //4,6,9,11
    NSArray *milMoth = [[NSArray alloc] initWithObjects:@"4",@"6",@"9",@"11", nil];
    
    if ([bigMoth containsObject:[[NSString alloc] initWithFormat:@"%ld",(long)month]]) {
        days = 31;
    }else if([milMoth containsObject:[[NSString alloc] initWithFormat:@"%ld",(long)month]]){
        days = 30;
    }else{
        if ([self isLoopYear:year]) {
            days = 29;
        }else
            days = 28;
    }
    return (int)days;
}

//判断是否是闰年
+(BOOL)isLoopYear:(NSInteger)year{
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return true;
    }else
        return NO;
}

+(NSString *)stringDisposeWithFloat:(double)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%f",floatValue];
    int len = (int)str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}

+(void)addBorder:(UIView *)view{
    view.layer.cornerRadius = 3;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1;
    [view.layer setBorderColor:[[UIColor colorWithWhite:20 alpha:0.8] CGColor]];
}


UIPickerView *mPicker ;
UIButton *thisbtn1;
UIButton *thisbtn2;
UIButton *thisbtn3;
/**
 *显示类别选择器
 */
+(void)showCategoryPicker:(UIViewController *)viewController withWhichPicker:(int)whichCategory withCallBack:(void(^)(UIButton *,UIButton *,UIButton *,UIPickerView *))callBack{
   
    [CategoryTool opendDB];
    [CategoryTool showCategory:viewController.view withFlag:whichCategory withWichFalg:1 withCallBack:^(UIButton *btn1,UIButton *btn2,UIButton *btn3,UIPickerView *MpickerView){
        
        thisbtn1 = btn1;
        thisbtn2 = btn2;
        thisbtn3 = btn3;
        mPicker = MpickerView;
      
        
    }];
    callBack(thisbtn1,thisbtn2,thisbtn3,mPicker);
     
    [CategoryTool closeDB];
    
}

+(NSMutableString *)textFiledEdit:(NSString *)text{
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%@",text];
    
    NSUInteger lengthOfString = text.length;
  
    if ([text characterAtIndex:lengthOfString - 1] == '.') {
        
        if (lengthOfString == 1) {
            if ([str rangeOfString:@"."].location != NSNotFound) {
                [str deleteCharactersInRange:NSMakeRange(lengthOfString - 1 , 1)];
            }
            
            
            
        }else if(lengthOfString > 2){
            for (int i = 1; i < lengthOfString - 1; i++ ) {
                unichar character = [text characterAtIndex:i];
                if (character == '.') {
                    [str deleteCharactersInRange:NSMakeRange(lengthOfString - 1 , 1)];
                    break;
                }
            }
            
        }
    }
    
    if (lengthOfString != 0) {
        if ([text characterAtIndex:lengthOfString - lengthOfString] == '0') {
            if (lengthOfString == 2) {
                if ([str rangeOfString:@"."].location == NSNotFound) {
                    [str deleteCharactersInRange:NSMakeRange(lengthOfString - 1 , 1)];
                }
            }
        }
    }
    
    
    return str;
}

@end
