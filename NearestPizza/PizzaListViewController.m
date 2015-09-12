//
//  PizzaListViewController.m
//  NearestPizza
//
//  Created by Azat Almeev on 12.09.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

#import "PizzaListViewController.h"
#import "LoadMoreTableCell.h"
#import "Item+Ex.h"
#import "ItemViewCell.h"
#import "RestaurantViewController.h"
@import CoreLocation;

@interface PizzaListViewController () <CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (nonatomic, readonly) NSFetchedResultsController *fetchController;
@property (nonatomic) BOOL isLoading;
@end

@implementation PizzaListViewController
@synthesize isLoading = _isLoading;
@synthesize locationManager = _locationManager;
@synthesize fetchController = _fetchController;

- (BOOL)isLoading {
    return _isLoading && (self.fetchController.sections.count == 0 || [self.fetchController.sections[0] numberOfObjects] == 0);
}

- (void)setIsLoading:(BOOL)isLoading {
    if (_isLoading == isLoading)
        return;
    BOOL needRefresh = self.isLoading != isLoading;
    _isLoading = isLoading;
    if (needRefresh)
        [self.tableView reloadData];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 10;
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

- (NSFetchedResultsController *)fetchController {
    if (!_fetchController)
        _fetchController = [Item MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:self];
    return _fetchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locationManager startUpdatingLocation];
    [self.tableView registerNib:LoadMoreTableCell.nib forCellReuseIdentifier:LoadMoreTableCell.cellIdentifier];
    [self.tableView registerNib:ItemViewCell.nib forCellReuseIdentifier:ItemViewCell.cellIdentifier];
    [self loadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowItem"]) {
        RestaurantViewController *dvc = segue.destinationViewController;
        dvc.restaurant = sender;
    }
}

- (void)loadData {
    if (self.locationManager.location == nil || !CLLocationCoordinate2DIsValid(self.locationManager.location.coordinate))
        return;
    
    self.isLoading = YES;
    NSDictionary *params = @{ @"ll": [NSString stringWithFormat:@"%f,%f",
                                      self.locationManager.location.coordinate.latitude,
                                      self.locationManager.location.coordinate.longitude],
                              @"categoryId" : @"4bf58dd8d48988d1c4941735",
                              @"limit" : @5,
                              @"query" : @"pizza" };
    [self.netManager sendRequestWithPath:@"search" method:@"GET" parametrs:params completion:^(id JSONData, NSError *error) {
        self.isLoading = NO;
        if (error)
            [self showError:error.localizedDescription];
        else {
            NSNumber *code = [JSONData valueForKeyPath:@"meta.code"];
            if ([code isEqualToNumber:@200]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    [Item MR_truncateAllInContext:localContext];
                    for (id JSON in [JSONData valueForKeyPath:@"response.venues"]) {
                        Item *item = [Item MR_createEntityInContext:localContext];
                        [item fillDataFromJSON:JSON];
                    }
                } completion:^(BOOL contextDidSave, NSError *error) {
                    if (!error)
                        [NSNotificationCenter.defaultCenter postNotificationName:kItemsListDidChangeNotification object:nil];
                }];
            }
            else
                [self showError:@"Cannot load data"];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isLoading ? 1 : self.fetchController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isLoading)
        return 1;
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isLoading)
        return [tableView dequeueReusableCellWithIdentifier:LoadMoreTableCell.cellIdentifier];
    ItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ItemViewCell.cellIdentifier];
    cell.model = [self.fetchController objectAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isLoading)
        return;
    [self performSegueWithIdentifier:@"ShowItem" sender:[self.fetchController objectAtIndexPath:indexPath]];
}

#pragma mark - Fetch Controller Delegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    [self.tableView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    [self.tableView reloadData];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self loadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self showError:error.localizedDescription];
}

@end
