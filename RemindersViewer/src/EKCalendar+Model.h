//
//  EKCalendar+Model.h
//  RemindersViewer
//
//  Created by Phillipus on 14/10/2012.
//  Copyright (c) 2012 Dada Beatnik. All rights reserved.
//

#import <EventKit/EventKit.h>

// Class Category to store all reminders for a EKCalendar after they have been fetched
@interface EKCalendar (Model)

@property (strong) NSMutableArray *reminders;

@end
