//
//  ListsViewController.m
//  ShopApp
//
//  Created by Anders Eriksen on 06/09/12.
//  Copyright (c) 2012 Anders Eriksen. All rights reserved.
//

#import "ListsViewController.h"
#import "List.h"
#import "AppDelegate.h"
#import "ListItemsViewController.h"

#define appDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface ListsViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) NSIndexPath *deleteSelectedRow;
@end

@implementation ListsViewController

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[List entityName]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:ListAttributes.dateUpdated ascending:YES]];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchedResultsController];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:@"dk.afogh.refetch"
                                               object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)reloadData
{
    DLog(@"refetching data");
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        DLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    } else {
        DLog(@"reload data - results are %i", self.fetchedResultsController.fetchedObjects.count);
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    List *list = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = list.name;
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		List *deleteList = [self.fetchedResultsController objectAtIndexPath:self.deleteSelectedRow];
		self.deleteSelectedRow = indexPath;
        if (deleteList.items.count > 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete list?" message:@"Deleting this list will delete all items it contains. Are you sure you want to delete?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete",nil];
			alertView.tag = 1;
			[alertView show];
        }else {
			[self deleteList];
		}
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}


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

//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

- (IBAction)addList:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New List" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
	alertView.tag = 0;
    [alertView textFieldAtIndex:0].placeholder = @"List name";
    [alertView show];
}

- (void)saveList:(NSString *)name
{
    List *newList = [List insertInManagedObjectContext:[appDelegate managedObjectContext]];
    newList.name = name;
	newList.dateUpdated = [NSDate date];
    [appDelegate saveContext];
}

- (void)deleteList
{
	List *deleteList = [self.fetchedResultsController objectAtIndexPath:self.deleteSelectedRow];
	[[appDelegate managedObjectContext] deleteObject:deleteList];
	[appDelegate saveContext];
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0 && buttonIndex == 1) {
        [self saveList:[alertView textFieldAtIndex:0].text];
    }else if (alertView.tag == 1 && buttonIndex == 1) {
		[self deleteList];
	}
}

#pragma mark storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowListItems"]) {
		ListItemsViewController *listItemsViewController = segue.destinationViewController;
		UITableViewCell *listCell = (UITableViewCell *)sender;
		NSIndexPath *indexPath = [self.tableView indexPathForCell:listCell];
		listItemsViewController.list = [self.fetchedResultsController objectAtIndexPath:indexPath];
	}
}
@end
