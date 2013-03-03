//
//  ListsViewController.h
//  ShopApp
//
//  Created by Anders Eriksen on 06/09/12.
//  Copyright (c) 2012 Anders Eriksen. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface ListsViewController : CoreDataTableViewController

- (IBAction)addList:(id)sender;
- (void)reloadData;
@end
