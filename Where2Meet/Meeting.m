//
//  Meeting.m
//  KeyValueObjectMapping
//
//  Created by Brandon Lehner on 3/6/13.
//  Copyright (c) 2013 dchohfi. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

- (NSMutableArray *)invitees
{
    if (!_invitees) _invitees = [[NSMutableArray alloc] init];
    return _invitees;
}

- (NSDate *)startDateTime
{
    if (!_startDateTime)
    {
        if (self.startDate)
        {
            _startDateTime = [NSDate dateWithTimeIntervalSince1970:self.startDate];
        }
        else
        {
            _startDateTime = [NSDate date];
        }
    }
    return _startDateTime;
}

- (NSDate *)endDateTime
{
    if (!_endDateTime)
    {
        if (self.endDate)
        {
            _endDateTime = [NSDate dateWithTimeIntervalSince1970:self.endDate];
        }
        else
        {
            _endDateTime = [self.startDateTime dateByAddingTimeInterval:3600];
        }
    }
    return _endDateTime;
}

@end
