//
//  SCCirclesViewController.m
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCCirclesViewController.h"
#import "SCSessionManager.h"
#import "SCCircleTableViewCell.h"
#import "SCCircle.h"
#import "MBProgressHUD.h"
#import <TSMessages/TSMessage.h>

@interface SCCirclesViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation SCCirclesViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        NSLog(@"Init method fired...");
        
    }
    
    
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.fetchedResultsController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    SCSessionManager *manager = [SCSessionManager sharedManager];
    [[manager fetchSittersByUser:manager.user] subscribeNext:^(id json) {
        NSLog(@"json received: %@", json);
        [hud hide:YES];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"error!");
        [self displayError:error optionalMsg:nil];
        [hud hide:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SCSessionManager *manager = [SCSessionManager sharedManager];
    return [manager.user.circles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CircleCell";
    SCCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SCCircle *circle = (SCCircle *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.circleNameLbl.text = circle.name;

    if (circle.sitters) {
        cell.circleCountLbl.text = [NSString stringWithFormat:@"%lu", (unsigned long)[circle.sitters count]];
    } else {
        cell.circleCountLbl.text = @"0";
    }

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = [segue destinationViewController];
    if ([destination respondsToSelector:@selector(setCircle:)]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        SCCircle *circle = (SCCircle *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        [destination setValue:circle forKey:@"circle"];

    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Helper methods...
- (void)displayError:(NSError *)error optionalMsg:(NSString *)optionalMsg{
    NSString *msg = [NSString stringWithFormat:@"%@ %@", [error localizedDescription], optionalMsg];
    
    [TSMessage showNotificationWithTitle:@"Error" subtitle:msg type:TSMessageNotificationTypeError];
}


#pragma mark - Result controller
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    SCSessionManager *manager = [SCSessionManager sharedManager];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"SCCircle"
                                   inManagedObjectContext:manager.user.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
                                        initWithKey:@"isPrimary"
                                        ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]
                                         initWithKey:@"name"
                                         ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor1, sortDescriptor2]];
    NSFetchedResultsController *fetchedResults;
    fetchedResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                         managedObjectContext:manager.user.managedObjectContext
                                                           sectionNameKeyPath:nil
                                                                    cacheName:nil];
    
    
    
    self.fetchedResultsController = fetchedResults;
    
	NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Core data error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}



@end
