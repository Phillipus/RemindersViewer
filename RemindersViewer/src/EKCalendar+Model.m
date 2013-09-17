//
//  EKCalendar+Model.m
//  RemindersViewer
//
//  Created by Phillipus on 14/10/2012.
//  Copyright (c) 2012 Dada Beatnik. All rights reserved.
//

#import "EKCalendar+Model.h"
#import <objc/runtime.h>

// This is a good example of implementing a Class Category's property field using Associative References
// See http://oleb.net/blog/2011/05/faking-ivars-in-objc-categories-with-associative-references/

@implementation EKCalendar (Model)

static char remindersKey;

- (void)setReminders:(NSMutableArray *)reminders {
    objc_setAssociatedObject(self, &remindersKey, reminders, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)reminders {
    NSMutableArray *_reminders = objc_getAssociatedObject(self, &remindersKey);
    if(!_reminders) {
        _reminders = [[NSMutableArray alloc] init];
        self.reminders = _reminders;
    }
    return _reminders;
}

@end
