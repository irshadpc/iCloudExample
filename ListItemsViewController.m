//
//  ListItemsViewController.m
//  ShopApp
//
//  Created by Anders Eriksen on 06/09/12.
//  Copyright (c) 2012 Anders Eriksen. All rights reserved.
//

#import "ListItemsViewController.h"
#import "Item.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

#define appDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface ListItemsViewController () <UIAlertViewDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UIBarButtonItem *actionButton;
@end

@implementation ListItemsViewController

- (void)setUpFetchedResultsController
{
	self.fetchedResultsController = [self.list newItemsFetchedResultsControllerWithSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:ListAttributes.dateUpdated ascending:YES]]];
}

- (void)loadButtons
{
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
	self.addButton.style = UIBarButtonItemStyleBordered;
	self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions)];
	self.actionButton.style = UIBarButtonItemStyleBordered;
	UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		toolbar.barStyle = UIBarStyleBlack;
		toolbar.translucent = YES;
		[toolbar setBackgroundImage:[UIImage alloc] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
	}
	
	NSArray* buttons = [NSArray arrayWithObjects:self.addButton, self.actionButton, nil];
	[toolbar setItems:buttons animated:NO];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setUpFetchedResultsController];
	if (self.list) {
		self.title = self.list.name;
	}
	[self loadButtons];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showActions
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sent as SMS", @"Sent as Email", nil];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)addItem
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Item" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
	alertView.tag = 0;
    [alertView textFieldAtIndex:0].placeholder = @"Item name";
    [alertView show];
}

- (void)saveItem:(NSString *)name
{
	Item *newItem = [Item insertInManagedObjectContext:[appDelegate managedObjectContext]];
	newItem.name = name;
	newItem.dateUpdated = [NSDate date];
	[self.list addItemsObject:newItem];
	[appDelegate saveContext];
}

- (void)deleteItem:(Item *)item
{
	[[appDelegate managedObjectContext] deleteObject:item];
	[appDelegate saveContext];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Item *item = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		Item *deleteItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[self deleteItem:deleteItem];
    }
	//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
	//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	//    }
}

#pragma mark - Alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 0 && buttonIndex == 1) {
		[self saveItem:[alertView textFieldAtIndex:0].text];
	}
}

#pragma mark - Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	if (buttonIndex == 0) {
		//SMS
		if ([MFMessageComposeViewController canSendText]) {
			MFMessageComposeViewController *messageView = [[MFMessageComposeViewController alloc] init];
			messageView.messageComposeDelegate = self;
			if (messageView)[self presentViewController:messageView animated:YES completion:nil];
		}
	}else if (buttonIndex == 1){
		//Email
		if ([MFMailComposeViewController canSendMail]) {
			NSMutableString *messageString = [NSMutableString stringWithFormat:@"<h2>%@</h2><ul>", self.list.name];
			
			for (Item *item in self.list.items) {
				[messageString appendString:[NSString stringWithFormat:@"<li>%@</li>", item.name]];
			}
			[messageString appendString:@"</ul>"];
			
			MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
			mailView.mailComposeDelegate = self;
			[mailView setMessageBody:messageString isHTML:YES];
			if (mailView)[self presentViewController:mailView animated:YES completion:nil];
		}
	}
}

#pragma mark - MFMailCompose view controller delegate 

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"There was a problem sending the email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMessageCompose view controller delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iMessage" message:NSLocalizedString(@"SendMailFailed", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
