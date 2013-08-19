//
//  InfoCell.h
//  RemindersViewer
//
//  Created by Phillipus on 10/10/2012.
//  Copyright (c) 2012 Dada Beatnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindersManager.h"

@interface InfoCell : UITableViewCell

- (void) updateCell:(EKReminder *)reminder;

@end
