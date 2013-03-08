//
//  Meeting.h
//  KeyValueObjectMapping
//
//  Created by Brandon Lehner on 3/6/13.
//  Copyright (c) 2013 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject

@property (nonatomic) int meetingId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *Latitude;
@property (nonatomic, strong) NSNumber *Longitude;

@end
