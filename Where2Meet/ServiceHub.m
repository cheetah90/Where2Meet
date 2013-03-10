//
//  ServiceHub.m
//  KeyValueObjectMapping
//
//  Created by Brandon Lehner on 3/6/13.
//  Copyright (c) 2013 dchohfi. All rights reserved.
//

#import "ServiceHub.h"
#import "DCKeyValueObjectMapping.h"
#import "Meeting.h"

@implementation ServiceHub

// /facebookapi/register?user_id=my_user_Id&device_id=my_device_id
- (BOOL)registerUser:(NSString *)facebookUserId withDeviceId:(NSString *)deviceId
{
    NSString *registerUrl = [NSString stringWithFormat:@"http://wheretomeet.azurewebsites.net/facebookapi/register?user_id=%@&device_id=%@", facebookUserId, deviceId];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:registerUrl]];
    [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers error:&error];
    
    return error ? NO : YES;
}

// /facebookapi/register?user_id=my_user_Id&device_id=my_device_id
- (NSArray *)friendsWithApp:(NSArray *)friendsFacebookUserIds
{
    NSMutableString *ids = [[NSMutableString alloc] init];
    
    for (NSString *facebookUserId in friendsFacebookUserIds)
    {
        if (![facebookUserId isEqualToString:@""])
        {
            [ids appendString:@","];
        }
        
        [ids appendString:facebookUserId];
    }
    
    NSString *url = [NSString stringWithFormat:@"http://wheretomeet.azurewebsites.net/facebookapi/friends?user_ids=%@", ids];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *jsonParsed = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers error:&error];
    
    return [jsonParsed objectForKey:@"users"];
}

// /facebookapi/create_meeting?user_id=my_user_id&title=cool meeting&date_time=012-03-05T13:10:10.1234&geocode=-23.124212,125.123241&invitee_user_ids=user_id1,user_id2
- (int)createMeetingWithUserId:(NSString *)creatorFacebookUserId
                     withTitle:(NSString *)title
                        onDate:(NSDate *)dateTime
                   withFriends:(NSArray *)friendFacebookUserIds
{
    // TODO: Impliment this.
    return nil;
}

// /facebookapi/my_metings?user_id=myuserid
- (NSArray *)myMeetings
{
    NSString *url = [NSString stringWithFormat:@"http://wheretomeet.azurewebsites.net/facebookapi/my_meetings?user_id=%@", [self userId]];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *jsonParsed = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers error:&error];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Meeting class]];
    return [parser parseArray:[jsonParsed objectForKey:@"meetings"]];
}

- (void)setUserId:(NSString *)userId
{
    NSUserDefaults *localStore = [NSUserDefaults standardUserDefaults];
    [localStore setObject:userId forKey:@"user_id"];
    [localStore synchronize];
}

- (NSString *)userId
{
    NSUserDefaults *localStore = [NSUserDefaults standardUserDefaults];
    return [localStore objectForKey:@"user_id"];
}

- (void)setDeviceId:(NSString *)deviceId
{
    NSUserDefaults *localStore = [NSUserDefaults standardUserDefaults];
    [localStore setObject:deviceId forKey:@"pushNotificationId"];
    [localStore synchronize];
}

- (NSString *)deviceId
{
    NSUserDefaults *localStore = [NSUserDefaults standardUserDefaults];
    return [localStore objectForKey:@"pushNotificationId"];
}

@end
