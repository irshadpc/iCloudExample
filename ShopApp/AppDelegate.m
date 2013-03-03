//
//  AppDelegate.m
//  ShopApp
//
//  Created by Anders Eriksen on 02/09/12.
//  Copyright (c) 2012 Anders Eriksen. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	[self saveContext];
}

#pragma mark - Core Data Callbacks

- (void)mergeChangesFrom_iCloud:(NSNotification *)notification
{
    NSManagedObjectContext* moc = [self managedObjectContext];
    [moc performBlock:^{
        [self mergeiCloudChanges:notification forContext:moc];
    }];
}

- (void)mergeiCloudChanges:(NSNotification*)note forContext:(NSManagedObjectContext*)moc
{
    [moc mergeChangesFromContextDidSaveNotification:note];
    //Refresh view with no fetch controller if any.
    //  You would use a custom notification for this.
}

- (BOOL)isIcloudEnabled
{
	NSURL *ubiq = [[NSFileManager defaultManager]
				   URLForUbiquityContainerIdentifier:nil];
	if (ubiq) {
		return YES;
	} else {
		return NO;
	}
}

#pragma mark - Core Data stack

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if ([self isIcloudEnabled]) {
		
		if (coordinator != nil) {
			// choose a concurrency type for the context
			NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
			[moc performBlockAndWait:^{
				// configure context properties
				[moc setPersistentStoreCoordinator: coordinator];
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:@selector(mergeChangesFrom_iCloud:)
															 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
														   object:coordinator];
			}];
			__managedObjectContext = moc;
		}
	}else {
		if (coordinator != nil) {
			__managedObjectContext = [[NSManagedObjectContext alloc] init];
			[__managedObjectContext setPersistentStoreCoordinator:coordinator];
		}
	}
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSPersistentStoreCoordinator* psc = __persistentStoreCoordinator;
    NSURL *storePathUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShopApp.sqlite"];
    
    // done asynchronously since it may take a while
    //to download preexisting iCloud content
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *storeUrl = storePathUrl;
        
        // building the path to store transaction logs
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *transactionLogsURL = [fileManager URLForUbiquityContainerIdentifier:nil];
		if (transactionLogsURL) {
			NSString* coreDataCloudContent = [[transactionLogsURL path]
											  stringByAppendingPathComponent:@"ShopApp_data"];
			transactionLogsURL = [NSURL fileURLWithPath:coreDataCloudContent];
			
			// Building the options array for the coordinator
			NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
									 @"dk.afogh.ShopApp", NSPersistentStoreUbiquitousContentNameKey,
									 transactionLogsURL, NSPersistentStoreUbiquitousContentURLKey,
									 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
									 nil];
			NSError *error = nil;
			
			[psc lock];
			
			if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
											 URL:storeUrl options:options
										   error:&error]) {
				DLog(@"Core data error %@, %@", error, [error userInfo]);
				abort();
			}
			
			[psc unlock];
			
			// post a notification to tell the main thread
			// to refresh the user interface
			dispatch_async(dispatch_get_main_queue(), ^{
				DLog(@"persistent store added correctly");
				[[NSNotificationCenter defaultCenter]
				 postNotificationName:@"dk.afogh.refetch"
				 object:self userInfo:nil];
			});
		} else {
			NSError *error = nil;
			if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
											 URL:storePathUrl options:nil
										   error:&error]) {
				DLog(@"Core data error %@, %@", error, [error userInfo]);
				abort();
			}
		}
    });
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
