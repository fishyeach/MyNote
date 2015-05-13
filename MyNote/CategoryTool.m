//
//  CategoryTool.m
//  MyNote
//
//  Created by xd_ on 15-4-9.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "CategoryTool.h"
#import <sqlite3.h>

#define tableName @"CategoryTable"
#define fatherCategory @"fatherCategory"
#define chridCategory @"chridCategory"
#define flagIncomeOrSpending @"flag"

#define fatherArr @[@"饮食",@"居家",@"衣着",@"娱乐",@"交通",@"通讯",@"其他"]
#define dietArr @[@"早餐",@"午餐",@"晚餐",@"夜宵",@"零食",@"水果"]
#define occupyArr @[@"房租水电",@"洗簌用品",@"床上用品",@"厨房用具"]
#define dressArr @[@"衣服",@"裤子",@"袜子"]
#define entertainmentArr @[@"游戏充值",@"游戏卡"]
#define trafficArr @[@"深圳通",@"车费"]
#define communicationArr @[@"话费"]
#define otherArr @[@"其他"]

#define incomeFlag 1
#define spendingFlag -1

#define cateGoryArr2 @[@"工资",@"奖金",@"彩票",@"捡钱",@"其他"]

#define pickerTag 21


@implementation CategoryTool

static sqlite3 *db;
static void (^categoryBlock)(UIButton *,UIButton *,UIButton *,UIPickerView *);

#pragma mark - 类别选择器
+(void)showCategory:(UIView *)superView withFlag:(int)flag withWichFalg:(int)withcFlag withCallBack:(void (^)(UIButton *,UIButton *,UIButton *,UIPickerView *))callBack{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CategoryPicker" owner:nil options:nil];
    UIView *chirdView = [views objectAtIndex:0];
    chirdView.frame = CGRectMake(0, 0, Screen_width, Screen_height);
    [superView addSubview:chirdView];
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_height - 254, Screen_width, 40)];
    upView.backgroundColor = [UIColor yellowColor];
    [chirdView addSubview:upView];
    
    UIPickerView *pickView = (UIPickerView *)[chirdView viewWithTag:pickerTag];
     categoryBlock = callBack;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_width- 70, 0, 70, 40)];
    btn.backgroundColor = myButtonBg;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [upView addSubview:btn];
    
    if (withcFlag == 1) {
//        [btn addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_width- 70 - 70 - 1, 0, 70, 40)];
        cancelBtn.backgroundColor = myButtonBg;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
         [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [upView addSubview:cancelBtn];
//        [cancelBtn addTarget:self action:@selector(closeCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        allBtn.backgroundColor = myButtonBg;
        [allBtn setTitle:@"全选" forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [upView addSubview:allBtn];
        callBack(allBtn,cancelBtn,btn,pickView);
//        [allBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        editBtn.backgroundColor = myButtonBg;
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [upView addSubview:editBtn];
        
        [btn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        callBack(nil,nil,editBtn,pickView);

    }
    
}

+(void)closeBtn:(UIButton *)btn{
    [btn.superview.superview removeFromSuperview];
}

+(void)enterAction:(UIButton *)btn{
    [btn.superview.superview removeFromSuperview];
}

+(void)closeCancelBtn:(UIButton *)btn{
    [btn.superview.superview removeFromSuperview];
}

+(void)selectAll:(UIButton *)btn{
    [btn.superview.superview removeFromSuperview];
}



#pragma mark - 数据库的操作

+(void)opendDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:dataBaseName];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
    }else{
        NSLog(@"数据库打开成功");
//        [self creatCategoryTable];
//        [self firstAdd];
    }
}

+(void)firstAdd{
    char *err;
    NSArray *objectArr = [[NSArray alloc] initWithObjects:dietArr,occupyArr,dressArr,entertainmentArr,trafficArr,communicationArr,otherArr, nil];
    NSArray *keyArr = fatherArr;
    
    NSDictionary *d = [[NSDictionary alloc] initWithObjects:objectArr forKeys:keyArr];
    
    //        NSMutableArray *dietArrs = [[NSMutableArray alloc] init];
    //        NSMutableArray *occupyArrs = [[NSMutableArray alloc] init];
    //        NSMutableArray *dressArrs = [[NSMutableArray alloc] init];
    //        NSMutableArray *entertainmentArrs = [[NSMutableArray alloc] init];
    //        NSMutableArray *trafficArrs = [[NSMutableArray alloc] init];
    //        NSMutableArray *communicationArrs = [[NSMutableArray alloc] init];
    //        NSMutableArray *otherArrs = [[NSMutableArray alloc] init];
    
    //        NSArray *fatherArr = [[NSArray alloc] initWithObjects:@"%@",@"%@",@"%@",@"%@",@"%@",@"%@",@"%@",dietArr,occupyArr,dressArr,entertainmentArr,trafficArr,communicationArr,otherArr, nil];
    
    for(id key in d){
        for( NSString *name in [d objectForKey:key]){
            NSString *sqlAdd = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@') VALUES ('%@','%d','%@')",tableName,fatherCategory,flagIncomeOrSpending,chridCategory,key,spendingFlag,name];
            
            if (sqlite3_exec(db, [sqlAdd UTF8String], NULL, NULL, &err) != SQLITE_OK) {
                NSLog(@"初始化类别表失败!");
            }else{
                NSLog(@"成功初始化类别表!");
            }
        }
    }
    
    for (int i = 0; i < [cateGoryArr2 count]; i++) {
        NSString *sqlAdd = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@') VALUES ('%@','%d','%@')",tableName,fatherCategory,flagIncomeOrSpending,chridCategory,@"",incomeFlag,[cateGoryArr2 objectAtIndex:i]];
        
        if (sqlite3_exec(db, [sqlAdd UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"2初始化类别表失败!");
        }else{
            NSLog(@"2成功初始化类别表!");
        }
    }
//    for (int i = 0; i < [keyArr count]; i ++) {
//        for (int j = 0; j < [objectArr count]; j ++) {
//            NSString *sqlAdd = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@') VALUES ('%@','%@')",tableName,fatherCategory,chridCategory,[keyArr objectAtIndex:i],[objectArr objectAtIndex:j]];
//
//            if (sqlite3_exec(db, [sqlAdd UTF8String], NULL, NULL, &err) != SQLITE_OK) {
//                NSLog(@"初始化类别表失败!");
//            }else{
//                NSLog(@"成功初始化类别表!");
//            }
//        }
//    }

}

+(void)closeDB{
    sqlite3_close(db);
}

+(void)creatCategoryTable{
    char *err;

    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS CategoryTable (ID INTEGER PRIMARY KEY AUTOINCREMENT, fatherCategory TEXT,flag INTEGER,chridCategory TEXT)";

    if (sqlite3_exec(db, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"数据库表操作数据失败!");
    }else{
        NSLog(@"数据库表操作数据成功!");
        
    }

}

+(NSMutableArray *)getCategoryFromDB:(int)flag{
    NSMutableArray *categoryLists = [NSMutableArray array];
    if (flag == spendingFlag) {
    
        NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT fatherCategory FROM CategoryTable WHERE flag = '%d'",spendingFlag];
        
        sqlite3_stmt * statement;
        NSMutableArray *fatherList_temp = [[NSMutableArray alloc] init];
        NSMutableArray *fatherList = [[NSMutableArray alloc] init];
    
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *father = (char*)sqlite3_column_text(statement, 0);
                NSString *fatherCate = [[NSString alloc]initWithUTF8String:father];
                
                [fatherList_temp addObject:fatherCate];
            }
        }
    
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSNumber *number in fatherList_temp) {
            [dict setObject:number forKey:number];
            
        }
        fatherList = (NSMutableArray *)[dict allValues];
//    NSLog(@"%@",[dict allValues]);
    
        NSString *sqlQuery2;
        NSMutableArray *chridList ;
//    NSLog(@"fatherList的长度:%d",[fatherList count]);
    
        for (id name in fatherList){
            sqlQuery2 = [[NSString alloc] initWithFormat:@"SELECT chridCategory FROM CategoryTable WHERE fatherCategory = '%@' and flag = '%d'",name,spendingFlag];
            chridList = [[NSMutableArray alloc] init];
            if (sqlite3_prepare_v2(db, [sqlQuery2 UTF8String], -1, &statement, nil) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    char *chrid = (char*)sqlite3_column_text(statement, 0);
                    NSString *chridCate = [[NSString alloc]initWithUTF8String:chrid];
                
                [chridList addObject:chridCate];
            }
        }
        NSDictionary *DD = [[NSDictionary alloc] initWithObjectsAndKeys:chridList,name, nil];
        [categoryLists addObject:DD];
//        [chridList removeAllObjects];

    }
    
//    NSLog(@"数据:%@",[[categoryLists objectAtIndex:0] key:@""]);
    
        return categoryLists;
    }else{
       NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT chridCategory FROM CategoryTable WHERE flag = '%d'",incomeFlag];
        sqlite3_stmt * statement;
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *father = (char*)sqlite3_column_text(statement, 0);
                NSString *cateName = [[NSString alloc]initWithUTF8String:father];
                
                [categoryLists addObject:cateName];
            }
        }
        return categoryLists;
    }
}

+(NSMutableArray *)getFatherCate:(int)flag{
    NSMutableArray *fatherList = [NSMutableArray array];
    
        NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT fatherCategory FROM CategoryTable WHERE flag = '%d'",flag];
        
        sqlite3_stmt * statement;
        NSMutableArray *fatherList_temp = [[NSMutableArray alloc] init];
    
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *father = (char*)sqlite3_column_text(statement, 0);
                NSString *fatherCate = [[NSString alloc]initWithUTF8String:father];
                
                [fatherList_temp addObject:fatherCate];
            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSNumber *number in fatherList_temp) {
            [dict setObject:number forKey:number];
            
        }
        fatherList = (NSMutableArray *)[dict allValues];
   
    return fatherList;
}

+(NSMutableArray *)getChirdCate:(NSString *) fatherString withFlag:(int)flag{
    NSMutableArray *chirdList = [NSMutableArray array];
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT chridCategory FROM CategoryTable WHERE flag = '%d' and fatherCategory = '%@'",flag,fatherString];
    
    sqlite3_stmt * statement;
    NSMutableArray *fatherList_temp = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *father = (char*)sqlite3_column_text(statement, 0);
            NSString *fatherCate = [[NSString alloc]initWithUTF8String:father];
            
            [fatherList_temp addObject:fatherCate];
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSNumber *number in fatherList_temp) {
        [dict setObject:number forKey:number];
        
    }
    chirdList = (NSMutableArray *)[dict allValues];
    return chirdList;
}

+(void)editCate:(NSString *)oldFather withNew:(NSString *)str{
    char *err;
    NSString *sqlStr = [NSString stringWithFormat:@"update CategoryTable set fatherCategory = '%@' where fatherCategory = '%@' ", str,oldFather];
    int result = sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, &err);
    if (result != SQLITE_OK) {
        NSLog(@"修改数据失败");
    }else{
        NSLog(@"修改成功");
    }
}
+(void)editCate:(NSString *)oldFather withOldChird:(NSString *)oldChird withNew:(NSString *)newFather withNewChird:(NSString *)newChird{
    char *err;
    NSString *sqlStr = [NSString stringWithFormat:@"update CategoryTable set fatherCategory = '%@' and chridCategory = '%@' where fatherCategory = '%@' and chridCategory = '%@'", newFather,newChird,oldFather,oldChird];
    int result = sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, &err);
    if (result != SQLITE_OK) {
        NSLog(@"修改数据失败");
    }else{
        NSLog(@"修改成功");
    }

}
/**
 *增
 */
+(void)addCate:(NSString *)fatherString withChird:(NSString *)chirdString{
    char *err;
    NSString *sqlAdd = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@') VALUES ('%@','%@')",tableName,fatherCategory,chridCategory,fatherString,chirdString];
    
    if (sqlite3_exec(db, [sqlAdd UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"添加数据失败!");
        
    }else{
        NSLog(@"添加数据成功!");
    }

}

/**
 *删除
 */
+(void)delect:(NSString *)fatherString withChird:(NSString *)chirdString{
    char *err;
    NSString *sqlStr = [NSString stringWithFormat:@"delete from CategoryTable where fatherCategory = '%@' and chridCategory = '%@ " , fatherString,chirdString];
    
    int result = sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, &err);
    if (result == SQLITE_OK) {
        NSLog(@"成功删除");
    }else{
        NSLog(@"删除失败");
    }

}

@end
