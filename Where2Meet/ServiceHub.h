//
//  ServiceHub.h
//  KeyValueObjectMapping
//
//  Created by Brandon Lehner on 3/6/13.
//  Copyright (c) 2013 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meeting.h"

@interface ServiceHub : NSObject

// Singleton pattern, retrieves an active and valid ServiceHub instance.
+ (ServiceHub *)current;

- (NSString *)deviceId;
- (NSString *)userId;
- (void)setDeviceId:(NSString *)deviceId;
- (void)setUserId:(NSString *)userId;

- (BOOL)registerUser:(NSString *)facebookUserId withDeviceId:(NSString *)deviceId;

- (NSArray *)friendsWithApp:(NSArray *)friendsFacebookUserIds;

- (BOOL)createMeetingWithTitle:(NSString *)title
                 withStartDate:(NSDate *)startDateTime
                   withEndDate:(NSDate *)endDateTime
                   withFriends:(NSArray *)friendFacebookUserIds
                   withGeoCode:(NSString *)geoCode;

- (BOOL)updateMeetingWithMeetingId:(int)meetingId
                         withTitle:(NSString *)title
                     withStartDate:(NSDate *)startDateTime
                       withEndDate:(NSDate *)endDateTime
                       withFriends:(NSArray *)friendFacebookUserIds;

- (NSArray *)myMeetings;

- (BOOL)respondToMeetingInvite:(int)meetingId
                      accepted:(BOOL)accepted
                   withGeoCode:(NSString *)geoCode;

@end
