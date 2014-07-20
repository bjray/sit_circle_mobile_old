//
//  SCCircleViewController.m
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCCircleViewController.h"
#import "SCAppDelegate.h"
#import "SCUser.h"
#import "SCCircle.h"
#import "SCSitter.h"

@interface SCCircleViewController ()

@end

@implementation SCCircleViewController

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
    // Return the number of rows in the section.
    SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //TODO: Dont default to primary circle - user may select any circle...
    return [appDelegate.user.primaryCircle.sitters count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sitterCell" forIndexPath:indexPath];
    
    // Configure the cell...
    SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //TODO: Dont default to primary circle - user may select any circle...
    SCCircle *circle = appDelegate.user.primaryCircle;
    SCSitter *sitter = [circle.sitters objectAtIndex:indexPath.row];
    cell.textLabel.text = sitter.fullName;
    cell.detailTextLabel.text = sitter.primaryNumberValue;
    cell.imageView.image = sitter.image;
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
    if ([destination respondsToSelector:@selector(setSitter:)]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        SCCircle *circle = appDelegate.user.primaryCircle;
        SCSitter *aSitter = [circle.sitters objectAtIndex:indexPath.row];
        [destination setValue:aSitter forKeyPath:@"sitter"];
    } else {
        NSLog(@"didn't find selector!");
    }
}


@end
