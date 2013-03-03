//
//  ListItemsViewController.h
//  ShopApp
//
//  Created by Anders Eriksen on 06/09/12.
//  Copyright (c) 2012 Anders Eriksen. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "List.h"

@interface ListItemsViewController : CoreDataTableViewController
@property (nonatomic, strong) List *list;
@end
