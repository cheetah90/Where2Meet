//
//  SCLocationsViewController.h
//  Where2Meet
//
//  Created by Brandon Lehner on 3/13/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SCLocationsViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
