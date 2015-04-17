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
    NSMutableArray *mArray;
    
    //カレンダー表示用メンバ変数
    NSDate *currentDate;
    int year;
    int month;
    int maxDay;
    int dayOfWeek;
    
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
    currentDate = [NSDate date];
    
    //空の配列を作成する（カレンダーデータの格納用）
    mArray = [NSMutableArray new];
    
    //曜日ラベル初期定義
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSArray *monthName = df.shortWeekdaySymbols;
    
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
    int total = 42;
    
    //42個のボタンを配置する
    for(int i=0; i<total; i++) {
        bool flg = false;
        
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
            
        }else if(i < dayOfWeek + maxDay - 1){
            int tagNumber = i - dayOfWeek + 2;
            
            flg = [self holidayCalc:year tMonth:month tDay:tagNumber tIndex:i];
            
            //日付の入る部分はボタンのタグを設定する（日にち）
            NSString *tagNumberString = [NSString stringWithFormat:@"%d", tagNumber];
            [button setTitle:tagNumberString forState:UIControlStateNormal];
            button.tag = tagNumber;
            
        }else if(i < total){
            
            //日付の入らない部分はボタンを押せなくする
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setEnabled:NO];
            
        }
        
        //ボタンデザインと配色の決定
        if(i % 7 == 0 || flg){ // 日曜日と祝日は赤くする
            calendarBackGroundColor = [UIColor colorWithRed:0.831 green:0.349 blue:0.224 alpha:1.0];
        }else if(i % 7 == 6){ // 土曜日は青くする
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

//祝日を判定する
/* ----------- 祝日計算用の関数（はじめ） -----------*/
- (BOOL)holidayCalc:(int)tYear tMonth:(int)tMonth tDay:(int)tDay tIndex:(int)i{
    if ([self holiday:tYear tMonth:tMonth tDay:tDay tIndex:i]) {
        return YES;
    }
    // 国民の休日。翌日と前日が祝日の場合国民の休日とする
    if ([self holiday:tYear tMonth:tMonth tDay:tDay + 1 tIndex:i + 1] && [self holiday:tYear tMonth:tMonth tDay:tDay - 1 tIndex:i - 1]) {
        return 1;
    }
        
    // 振替休日を調べる。前日以前が祝日又は祝日が連続しているとき、そのいずれかが日曜日であった場合振替休日とする
    for (int j = 1; [self holiday:tYear tMonth:tMonth tDay:tDay - j tIndex:i - j]; j++) {
        if ((i - j) % 7 == 0) {
            return YES;
        }
    }
    return false;
}

- (BOOL)holiday:(int)tYear tMonth:(int)tMonth tDay:(int)tDay tIndex:(int)i {
    //春分・秋分の計算式
    int y2 = (tYear - 2000);
    int syunbun = (int)(20.69115 + 0.2421904 * y2 - (int)(y2/4 + y2/100 + y2/400));
    int syuubun = (int)(23.09000 + 0.2421904 * y2 - (int)(y2/4 + y2/100 + y2/400));
    bool holidayFlag = false;
    
    if ((tMonth == 1) && (tDay == 1)) {
        
        //元日（1月1日なら）
        holidayFlag = true;
    }
    else if ((tMonth == 1) && ( (i == 8 || i == 15) && (tDay >= 8 && tDay <= 14) ) && (i % 7 == 1)) {
        
        //成人の日（1月の第2月曜なら）
        holidayFlag = true;
    }
    else if ((tMonth == 2) && (tDay == 11)) {
        
        //建国記念の日（2月11日なら）
        holidayFlag = true;
    }
    else if ((tYear  > 1999) && (tMonth == 3) && (tDay == syunbun)) {
        
        //春分の日（計算式による）
        holidayFlag = true;
    }
    else if ((tMonth == 4) && (tDay == 29)) {
        
        //2006年みどりの日（4月29日なら）
        holidayFlag = true;
    }
    else if ((tMonth == 5) && (tDay == 3)) {
        
        // 憲法記念日（5月3日なら）
        holidayFlag = true;
    }
    else if ((tYear > 2006) && (tMonth == 5) && (tDay == 4)) {
        
        //2007年以降みどりの日（5月4日なら）
        holidayFlag = true;
    }
    else if ((tMonth == 5) && (tDay == 5)) {
        
        //こどもの日（5月5日なら）
        holidayFlag = true;
    }
    else if ((tMonth == 7) && ((i == 15 || i == 22) && (tDay >= 15 && tDay <= 21)) && (i % 7 == 1)) {
        
        //海の日（7月の第3月曜なら）
        holidayFlag = true;
    }
    else if ((tYear > 2015) && (tMonth == 8) && (tDay == 11)) {
        
        //2016年以降、山の日（8月11日）なら
        holidayFlag = true;
    }
    else if ((tMonth == 9) && ((i == 15 || i == 22) && (tDay >= 15 && tDay <= 21)) && (i % 7 == 1)) {
        
        //敬老の日（9月の第3月曜なら）
        holidayFlag = true;
    }
    else if ((tYear  > 1999 ) && (tMonth == 9) && (tDay == syuubun)) {
        
        //秋分の日（計算式による）
        holidayFlag = true;
    }
    else if ((tMonth == 10) && ((i == 8 || i == 15) && (tDay >= 8 && tDay <= 14)) && (i % 7 == 1)) {
        
        //体育の日（10月の第2月曜なら）
        holidayFlag = true;
    }
    else if ((tMonth == 11) && (tDay == 3)) {
        
        //文化の日（11月3日なら）
        holidayFlag = true;
    }
    else if ((tMonth == 11) && (tDay == 23)) {
        
        //勤労感謝の日（11月23日なら）
        holidayFlag = true;
    }
    else if ((tMonth == 12) && (tDay == 23)) {
        
        //天皇誕生日（12月23日なら）
        holidayFlag = true;
    }
    return holidayFlag;
}
/* ----------- 祝日計算用の関数（おわり） -----------*/

//現在の年月に該当するデータを取得
- (void)setupCurrentCalendarData
{
    //inUnitで指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *currentCalendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit flag = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *currentComps = [currentCalendar components:flag fromDate:currentDate];
    
    //該当月の1日の情報を取得する（※カレンダーが始まる場所を取得するため）
    [currentComps setDay:1];
    currentDate = [currentCalendar dateFromComponents:currentComps];
    
    //カレンダー情報を再作成する
    [self recreateCalendarParameter:currentCalendar dateObject:currentDate];
}

//prevボタン押下に該当するデータを取得
- (void)setupPrevCalendarData
{
    //一ヶ月前の日付を取得する
    NSCalendar *prevCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *prevComps = [[NSDateComponents alloc] init];
    [prevComps setMonth:-1];
    currentDate = [prevCalendar dateByAddingComponents:prevComps toDate:currentDate options:0];
    
    //カレンダー情報を再作成する
    [self recreateCalendarParameter:prevCalendar dateObject:currentDate];
}

//nextボタン押下に該当するデータを取得
- (void)setupNextCalendarData
{
    //一ヶ月先の日付を取得する
    NSCalendar *nextCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *nextComps = [[NSDateComponents alloc] init];
    [nextComps setMonth:1];
    currentDate = [nextCalendar dateByAddingComponents:nextComps toDate:currentDate options:0];
    
    //カレンダー情報を再作成する
    [self recreateCalendarParameter:nextCalendar dateObject:currentDate];
}

//カレンダーのパラメータを作成する関数
- (void)recreateCalendarParameter:(NSCalendar *)currentCalendar dateObject:(NSDate *)date
{
    NSUInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *comps = [currentCalendar components:flags fromDate:date];
    
    NSRange currentRange = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    //年月日と最後の日付を取得(NSIntegerをintへ変換)
    NSInteger currentYear      = comps.year;
    NSInteger currentMonth     = comps.month;
    NSInteger currentDayOfWeek = comps.weekday;
    NSInteger currentMax       = currentRange.length;
    
    year      = (int)currentYear;
    month     = (int)currentMonth;
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
