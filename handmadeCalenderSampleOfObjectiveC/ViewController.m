//
//  ViewController.m
//  handmadeCalenderSampleOfObjectiveC
//
//  Created by 酒井文也 on 2014/11/04.
//  Copyright (c) 2014年 just1factory. All rights reserved.
//

#import "ViewController.h"

//CALayerクラスのインポート
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

//プロパティを指定
{
    int count;
    NSMutableArray *mArray;
    
    //カレンダー表示用変数
    NSDate *now;
    int year;
    int month;
    int day;
    int maxDay;
    int dayOfWeek;
    
    NSUInteger flags;
    NSDateComponents *comps;
    
    UIColor *calendarBackGroundColor;
}

@property (strong, nonatomic) IBOutlet UILabel *calendarBar;

@property (strong, nonatomic) IBOutlet UIButton *prevMonthButton;
@property (strong, nonatomic) IBOutlet UIButton *nextMonthButton;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ボタンを角丸にする
    [self.prevMonthButton.layer setCornerRadius:5.0];
    [self.nextMonthButton.layer setCornerRadius:5.0];
    
    //現在の日付を取得
    now = [NSDate date];
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:now];
    
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [calendar components:flags fromDate:now];
    
    NSInteger orgYear = comps.year;
    NSInteger orgMonth = comps.month;
    NSInteger orgDay = comps.day;
    NSInteger orgDayOfWeek = comps.weekday;
    NSInteger max = range.length;
    
    //年月日を取得(NSIntegerをintへ変換)
    year = orgYear;
    month = orgMonth;
    day = orgDay;
    dayOfWeek = orgDayOfWeek;
    
    //月末日(NSIntegerをintへ変換)
    maxDay = max;
    
    //空の配列を作成する
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
        calendarBaseLabel.frame = CGRectMake(5 + 45 * (j % calendarTitle), 50, 40, 25);
        
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
        calendarBaseLabel.text = [array objectAtIndex:j];
        calendarBaseLabel.textAlignment = NSTextAlignmentCenter;
        calendarBaseLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:calendarBaseLabel];
    }
}

//現在カレンダーのセットアップ
-(void)setupCurrentCalendar
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
        int positionX = 5 + 45 * (i % 7);
        int positionY = 90 + 45 * (i / 7);
        int buttonSize = 40;
        
        //42個分のボタンを配置
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(positionX,positionY,buttonSize,buttonSize);
        
        if(i < dayOfWeek - 1){
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setEnabled:NO];
        }else if(i == dayOfWeek - 1 || i < dayOfWeek + maxDay - 1){
            
            NSString *tagNumberString = [NSString stringWithFormat:@"%d", tagNumber];
            [button setTitle:tagNumberString forState:UIControlStateNormal];
            button.tag = tagNumber;
            tagNumber++;
        }else if(i == dayOfWeek + maxDay - 1 || i < total){
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
        [button setBackgroundColor:calendarBackGroundColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [button.layer setCornerRadius:20.0];
        
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        [mArray addObject:button];
    }
}

//現在の年月に該当するデータを取得
- (void)setupCurrentCalendarData
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    [currentComps setYear:year];
    [currentComps setMonth:month];
    [currentComps setDay:1];
    NSDate *currentDate = [currentCalendar dateFromComponents:currentComps];
    
    [self recreateCalendarParameter:currentCalendar dateObject:currentDate];
}

//prevボタン押下に該当するデータを取得
- (void)setupPrevCalendarData
{
    if(month == 0){
        year = year - 1;
        month = 12;
    }else{
        month = month - 1;
    }
    
    NSCalendar *prevCalendar = [NSCalendar currentCalendar];
    NSDateComponents *prevComps = [[NSDateComponents alloc] init];
    [prevComps setYear:year];
    [prevComps setMonth:month];
    [prevComps setDay:1];
    NSDate *prevDate = [prevCalendar dateFromComponents:prevComps];
    
    [self recreateCalendarParameter:prevCalendar dateObject:prevDate];
}

//nextボタン押下に該当するデータを取得
- (void)setupNextCalendarData
{
    if(month == 12){
        year = year + 1;
        month = 1;
    }else{
        month = month + 1;
    }
    
    NSCalendar *nextCalendar = [NSCalendar currentCalendar];
    NSDateComponents *nextComps = [[NSDateComponents alloc] init];
    [nextComps setYear:year];
    [nextComps setMonth:month];
    [nextComps setDay:1];
    NSDate *nextDate = [nextCalendar dateFromComponents:nextComps];
    
    [self recreateCalendarParameter:nextCalendar dateObject:nextDate];
}

//カレンダーのパラメータを作成する関数
- (void)recreateCalendarParameter:(NSCalendar *)currentCalendar dateObject:(NSDate *)currentDate
{
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [currentCalendar components:flags fromDate:currentDate];
    
    NSRange currentRange = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    
    NSInteger currentYear = comps.year;
    NSInteger currentMonth = comps.month;
    NSInteger currentDay = comps.day;
    NSInteger currentDayOfWeek = comps.weekday;
    NSInteger currentMax = currentRange.length;
    
    //年月日を取得(NSIntegerをintへ変換)
    year = currentYear;
    month = currentMonth;
    day = currentDay;
    dayOfWeek = currentDayOfWeek;
    maxDay = currentMax;
}

- (IBAction)getNextMonthData:(id)sender
{
    //表示されているボタンオブジェクトを殺す
    for (int i=0; i<[mArray count]; i++) {
        [mArray[i] removeFromSuperview];
    }
    [mArray removeAllObjects];
    
    //カレンダーのセットアップ
    [self setupNextCalendarData];
    [self generateCalendar];
    [self setupCalendarTitleLabel];
}

- (IBAction)getPrevMonthData:(id)sender
{
    //表示されているボタンオブジェクトを殺す
    for (int i=0; i<[mArray count]; i++) {
        [mArray[i] removeFromSuperview];
    }
    [mArray removeAllObjects];
    
    //カレンダーのセットアップ
    [self setupPrevCalendarData];
    [self generateCalendar];
    [self setupCalendarTitleLabel];
}

//タイトルバーの設定
- (void)setupCalendarTitleLabel
{
    self.calendarBar.text = [NSString stringWithFormat:@"%d年%d月のカレンダー", year, month];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)buttonTapped:(UIButton*)button{
    NSLog(@"タグ：%d",button.tag);
}

@end
