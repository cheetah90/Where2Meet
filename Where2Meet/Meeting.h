//
//  Meeting.h
//  KeyValueObjectMapping
//
//  Created by Brandon Lehner on 3/6/13.
//  Copyright (c) 2013 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject

@property (nonatomic) BOOL isCreator;
@property (nonatomic) NSNumber *isAttending;
@property (nonatomic) int meetingId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) int startDate;
@property (nonatomic) int endDate;

@property (nonatomic, strong) NSDate *startDateTime;
@property (nonatomic, strong) NSDate *endDateTime;


// TODO: Add timezone
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSMutableArray *invitees;

@end
