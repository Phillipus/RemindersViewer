//
//  RemindersManager.h
//  RemindersViewer
//
//  Created by Phillipus on 29/09/2012.
//  Copyright (c) 2012 Dada Beatnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@protocol RemindersDelegate <NSObject>
- (void) remindersUpdated:(NSArray *)calendars;
@end

@interface RemindersManager : NSObject

+ (RemindersManager *)sharedInstance;
- (void)fetchReminders;
- (BOOL)deleteReminder:(EKReminder *)reminder;

@property (nonatomic, weak) id<RemindersDelegate> delegate;
@property (nonatomic, strong) NSArray *calendars;

@end

