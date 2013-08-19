//
//  RemindersManager.m
//  RemindersViewer
//
//  Created by Phillipus on 29/09/2012.
//  Copyright (c) 2012 Dada Beatnik. All rights reserved.
//

#import "RemindersManager.h"
#import "EKCalendar+Model.h"

@interface RemindersManager()
@property (nonatomic, strong) EKEventStore *store;
@end

@implementation RemindersManager

+ (RemindersManager *)sharedInstance {
    static RemindersManager *instance = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        instance = [[RemindersManager alloc] init];
    });
    return instance;
}

- (EKEventStore *)store {
    if(!_store) {
        self.store = [[EKEventStore alloc] init];
    }
    return _store;
}

- (void)fetchReminders {
    [self.store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
            [self showAlertWithTitle:@"Error" message:@"There was an error accessing reminders."];
            return;
        }
        
        if(!granted) {
            [self showAlertWithTitle:@"Cannot access reminders"
                             message:@"Access to reminders is not allowed for this application. You can enable access in Settings, in the Privacy section."];
            return;
        }
        
        self.calendars = [self.store calendarsForEntityType:EKEntityTypeReminder];
        
        // Clear reminders in the calendars
        for(EKCalendar *calendar in self.calendars) {
            calendar.reminders = nil;
        }
        
        // Fetch all reminders in one go so we can notify the delegate once we know the query is done
        NSPredicate *predicate = [self.store predicateForRemindersInCalendars:self.calendars];
        
        [self.store fetchRemindersMatchingPredicate:predicate completion:^(NSArray *items) {
            for(EKReminder *reminder in items) {
                [reminder.calendar.reminders addObject:reminder];
            }
            
            // Notify the delegate of the completed operation
            // We will dispatch it on the main queue because the UI will access it
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate remindersUpdated:self.calendars];
            });
        }];
        
    }]; // requestAccessToEntityType
}

- (BOOL)deleteReminder:(EKReminder *)reminder {
    NSError *error;
    
    BOOL result = [self.store removeReminder:reminder commit:YES error:&error];
    
    if(error) {
        NSLog(@"%@", error);
    }
    
    if(result) {
        [reminder.calendar.reminders removeObject:reminder];
    }
    else {
        [self showAlertWithTitle:@"Reminders" message:@"Could not remove reminder"];
    }
    
    return result;
}

- (void) showAlertWithTitle:(NSString*)title message:(NSString *)message {
    // As the caller is on a thread, we need to do UI stuff on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        
        [alert show];
    });
}


@end
