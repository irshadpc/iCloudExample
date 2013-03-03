//
//  AppDelegate.h
//  ShopApp
//
//  Created by Anders Eriksen on 02/09/12.
//  Copyright (c) 2012 Anders Eriksen. All rights reserved.
//

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)mergeChangesFrom_iCloud:(NSNotification *)notification;
- (void)mergeiCloudChanges:(NSNotification*)note forContext:(NSManagedObjectContext*)moc;
- (NSURL *)applicationDocumentsDirectory;
@end
