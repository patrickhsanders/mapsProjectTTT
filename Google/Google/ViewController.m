//
//  ViewController.m
//  Google
//
//  Created by Patrick Sanders on 23.11.15.
//  Copyright © 2015 turntotech. All rights reserved.
//

#import "ViewController.h"
#import "CustomMarker.h"
#import "WebSiteViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) NSMutableDictionary *annotations;
@property (strong, nonatomic) NSMutableArray *googleMapMarkers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.annotations = [[NSMutableDictionary alloc] init];
    self.googleMapMarkers = [[NSMutableArray alloc] init];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.741448 longitude:-73.989969 zoom:17 bearing:0 viewingAngle:20];
    [_mapView setCamera:camera];
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(40.741448, -73.989969);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.icon = [UIImage imageNamed:@"pirate"];
    marker.title = @"Turn To Tech";
    marker.snippet = @"is awesome";
    marker.map = _mapView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changedMapType:(UISegmentedControl *)sender {
    
    switch(sender.selectedSegmentIndex){
        case 0:
            _mapView.mapType = kGMSTypeNormal;
            break;
        case 1:
            self.mapView.mapType = kGMSTypeHybrid;
            break;
        case 2:
            _mapView.mapType = kGMSTypeSatellite;
            break;
        case 3:
            _mapView.mapType = kGMSTypeTerrain;
            break;
        case 4:
            _mapView.mapType = kGMSTypeNone;
            break;
        default:
            _mapView.mapType = kGMSTypeNormal;
            break;
    }
}
- (IBAction)changedMapZoom:(UISegmentedControl *)sender {
    GMSCameraPosition *camera;
    switch(((UISegmentedControl *)sender).selectedSegmentIndex){
        case 0:
            camera = [GMSCameraPosition cameraWithLatitude:_mapView.camera.target.latitude longitude:_mapView.camera.target.longitude zoom:_mapView.camera.zoom - 1];
            break;
        case 1:
            camera = [GMSCameraPosition cameraWithLatitude:_mapView.camera.target.latitude longitude:_mapView.camera.target.longitude zoom:_mapView.camera.zoom + 1];
            break;
        default:
            camera = [GMSCameraPosition cameraWithLatitude:_mapView.camera.target.latitude longitude:_mapView.camera.target.longitude zoom:_mapView.camera.zoom];
            break;
    }
    [_mapView setCamera:camera];
}

- (UIView*)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    
    CustomMarker *view = [[[NSBundle mainBundle] loadNibNamed:@"LocationMarker" owner:self options:nil] objectAtIndex:0];
    MapAnnotation *an = [self.annotations valueForKey:marker.title];
    
    view.locationName.text = an.locationName;
    view.locationAddress.text = an.locationAddress;
    view.locationImage.image = an.locationImage;
    
    return view;
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search invoked");
    
    CLLocation *center = [[CLLocation alloc] initWithLatitude:self.mapView.camera.target.latitude longitude:self.mapView.camera.target.longitude];
    CLLocation *farLeft = [[CLLocation alloc] initWithLatitude:self.mapView.projection.visibleRegion.farLeft.latitude longitude:self.mapView.projection.visibleRegion.farLeft.longitude];
    double radius = [center distanceFromLocation:farLeft];
    
    NSString *searchQuery = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *formatedURLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=%@&location=%f,%f&radius=%f&key=%@",searchQuery,self.mapView.camera.target.latitude,self.mapView.camera.target.longitude,radius,@"AIzaSyCjK7YxdQ5zMOAfTmPU7g_XfVij1xgQe0w"];
    NSURL *serverRequest = [NSURL URLWithString:formatedURLString];
    NSURLSession *s2 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [[s2 dataTaskWithURL:serverRequest
       completionHandler:^(NSData *data,
                           NSURLResponse *response,
                           NSError *error) {
           NSLog(@"Response received");
           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
           NSDictionary *dict2 = [dict valueForKey:@"results"];
           if(dict2.count > 0){
               //         [_mapView clear];
               for(GMSMarker *marker in self.googleMapMarkers){
                   marker.map = nil;
               }
               [self.annotations removeAllObjects];
               [self.googleMapMarkers removeAllObjects];
           }
           NSLog(@"%@",dict2);
           for (id item in dict2 ){
               double latitude = [[[[item valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] doubleValue];
               double longitude = [[[[item valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] doubleValue];
               CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
               
               NSString *requestImageString;
               if([item valueForKey:@"photos"]){
                   requestImageString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?key=%@&photoreference=%@&maxwidth=50",@"AIzaSyCjK7YxdQ5zMOAfTmPU7g_XfVij1xgQe0w",[[[item valueForKey:@"photos"] valueForKey:@"photo_reference"] objectAtIndex:0 ]];
                   NSLog(@"Photo reference string \"%@\"",[[[item valueForKey:@"photos"] valueForKey:@"photo_reference"] objectAtIndex:0]);
               } else {
                   requestImageString = [item valueForKey:@"icon"];
               }
               NSLog(@"%@",requestImageString);
               MapAnnotation *annotation = [[MapAnnotation alloc] init:[item valueForKey:@"name"] withAddress:[item valueForKey:@"vicinity"]];
               
               GMSMarker *marker = [GMSMarker markerWithPosition:coord];
               marker.icon = [UIImage imageNamed:@"skull2"];
               //marker.icon = [UIImage imageNamed:@"heat"];
               marker.title = [item valueForKey:@"place_id"];
               marker.snippet = [item valueForKey:@"vicinity"];
               marker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
               marker.appearAnimation = YES;
               marker.map = _mapView;
               
               
               [[s2 dataTaskWithURL:[NSURL URLWithString:requestImageString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   NSLog(@"image request received");
                   annotation.locationImage = [UIImage imageWithData:data];
               }] resume];
               
               NSString *requestURLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?key=%@&placeid=%@",@"AIzaSyCjK7YxdQ5zMOAfTmPU7g_XfVij1xgQe0w",[item valueForKey:@"place_id"]];
               NSLog(@"%@",requestURLString);
               [[s2 dataTaskWithURL:[NSURL URLWithString:requestURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   NSDictionary *details = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                   NSDictionary *details2 = [details valueForKey:@"result"];
                   if([details2 valueForKey:@"website"]){
                       annotation.locationURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [details2 valueForKey:@"website"]]];
                   } else {
                       annotation.locationURL = [NSURL URLWithString:@"https://www.google.com"];
                   }
                   

               }] resume];
               
               [self.googleMapMarkers addObject:marker];
               [self.annotations setValue:annotation forKey:marker.title];
           }
       }] resume];
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    MapAnnotation *mapAnnotation = [self.annotations valueForKey:marker.title];
    WebSiteViewController *websiteView = [[WebSiteViewController alloc] init];
    websiteView.url = mapAnnotation.locationURL;
    [self.navigationController pushViewController:websiteView animated:YES];
    
    
    
    //[[UIApplication sharedApplication] openURL:mapAnnotation.locationURL];
    
    
}

@end
