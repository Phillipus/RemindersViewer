//
//  MainViewController.m
//  RemindersViewer
//
//  Created by Phillipus on 29/09/2012.
//  Copyright (c) 2012 Dada Beatnik. All rights reserved.
//

#import "MainViewController.h"
#import "InfoCell.h"
#import "EKCalendar+Model.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // This will take care of editing
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // Pull-down Refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshInvoked:forState:) forControlEvents:UIControlEventValueChanged];
    
    // Register to listen to Application becoming active
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [RemindersManager sharedInstance].delegate = self;
}

- (void)dealloc {
    [RemindersManager sharedInstance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Pull down refresh invoked
-(void) refreshInvoked:(id)sender forState:(UIControlState)state {
    [self refresh];
}

// Refresh button pressed
- (IBAction)refreshButtonPressed {
    [self refresh];
}

- (void)refresh {
    [[RemindersManager sharedInstance] fetchReminders];
}

// RemindersManager delegate method 
- (void)remindersUpdated:(NSArray *)calendars {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

//_______________________________________________________________________________________________________________
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[RemindersManager sharedInstance].calendars count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    EKCalendar *calendar = [[RemindersManager sharedInstance].calendars objectAtIndex:section];
    return calendar.title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    EKCalendar *calendar = [[RemindersManager sharedInstance].calendars objectAtIndex:section];
    return [calendar.reminders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];

    EKCalendar *calendar = [[RemindersManager sharedInstance].calendars objectAtIndex:indexPath.section];
    EKReminder *reminder = [[calendar reminders] objectAtIndex:indexPath.row];
    [cell updateCell:reminder];
    
    return cell;
};


//_______________________________________________________________________________________________________________
#pragma mark - Table Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        EKCalendar *calendar = [[RemindersManager sharedInstance].calendars objectAtIndex:indexPath.section];
        EKReminder *reminder = [[calendar reminders] objectAtIndex:indexPath.row];
        BOOL result = [[RemindersManager sharedInstance] deleteReminder:reminder];
        if(result) {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}


@end
