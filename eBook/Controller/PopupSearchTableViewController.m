//
//  PopupSearchTableViewController.m
//  eBook
//
//  Created by Sittikorn on 9/17/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "PopupSearchTableViewController.h"
#import "DetailBookViewController.h"

@interface PopupSearchTableViewController ()

@property (nonatomic,strong) NSArray *data;

@end

@implementation PopupSearchTableViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Result";
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}


#pragma mark - Managing the recents list


- (void)filterResultsUsingString:(NSString *)filterString {
    
    NSMutableArray *getData = [[NSMutableArray alloc]init];
    [getData removeAllObjects];
    
    for (NSArray* book in self.allBookbData)
    {
        NSRange nameRange = [[book valueForKey:@"bookname"] rangeOfString:filterString options:NSCaseInsensitiveSearch];
        if(nameRange.location != NSNotFound)
        {
            [getData addObject:book];
        }
    }
    
    self.data = getData;
    
    [self.tableView reloadData];
}


#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.data count];
}

// Display the strings in displayedRecentSearches.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [[self.data objectAtIndex:indexPath.row]valueForKey:@"bookname"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate recentSearchesController:self didSelectString:[[self.data objectAtIndex:indexPath.row]valueForKey:@"bookname"]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
