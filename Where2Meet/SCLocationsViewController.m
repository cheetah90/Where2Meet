//
//  SCLocationsViewController.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/13/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCLocationsViewController.h"
#import "LocationAnnotation.h"

@interface SCLocationsViewController ()

@end

@implementation SCLocationsViewController

#define METERS_PER_MILE 1609.344

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mapView.userTrackingMode = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showMapAtLocation:self.mapView.userLocation.coordinate];
}

// Moves the map to the given coordinates
- (void) showMapAtLocation:(CLLocationCoordinate2D)coordinates
{
    const float scale = 5.0;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, scale*METERS_PER_MILE, scale*METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void) showMarkerWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle AtLocation:(CLLocationCoordinate2D)coordinate
{
    LocationAnnotation *annotation = [[LocationAnnotation alloc] initWithTitle:title subtitle:subtitle coordinate:coordinate];
    
    [self.mapView addAnnotation:annotation];
}

@end
