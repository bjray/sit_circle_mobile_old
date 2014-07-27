//
//  SCAddressesViewController.m
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCAddressesViewController.h"
#import "SCContactTableViewCell.h"
#import "SCContactsHelper.h"
//#import "SCAppDelegate.h"
#import "SCSessionManager.h"
#import "SCUser.h"
#import "SCCircle.h"

#import "MBProgressHUD.h"
#import <TSMessages/TSMessage.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>



@interface SCAddressesViewController () <UISearchDisplayDelegate>
@property (nonatomic, retain) NSMutableArray *sitters;    //TODO: replace with userclass property
@property (nonatomic, retain) NSMutableArray *selectedContacts;

@end

@implementation SCAddressesViewController
{
    NSArray *_searchResults;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        //TODO: Replace with actual selected contacts...
        
    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedContacts = [NSMutableArray array];
    SCContactsHelper *contactsHelper = [SCContactsHelper sharedManager];
    [contactsHelper requestContacts];
    
    [[RACObserve([SCContactsHelper sharedManager], contacts)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newContacts) {
         NSLog(@"new contact list observed!");
         [self updateSelectedContacts:newContacts];
         [self.tableView reloadData];
     }];
}

- (void)updateSelectedContacts:(NSArray *)contacts {
    SCSessionManager *manager = [SCSessionManager sharedManager];
    
    for (SCContact *contact in contacts) {
        if ([manager.user.primaryCircle containsContact:contact]) {
            contact.isLocked = YES;
            [self.selectedContacts addObject:contact];
        }
    }
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
    NSInteger count = [[SCContactsHelper sharedManager].contacts count];
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        //TODO: Set up controller to support search...

        static NSString *CellIdentifier = @"SearchCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil)
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        cell.textLabel.text = [_searchResults objectAtIndex:indexPath.row];
        return cell;
    } else {
        // config cell....
        static NSString *CellIdentifier = @"contactCell";
        SCContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.contact = [[SCContactsHelper sharedManager].contacts objectAtIndex:indexPath.row];
        
        //TODO: Eventually add logic to checkmark cells that have already been added as sitters...
        if ([self.selectedContacts containsObject:[[SCContactsHelper sharedManager].contacts objectAtIndex:indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (aCell.accessoryType == UITableViewCellAccessoryNone) {
        aCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedContacts addObject:[[SCContactsHelper sharedManager].contacts objectAtIndex:indexPath.row]];
    } else {
        aCell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedContacts removeObject:[[SCContactsHelper sharedManager].contacts objectAtIndex:indexPath.row]];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Search
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    self.searchDisplayController.searchBar.showsCancelButton = YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    self.searchDisplayController.searchBar.showsCancelButton = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    _searchResults = [self filterContacts:searchString];
    return YES;
}

- (NSArray *)filterContacts:(NSString *)searchText {
    //TODO: determine what the predicate needs to be...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstName contains[c] %@", searchText];
    return [[SCContactsHelper sharedManager].contacts filteredArrayUsingPredicate:predicate];
}

#pragma mark - Picker DataSource Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

#pragma mark - Picker Delegate Methods

#pragma mark - User Actions

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Saving...";
    
    SCSessionManager *manager = [SCSessionManager sharedManager];
//    SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [manager.user.primaryCircle addContactsToSitterList:self.selectedContacts];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
