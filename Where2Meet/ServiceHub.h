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

- (BOOL)registerUser:(NSString *)facebookUserId withDeviceId:(NSString *)deviceId;

- (NSArray *)friendsWithApp:(NSArray *)friendsFacebookUserIds;

- (int)createMeetingWithUserId:(NSString *)creatorFacebookUserId
                     withTitle:(NSString *)title
                        onDate:(NSDate *)dateTime
                   withFriends:(NSArray *)friendFacebookUserIds;

- (NSArray *)myMeetings:(NSString *)facebookUserId;

@end
