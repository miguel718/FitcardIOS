//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "MenuViewController.h"
#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "MenuCell.h"
#import "HomeViewController.h"
#import "SubMenuCell.h"
#import "Globals.h"

@implementation SWUITableViewCell
@end

@implementation MenuViewController
@synthesize tblMenu;
NSArray *menuItemsLogin;
NSArray *menuItemsLogout;


- (void)viewDidLoad
{
    [super viewDidLoad];
    menuItemsLogin = @[@"home",@"findgym",@"findclass",@"account",@"profile",@"pricing",@"mybooks",@"contactus",@"home"];
    
    menuItemsLogout = @[@"home",@"findgym",@"findclass",@"account",@"login",@"register",@"contactus"];

    tblMenu.delegate = self;
    tblMenu.dataSource = self;
    [tblMenu reloadData];

    
    
    
    
}
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    if ( [sender isKindOfClass:[MenuCell class]] )
    {
        UILabel *c = [(MenuCell*) sender lblMenuTitle];
        if ([c.text isEqualToString:NSLocalizedString(@"logout", @"")])
        {
            isLogin = 0;
            mAccount.mId = @"";
            mAccount.mName = @"";
            mAccount.mInvoiceStart = @"";
            mAccount.mInvoiceEnd = @"";
            mAccount.mEmail = @"";
            mAccount.mPlan = @"";
            mAccount.mCredit = @"";
            mAccount.mCity = @"";
            [Globals saveUserInfo];
            [tblMenu reloadData];
        }
    }
    else if ([sender isKindOfClass:[SubMenuCell class]])
    {
        
    }
        
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLogin == 1)
        return menuItemsLogin.count;
    else
        return menuItemsLogout.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"";
    UITableViewCell *cell;
    NSInteger row = indexPath.row;
    NSString *menuName = @"";
    
    if (isLogin == 1)
        menuName = [menuItemsLogin objectAtIndex:row];
    else
        menuName = [menuItemsLogout objectAtIndex:row];
    
    cellIdentifier = menuName;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (row > 0 && [cellIdentifier isEqualToString:@"home"])
        ((MenuCell *) cell).lblMenuTitle.text = NSLocalizedString(@"logout", @"");
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        gymId = @"-1";
    }
}
#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

@end


