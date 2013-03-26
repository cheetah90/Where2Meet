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
#import "DCArrayMapping.h"
#import "Invitee.h"
#import "DCParserConfiguration.h"
#import "LocationDetails.h"

@implementation ServiceHub

static ServiceHub *serviceHub;

+ (ServiceHub *)current
{
    if (!serviceHub) serviceHub = [[ServiceHub alloc] init];
    return serviceHub;
}

// /facebookapi/register?user_id=my_user_Id&device_id=my_device_id
- (BOOL)registerUser:(NSString *)facebookUserId withDeviceId:(NSString *)deviceId
{
    NSString *registerUrl;
    if (deviceId)
    {
        registerUrl = [NSString stringWithFormat:@"http://wheretomeet.azurewebsites.net/facebookapi/register?user_id=%@&device_id=%@", facebookUserId, deviceId];
    }
    else
    {
        registerUrl = [NSString stringWithFormat:@"http://wheretomeet.azurewebsites.net/facebookapi/register?user_id=%@", facebookUserId];
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:registerUrl]];
    [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers error:&error];
    
    return error ? NO : YES;
}

//  /facebookapi/friends?user_ids=userId1,userId2,userId3
- (NSArray *)friendsWithApp:(NSArray *)friendsFacebookUserIds
{
    NSMutableString *ids = [[NSMutableString alloc] init];
    
    for (NSString *facebookUserId in friendsFacebookUserIds)
    {
        if (![ids isEqualToString:@""])
        {
            [ids appendString:@","];
        }
        
        [ids appendString:facebookUserId];
    }
    
    NSString* content = [@"user_ids=" stringByAppendingString:ids];
    NSURL* url = [NSURL URLWithString:@"http://wheretomeet.azurewebsites.net/facebookapi/friends"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSDictionary *jsonParsed = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers error:&error];
    
    return [jsonParsed objectForKey:@"users"];
}

- (NSMutableString *)buildInviteeUserIds:(NSArray *)friendFacebookUserIds
{
    NSMutableString *inviteeUserIds = [@"" mutableCopy];
    for (NSString *facebookId in friendFacebookUserIds)
    {
        if (![inviteeUserIds isEqualToString:@""])
        {
            [inviteeUserIds appendString:@","];
        }
        
        [inviteeUserIds appendString:facebookId];
    }
    return inviteeUserIds;
}

// /facebookapi/create_meeting?user_id=my_user_id&title=cool meeting&start_date_time=012-03-05T13:10:10.1234&end_date_time=012-03-05T14:10:10.1234&geocode=-23.124212,125.123241&invitee_user_ids=user_id1,user_id2
- (BOOL)createMeetingWithTitle:(NSString *)title
                 withStartDate:(NSDate *)startDateTime
                   withEndDate:(NSDate *)endDateTime
                   withFriends:(NSArray *)friendFacebookUserIds
                   withGeoCode:(NSString *)geoCode
{
    
    NSString* escapedTitle = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    double startTime = [startDateTime timeIntervalSince1970];
    double endTime = [endDateTime timeIntervalSince1970];
    NSMutableString *inviteeUserIds = [self buildInviteeUserIds:friendFacebookUserIds];
    
    NSString *registerUrl = [NSString stringWithFormat:@"http://wheretomeet.azurewebsites.net/facebookapi/create_meeting?user_id=%@&title=%@&start_date_time=%f&end_date_time=%f&geocode=%@&invitee_user_ids=%@", [self userId], escapedTitle, startTime, endTime, geoCode, inviteeUserIds];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:registerUrl]];
    [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers error:&error];
    
    return error ? NO : YES;
}

// /facebookapi/update_meeting?meeting_id=21342&user_id=my_user_id&title=cool meeting&start_date_time=012-03-05T13:10:10.1234&end_date_time=012-03-05T14:10:10.1234&invitee_user_ids=user_id1,user_id2
- (BOOL)updateMeetingWithMeetingId:(int)meetingId
                         withTitle:(NSString *)title
                     withStartDate:(NSDate *)startDateTime
                       withEndDate:(NSDate *)endDateTime
                       withFriends:(NSArray *)friendFacebookUserIds
{
    NSString* escapedTitle = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    double startTime = [startDateTime timeIntervalSince1970];
    double endTime = [endDateTime timeIntervalSince1970];
    NSMutableString *inviteeUserIds = [self buildInviteeUserIds:friendFacebookUserIds];
    
    NSString *registerUrl = [NSString stringWithFormat:@"http://wheretomeet.azurewebsites.net/facebookapi/update_meeting?meeting_id=%d&user_id=%@&title=%@&start_date_time=%f&end_date_time=%f&invitee_user_ids=%@", meetingId, [self userId], escapedTitle, startTime, endTime, inviteeUserIds];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:registerUrl]];
    [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers error:&error];
    
    return error ? NO : YES;
}

// /facebookapi/my_metings?user_id=myuserid
- (NSArray *)myMeetings
{
    NSString *url = [NSString stringWithFormat:@"http://wheretomeet.azurewebsites.net/facebookapi/my_meetings?user_id=%@", [self userId]];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *jsonParsed = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers error:&error];
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[Invitee class] forAttribute:@"inviteeDetails" onClass:[Meeting class]];
    
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Meeting class]
                                       andConfiguration:config];
    return [parser parseArray:[jsonParsed objectForKey:@"meetings"]];
}

- (BOOL)respondToMeetingInvite:(int)meetingId
                      accepted:(BOOL)accepted
                   withGeoCode:(NSString *)geoCode
{
    NSString *acceptedValue = accepted ? @"True" : @"False";
    
    NSString *url = [NSString stringWithFormat:@"http://wheretomeet.azurewebsites.net/facebookapi/respond_to_meeting_invite?user_id=%@&meeting_id=%d&geo_code=%@&accepted=%@", [self userId], meetingId, geoCode, acceptedValue];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers error:&error];
    
    return error ? NO : YES;
}

- (BOOL)voteOnLocation:(int)meetingId
     facebookLocationId:(NSString *)facebookLocationId
                   vote:(int)vote
{
    NSString* content = [NSString stringWithFormat:@"user_id=%@&facebook_location_id=%@&meeting_id=%d&vote=%d", self.userId, facebookLocationId, meetingId, vote];
    NSURL* url = [NSURL URLWithString:@"http://wheretomeet.azurewebsites.net/facebookapi/vote_on_location"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSError *error;
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    return error ? NO : YES;
}

- (BOOL)commentOnLocation:(int)meetingId
       facebookLocationId:(NSString *)facebookLocationId
                  comment:(NSString *)comment
{
    NSString* escapedComment = [comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* content = [NSString stringWithFormat:@"user_id=%@&facebook_location_id=%@&meeting_id=%d&comment=%@", self.userId, facebookLocationId, meetingId, escapedComment];
    NSURL* url = [NSURL URLWithString:@"http://wheretomeet.azurewebsites.net/facebookapi/comment_on_location"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSError *error;
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    return error ? NO : YES;
}

- (NSArray *)retrieveLocationDetails:(int)meetingId
             faceboolLocationId:(NSString *)facebookLocationId
{
    NSString* content = [NSString stringWithFormat:@"facebook_location_id=%@&meeting_id=%d",facebookLocationId, meetingId];
    NSURL* url = [NSURL URLWithString:@"http://wheretomeet.azurewebsites.net/facebookapi/retrieve_location_details"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSDictionary *jsonParsed = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers error:&error];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[LocationDetails class]];
    return [parser parseArray:[jsonParsed objectForKey:@"location_details"]];
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
