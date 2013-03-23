//
//  Invitee.h
//  Where2Meet
//
//  Created by Brandon Lehner on 3/23/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Invitee : NSObject

@property (strong, nonatomic) NSString *facebookUserId;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *willAttend;

@end
