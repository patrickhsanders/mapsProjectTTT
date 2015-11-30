//
//  ViewController.m
//  MapApp
//
//  Created by Aditya Narayan on 11/16/15.
//  Copyright © 2015 turntotech.io. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentControl;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, strong) WebViewController *webView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableDictionary *URLDictionary;

@end

@implementation ViewController


//optional func searchBar(_ searchBar: UISearchBar,
//                        textDidChange searchText: String)

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

}



- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.URLDictionary = [[NSMutableDictionary alloc] init];
  [self.searchBar setImage:[UIImage imageNamed:@"skull.png"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
  
  self.mapView.delegate = self;
  CLLocationCoordinate2D locationOfTTT = CLLocationCoordinate2DMake(40.741448, -73.989969);
  MKCoordinateSpan mapSpan = MKCoordinateSpanMake(0.05, 0.05);
  MKCoordinateRegion region = MKCoordinateRegionMake(locationOfTTT,mapSpan);
  [self.mapView setRegion:region];

  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(locationOfTTT, 500, 500)];
  [_mapView setRegion:adjustedRegion animated:YES];
  //[self.mapView setRegion:region];

  MKPointAnnotation *turnToTech = [[MKPointAnnotation alloc] init];
  turnToTech.coordinate = locationOfTTT;
  turnToTech.title = @"TurnToTech";
  turnToTech.subtitle = @"IS AWESOME";
  [_mapView addAnnotation:turnToTech];
    
    
    

  
//  NSDictionary *restaurants = @{@"Indikich":@"25 W 23rd St, New York, NY 10010", @"Eataly" :@"200 5th Ave, New York, NY 10010", @"Sagaponack":@"4 W 22nd St, New York, NY 10010"};
//  for (NSString *key in restaurants){
//    NSLog(@"%@ - %@",key,[restaurants valueForKey:key]);
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    CLGeocodeCompletionHandler completionHandler = ^(NSArray *placemarks, NSError *error) {
//      NSLog(@"callback received");
//      if(error != nil){
//        NSLog(@"%@",error);
//      } else {
//        CLPlacemark *placemark = placemarks[0];
//        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//        annotation.coordinate = placemark.location.coordinate;
//        annotation.title = key;
//        [_mapView addAnnotation:annotation];
//      }
//    };
//    [geocoder geocodeAddressString:[restaurants valueForKey:key] completionHandler:completionHandler];
//  }
  
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  
  if ([annotation isKindOfClass:[MKUserLocation class]])
  {
    return nil;
  }
  
  static NSString *annotationIdentifier = @"StickerPin";
  
  MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];

  if (!annotationView) {
    annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    annotationView.canShowCallout = YES;
    UIImage* imgView = [UIImage imageNamed:@"skull.png"];
    annotationView.image = imgView;
    annotationView.canShowCallout = true;
  }
  return annotationView;
}

-(void)mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView*)view {
  UIImageView * leftCalloutView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 40, 40)];
  UIImage *logo = [UIImage imageNamed:@"skull2.gif"];
  leftCalloutView.image = logo;
  leftCalloutView.layer.masksToBounds = YES;
  leftCalloutView.layer.cornerRadius = 6;
  view.leftCalloutAccessoryView = leftCalloutView;
  view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

- (void)mapView:(MKMapView *)sender annotationView:(MKAnnotationView *)aView calloutAccessoryControlTapped:(UIControl *)control
{
  [sender deselectAnnotation:aView.annotation animated:YES];
  if([self.URLDictionary valueForKey:aView.annotation.title]){
    _webView = [[WebViewController alloc] initWithURL:[self.URLDictionary valueForKey:aView.annotation.title]];
  } else {
    NSString *string = [NSString stringWithFormat:@"https://www.google.com/#q=%@",[aView.annotation.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _webView = [[WebViewController alloc] initWithURL:[NSURL URLWithString:string]];
  }
  
  _webView.title = aView.annotation.title;
  [self.navigationController pushViewController:_webView animated:YES];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)setMapType:(id)sender {
  
  switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
    case 0:
      self.mapView.mapType = MKMapTypeStandard;
      break;
    case 1:
      self.mapView.mapType = MKMapTypeHybrid;
      break;
    case 2:
      self.mapView.mapType = MKMapTypeSatellite;
      break;
    default:
      break;
  }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  [searchBar resignFirstResponder];
  
  [self.mapView removeAnnotations:self.mapView.annotations];
  
  MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
  request.naturalLanguageQuery = searchBar.text;
  request.region = self.mapView.region;
  
  MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
  [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
    //NSLog(@"ITEM: %@",response.mapItems);
    
    for(MKMapItem *mapItem in response.mapItems){
      CLLocationCoordinate2D location = CLLocationCoordinate2DMake(mapItem.placemark.location.coordinate.latitude, mapItem.placemark.location.coordinate.longitude);
      MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
      annotation.coordinate = location;
      
      NSLog(@"%@",mapItem);
      annotation.title = mapItem.name;
      if(mapItem.url != nil){
        [self.URLDictionary setObject:mapItem.url forKey:mapItem.name];
      }
      
      [_mapView addAnnotation:annotation];
    }
  }];

}


@end
