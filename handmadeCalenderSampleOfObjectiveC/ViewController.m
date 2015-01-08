//
//  ViewController.m
//  handmadeCalenderSampleOfObjectiveC
//
//  Created by 酒井文也 on 2014/11/04.
//  Copyright (c) 2014年 just1factory. All rights reserved.
//

#import "ViewController.h"

//DeviseSizeクラスのインポート
#import "DeviseSize.h"

//CALayerクラスのインポート
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

//使い回す変数を設定する
{
    int count;
    NSMutableArray *mArray;
    
    //カレンダー表示用メンバ変数
    NSDate *now;
    int year;
    int month;
    int day;
    int maxDay;
    int dayOfWeek;
    
    //カレンダーから取得したものを格納する
    NSUInteger flags;
    NSDateComponents *comps;
    
    //ボタンのバックグラウンドカラー
    UIColor *calendarBackGroundColor;
    
    //カレンダーの位置決め用メンバ変数
    int calendarLabelIntervalX;
    int calendarLabelX;
    int calendarLabelY;
    int calendarLabelWidth;
    int calendarLabelHeight;
    int calendarLableFontSize;
    
    float buttonRadius;
    
    int calendarIntervalX;
    int calendarX;
    int calendarIntervalY;
    int calendarY;
    int calendarSize;
    int calendarFontSize;
}

//プロパティを指定
@property (strong, nonatomic) IBOutlet UILabel *calendarBar;
@property (strong, nonatomic) IBOutlet UIButton *prevMonthButton;
@property (strong, nonatomic) IBOutlet UIButton *nextMonthButton;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //現在起動中のデバイスを取得
    NSString *deviceName = [DeviseSize getNowDisplayDevice];
    
    //iPhone4s
    if([deviceName isEqual:@"iPhone4s"]){
        
        calendarLabelIntervalX = 5;
        calendarLabelX         = 45;
        calendarLabelY         = 93;
        calendarLabelWidth     = 40;
        calendarLabelHeight    = 25;
        calendarLableFontSize  = 14;
        
        buttonRadius           = 20.0;
        
        calendarIntervalX      = 5;
        calendarX              = 45;
        calendarIntervalY      = 120;
        calendarY              = 45;
        calendarSize           = 40;
        calendarFontSize       = 17;
        
    //iPhone5またはiPhone5s
    }else if ([deviceName isEqual:@"iPhone5"]){
        
        calendarLabelIntervalX = 5;
        calendarLabelX         = 45;
        calendarLabelY         = 93;
        calendarLabelWidth     = 40;
        calendarLabelHeight    = 25;
        calendarLableFontSize  = 14;
        
        buttonRadius           = 20.0;
        
        calendarIntervalX      = 5;
        calendarX              = 45;
        calendarIntervalY      = 120;
        calendarY              = 45;
        calendarSize           = 40;
        calendarFontSize       = 17;
        
        //iPhone6
    }else if ([deviceName isEqual:@"iPhone6"]){
        
        calendarLabelIntervalX = 15;
        calendarLabelX         = 50;
        calendarLabelY         = 95;
        calendarLabelWidth     = 45;
        calendarLabelHeight    = 25;
        calendarLableFontSize  = 16;
        
        buttonRadius           = 22.5;
        
        calendarIntervalX      = 15;
        calendarX              = 50;
        calendarIntervalY      = 125;
        calendarY              = 50;
        calendarSize           = 45;
        calendarFontSize       = 19;
        
        self.prevMonthButton.frame = CGRectMake(15, 438, calendarSize, calendarSize);
        self.nextMonthButton.frame = CGRectMake(314, 438, calendarSize, calendarSize);
        
    //iPhone6 plus
    }else if ([deviceName isEqual:@"iPhone6plus"]){
        
        calendarLabelIntervalX = 15;
        calendarLabelX         = 55;
        calendarLabelY         = 95;
        calendarLabelWidth     = 55;
        calendarLabelHeight    = 25;
        calendarLableFontSize  = 18;
        
        buttonRadius           = 25;
        
        calendarIntervalX      = 18;
        calendarX              = 55;
        calendarIntervalY      = 125;
        calendarY              = 55;
        calendarSize           = 50;
        calendarFontSize       = 21;
        
        self.prevMonthButton.frame = CGRectMake(18, 468, calendarSize, calendarSize);
        self.nextMonthButton.frame = CGRectMake(348, 468, calendarSize, calendarSize);
    }
    
    //ボタンを角丸にする
    [self.prevMonthButton.layer setCornerRadius:buttonRadius];
    [self.nextMonthButton.layer setCornerRadius:buttonRadius];
    
    //現在の日付を取得
    now = [NSDate date];
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:now];
    
    //最初にメンバ変数に格納するための現在日付の情報を取得する
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [calendar components:flags fromDate:now];
    
    //年月日と最後の日付を取得(NSIntegerをintへ変換)
    NSInteger orgYear      = comps.year;
    NSInteger orgMonth     = comps.month;
    NSInteger orgDay       = comps.day;
    NSInteger orgDayOfWeek = comps.weekday;
    NSInteger max          = range.length;
    
    year      = (int)orgYear;
    month     = (int)orgMonth;
    day       = (int)orgDay;
    dayOfWeek = (int)orgDayOfWeek;
    
    //月末日(NSIntegerをintへ変換)
    maxDay = (int)max;
    
    //空の配列を作成する（カレンダーデータの格納用）
    mArray = [NSMutableArray new];
    
    //曜日ラベル初期定義
    NSArray *monthName = [NSArray arrayWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil];
    
    //曜日ラベルを動的に配置
    [self setupCalendarLabel:monthName];
    
    //ボタン用の部品配置用の座標を取得する
    [self setupCurrentCalendar];
}

//曜日ラベルの動的配置関数
-(void)setupCalendarLabel:(NSArray *)array
{
    int calendarTitle = 7;
    
    for(int j=0; j<calendarTitle; j++){
        
        UILabel *calendarBaseLabel = [UILabel new];
        calendarBaseLabel.frame = CGRectMake(
            calendarLabelIntervalX + calendarLabelX * (j % calendarTitle),
            calendarLabelY,
            calendarLabelWidth,
            calendarLabelHeight
        );
        
        //日曜日のとき
        if(j == 0){
            calendarBaseLabel.textColor = [UIColor colorWithRed:0.831 green:0.349 blue:0.224 alpha:1.0];
        
        //土曜日のとき
        }else if(j == 6){
            calendarBaseLabel.textColor = [UIColor colorWithRed:0.400 green:0.471 blue:0.980 alpha:1.0];
            
        //平日
        }else{
            calendarBaseLabel.textColor = [UIColor lightGrayColor];
        }
        
        //曜日の配置を行う
        calendarBaseLabel.text = [array objectAtIndex:j];
        calendarBaseLabel.textAlignment = NSTextAlignmentCenter;
        calendarBaseLabel.font = [UIFont systemFontOfSize:calendarLableFontSize];
        [self.view addSubview:calendarBaseLabel];
    }
}

//現在カレンダーのセットアップ
- (void)setupCurrentCalendar
{
    [self setupCurrentCalendarData];
    [self generateCalendar];
    [self setupCalendarTitleLabel];
}

//カレンダーを生成する
- (void)generateCalendar{
    
    //タグナンバーとトータルカウントを定義する
    int tagNumber = 1;
    int total = 42;
    
    //42個のボタンを配置する
    for(int i=0; i<total; i++) {
        
        //配置場所の定義
        int positionX  = calendarIntervalX + calendarX * (i % 7);
        int positionY  = calendarIntervalY + calendarY * (i / 7);
        int buttonSize = calendarSize;
        
        //42個分のボタンを配置
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(positionX,positionY,buttonSize,buttonSize);
        
        if(i < dayOfWeek - 1){
            
            //日付の入らない部分はボタンを押せなくする
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setEnabled:NO];
            
        }else if(i == dayOfWeek - 1 || i < dayOfWeek + maxDay - 1){
            
            //日付の入る部分はボタンのタグを設定する（日にち）
            NSString *tagNumberString = [NSString stringWithFormat:@"%d", tagNumber];
            [button setTitle:tagNumberString forState:UIControlStateNormal];
            button.tag = tagNumber;
            tagNumber++;
            
        }else if(i == dayOfWeek + maxDay - 1 || i < total){
            
            //日付の入らない部分はボタンを押せなくする
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setEnabled:NO];
            
        }
        
        //ボタンデザインと配色の決定
        if(i % 7 == 0){
            calendarBackGroundColor = [UIColor colorWithRed:0.831 green:0.349 blue:0.224 alpha:1.0];
        }else if(i % 7 == 6){
            calendarBackGroundColor = [UIColor colorWithRed:0.400 green:0.471 blue:0.980 alpha:1.0];
        }else{
            calendarBackGroundColor = [UIColor lightGrayColor];
        }
        
        //ボタンのデザインを決定する
        [button setBackgroundColor:calendarBackGroundColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:calendarFontSize]];
        [button.layer setCornerRadius:buttonRadius];
        
        //配置したボタンに押した際のアクションを設定する
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //ボタンを配置する
        [self.view addSubview:button];
        [mArray addObject:button];
    }
}

//現在の年月に該当するデータを取得
- (void)setupCurrentCalendarData
{
    //inUnitで指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    //該当月の1日の情報を取得する（※カレンダーが始まる場所を取得するため）
    [currentComps setYear:year];
    [currentComps setMonth:month];
    [currentComps setDay:1];
    NSDate *currentDate = [currentCalendar dateFromComponents:currentComps];
    
    //カレンダー情報を再作成する
    [self recreateCalendarParameter:currentCalendar dateObject:currentDate];
}

//prevボタン押下に該当するデータを取得
- (void)setupPrevCalendarData
{
    //前の月を設定する
    if(month == 0){
        year = year - 1;
        month = 12;
    }else{
        month = month - 1;
    }
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *prevCalendar = [NSCalendar currentCalendar];
    NSDateComponents *prevComps = [[NSDateComponents alloc] init];
    
    //該当月の1日の情報を取得する（※カレンダーが始まる場所を取得するため）
    [prevComps setYear:year];
    [prevComps setMonth:month];
    [prevComps setDay:1];
    NSDate *prevDate = [prevCalendar dateFromComponents:prevComps];
    
    //カレンダー情報を再作成する
    [self recreateCalendarParameter:prevCalendar dateObject:prevDate];
}

//nextボタン押下に該当するデータを取得
- (void)setupNextCalendarData
{
    //次の月を設定する
    if(month == 12){
        year = year + 1;
        month = 1;
    }else{
        month = month + 1;
    }
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *nextCalendar = [NSCalendar currentCalendar];
    NSDateComponents *nextComps = [[NSDateComponents alloc] init];
    
    //該当月の1日の情報を取得する（※カレンダーが始まる場所を取得するため）
    [nextComps setYear:year];
    [nextComps setMonth:month];
    [nextComps setDay:1];
    NSDate *nextDate = [nextCalendar dateFromComponents:nextComps];
    
    //カレンダー情報を再作成する
    [self recreateCalendarParameter:nextCalendar dateObject:nextDate];
}

//カレンダーのパラメータを作成する関数
- (void)recreateCalendarParameter:(NSCalendar *)currentCalendar dateObject:(NSDate *)currentDate
{
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [currentCalendar components:flags fromDate:currentDate];
    
    NSRange currentRange = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    
    //年月日と最後の日付を取得(NSIntegerをintへ変換)
    NSInteger currentYear      = comps.year;
    NSInteger currentMonth     = comps.month;
    NSInteger currentDay       = comps.day;
    NSInteger currentDayOfWeek = comps.weekday;
    NSInteger currentMax       = currentRange.length;
    
    year      = (int)currentYear;
    month     = (int)currentMonth;
    day       = (int)currentDay;
    dayOfWeek = (int)currentDayOfWeek;
    maxDay    = (int)currentMax;
}

- (IBAction)getNextMonthData:(id)sender
{
    //表示されているボタンオブジェクトを削除
    [self removeCalendarButtonObject];
    
    //カレンダーのセットアップ
    [self setupNextCalendarData];
    [self generateCalendar];
    [self setupCalendarTitleLabel];
}

- (IBAction)getPrevMonthData:(id)sender
{
    //表示されているボタンオブジェクトを削除
    [self removeCalendarButtonObject];

    //カレンダーのセットアップ
    [self setupPrevCalendarData];
    [self generateCalendar];
    [self setupCalendarTitleLabel];
}

//表示されているボタンオブジェクトを一旦削除する
- (void)removeCalendarButtonObject
{
    //ビューからボタンオブジェクトを削除する
    for (int i=0; i<[mArray count]; i++) {
        [mArray[i] removeFromSuperview];
    }
    
    //配列に格納したボタンオブジェクトも削除する
    [mArray removeAllObjects];
}

//カレンダーボタンタップ時の処理
-(void)buttonTapped:(UIButton *)button
{
    NSLog(@"%d年%d月%d日が選択されました！", year, month, (int)button.tag);
}

//タイトルバーの設定
- (void)setupCalendarTitleLabel
{
    //押された日付を表示する
    self.calendarBar.text = [NSString stringWithFormat:@"%d年%d月のカレンダー", year, month];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
