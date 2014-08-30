//
//  SCCircleViewController.m
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCCircleViewController.h"
#import "SCSessionManager.h"
#import "SCSitterTableViewCell.h"
#import "SCUser.h"
#import "SCCircle.h"
#import "SCSitter.h"
#import "SCPhoneNumber.h"
#import "SCEmailAddress.h"

@interface SCCircleViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation SCCircleViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        NSLog(@"Init method fired...");
        
    }
    
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.circle.sitters count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCSitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sitterCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    SCSitter *sitter = (SCSitter *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = sitter.fullName;
    cell.primaryPhoneLabel.text = sitter.primaryPhone.value;
    cell.sitterImageView.image = sitter.image;
//    cell.primaryPhoneLabel.text = sitter.primaryNumberValue;
//    cell.sitterImageView.image = sitter.image;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"contactsSegue"]) {
        NSLog(@"contacts");
        [destination setValue:self.circle forKey:@"circle"];
    } else if ([segue.identifier isEqualToString:@"SitterSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        SCSitter *aSitter = (SCSitter *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        [destination setValue:aSitter forKeyPath:@"sitter"];
    }
}

#pragma mark - Result controller
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"SCSitter"
                                   inManagedObjectContext:self.circle.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
                                         initWithKey:@"lastName"
                                         ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]
                                         initWithKey:@"firstName"
                                         ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor1, sortDescriptor2]];
    NSFetchedResultsController *fetchedResults;
    fetchedResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                         managedObjectContext:self.circle.managedObjectContext
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
