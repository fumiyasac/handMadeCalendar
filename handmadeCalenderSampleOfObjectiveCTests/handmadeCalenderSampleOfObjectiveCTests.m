//
//  handmadeCalenderSampleOfObjectiveCTests.m
//  handmadeCalenderSampleOfObjectiveCTests
//
//  Created by 酒井文也 on 2014/11/04.
//  Copyright (c) 2014年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "NSDate+AZDateBuilder.h"

@interface ViewController ()
- (BOOL)holidayCalc:(int)tYear tMonth:(int)tMonth tDay:(int)tDay tIndex:(int)i;
@end


@interface handmadeCalenderSampleOfObjectiveCTests : XCTestCase
@property(strong, nonatomic) ViewController *viewController;
@property(strong, nonatomic) NSArray *holydays;
@end

@implementation handmadeCalenderSampleOfObjectiveCTests

- (void)setUp {
    [super setUp];
    self.viewController = [[ViewController alloc] init];
    self.holydays = @[
            [NSDate AZ_dateByUnit:@{ // 元日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @1,
                    AZ_DateUnit.day : @1,
            }],
            [NSDate AZ_dateByUnit:@{ // 成人の日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @1,
                    AZ_DateUnit.day : @12,
            }],
            [NSDate AZ_dateByUnit:@{ // 建国記念の日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @2,
                    AZ_DateUnit.day : @11,
            }],
            [NSDate AZ_dateByUnit:@{ // 春分の日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @3,
                    AZ_DateUnit.day : @21,
            }],
            [NSDate AZ_dateByUnit:@{ // 昭和の日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @4,
                    AZ_DateUnit.day : @29,
            }],
            [NSDate AZ_dateByUnit:@{ // 憲法記念日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @5,
                    AZ_DateUnit.day : @3,
            }],
            [NSDate AZ_dateByUnit:@{ // みどりの日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @5,
                    AZ_DateUnit.day : @4,
            }],
            [NSDate AZ_dateByUnit:@{ // こどもの日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @5,
                    AZ_DateUnit.day : @5,
            }],
            [NSDate AZ_dateByUnit:@{ // 振替休日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @5,
                    AZ_DateUnit.day : @6,
            }],
            [NSDate AZ_dateByUnit:@{ // 海の日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @7,
                    AZ_DateUnit.day : @20,
            }],
            [NSDate AZ_dateByUnit:@{ // 敬老の日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @9,
                    AZ_DateUnit.day : @21,
            }],
            [NSDate AZ_dateByUnit:@{ // 国民の祝日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @9,
                    AZ_DateUnit.day : @22,
            }],
            [NSDate AZ_dateByUnit:@{ // 秋分の日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @9,
                    AZ_DateUnit.day : @23,
            }],
            [NSDate AZ_dateByUnit:@{ // 体育の日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @10,
                    AZ_DateUnit.day : @12,
            }],
            [NSDate AZ_dateByUnit:@{ // 文化の日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @11,
                    AZ_DateUnit.day : @3,
            }],
            [NSDate AZ_dateByUnit:@{ // 勤労感謝の日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @11,
                    AZ_DateUnit.day : @23,
            }],
            [NSDate AZ_dateByUnit:@{ // 天皇誕生日
                    AZ_DateUnit.year : @2015,
                    AZ_DateUnit.month : @12,
                    AZ_DateUnit.day : @23,
            }],
    ];
}

- (void)tearDown {
    [super tearDown];
}


- (void)testHolyday {
    for (NSDate *date in self.holydays) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];

        int i = (int) ((components.weekday - components.day + 35) % 7 + components.day - 1);
        BOOL isHolyday = [self.viewController holidayCalc:(int) components.year tMonth:(int) components.month tDay:(int) components.day tIndex:i];
        XCTAssertEqual(isHolyday, YES, @"date: %@", date);
    }
}

- (void)testRandomDate {
    NSTimeInterval currentYear = [[NSDate AZ_dateByUnit:@{
            AZ_DateUnit.year : @2015,
            AZ_DateUnit.month : @1,
            AZ_DateUnit.day : @1,
    }] timeIntervalSinceReferenceDate];
    NSTimeInterval nextYear = [[NSDate AZ_dateByUnit:@{
            AZ_DateUnit.year : @2016,
            AZ_DateUnit.month : @1,
            AZ_DateUnit.day : @1,
    }] timeIntervalSinceReferenceDate];

    for (NSInteger i = 0; i < 100; i++) {
        // 2015年の日付をランダムに取ってくる
        NSDate *date = [[NSDate dateWithTimeIntervalSinceReferenceDate:arc4random_uniform(nextYear - currentYear) + currentYear] AZ_dateByUnit:@{
                AZ_DateUnit.hour : @0,
                AZ_DateUnit.minute : @0,
                AZ_DateUnit.second : @0,
        }];

        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];

        int i = (int) ((components.weekday - components.day + 35) % 7 + components.day - 1);
        BOOL isHolyday = [self.viewController holidayCalc:(int) components.year tMonth:(int) components.month tDay:(int) components.day tIndex:i];

        // 休日一覧にある場合は、休日と判定する
        BOOL expect = [self.holydays containsObject:date];
        XCTAssertEqual(isHolyday, expect, @"date: %@, i: %d", date, i);
    }
}

- (void)test2015_5_6 {
    BOOL isHolyday = [self.viewController holidayCalc:2015 tMonth:5 tDay:6 tIndex:10];
    XCTAssertEqual(isHolyday, YES);
}

- (void)test2015_9_22 {
    BOOL isHolyday = [self.viewController holidayCalc:2015 tMonth:9 tDay:22 tIndex:23];
    XCTAssertEqual(isHolyday, YES);
}
@end
