//
//  HRPGPartyTableViewController.m
//  Habitica
//
//  Created by Phillip Thelen on 11/02/16.
//  Copyright © 2016 Phillip Thelen. All rights reserved.
//

#import "HRPGPartyTableViewController.h"
#import "HRPGGroupFormViewController.h"

@interface HRPGPartyTableViewController ()
@property NSUserDefaults *defaults;
@end

@implementation HRPGPartyTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        self.tutorialIdentifier = @"party";
        self.defaults = [NSUserDefaults standardUserDefaults];
    }

    return self;
}

- (bool)listMembers {
    return YES;
}

- (void)refresh {
    if (!self.groupID) {
        [self.sharedManager fetchGroups:@"party"
            onSuccess:^() {
                if (self.groupID) {
                    [self refresh];
                }
            }
            onError:^(){
            }];
        return;
    }
    [self.sharedManager fetchGroup:@"party"
        onSuccess:^() {
            [self.refreshControl endRefreshing];
            [self fetchGroup];
            self.group.unreadMessages = [NSNumber numberWithBool:NO];
            [self.sharedManager chatSeen:self.group.id];
        }
        onError:^() {
            [self.refreshControl endRefreshing];
            [self.sharedManager displayNetworkError];
        }];
}

- (NSString *)groupID {
    return [self.defaults objectForKey:@"partyID"];
}

- (CGRect)getFrameForCoachmark:(NSString *)coachMarkIdentifier {
    UITableViewCell *cell =
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    return [self.tableView convertRect:cell.frame
                                toView:self.parentViewController.parentViewController.view];
}

- (void)fetchGroup {
    if (self.groupID) {
        [super fetchGroup];
    } else {
        self.group = nil;
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.group) {
        return [super numberOfSectionsInTableView:tableView];
    } else {
        if (self.user.invitedParty) {
            return 1;
        } else {
            return 3;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.group) {
        return [super tableView:tableView numberOfRowsInSection:section];
    } else {
    }
    switch (section) {
        case 0:
            if (self.user.invitedParty) {
                return 3;
            } else {
                return 1;
            }
        case 1:
            return 1;
        case 2: {
            return 1;
        }
        default:
            return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.group) {
        if (self.user.invitedParty) {
            if (indexPath.item == 0) {
                return 44;
            } else {
                return 44;
            }
        } else {
            if (indexPath.section == 2 && indexPath.item == 0) {
                return 100;
            } else if (indexPath.section == 1 && indexPath.item == 0) {
                return 60;
            } else if (indexPath.section == 0 && indexPath.item == 0) {
                return 100;
            }
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.user.invitedParty && !self.group) {
        if (indexPath.item == 1) {
            [self.sharedManager joinGroup:self.user.invitedParty
                withType:@"party"
                onSuccess:^() {
                    [self fetchGroup];
                    [self.tableView reloadData];
                }
                onError:^(){

                }];
        } else if (indexPath.item == 2) {
            // TODO
        }
        return;
    }

    if (!self.group) {
        return;
    }
    return [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.group) {
        NSString *cellname;
        if (self.user.invitedParty) {
            if (indexPath.item == 0) {
                cellname = @"BaseCell";
            } else {
                cellname = @"CenteredCell";
            }
        } else {
            if (indexPath.section == 2 && indexPath.item == 0) {
                cellname = @"JoinPartyCell";
            } else if (indexPath.section == 1 && indexPath.item == 0) {
                cellname = @"CreatePartyCell";
            } else if (indexPath.section == 0 && indexPath.item == 0) {
                cellname = @"PartyDescriptionCell";
            }
        }
        UITableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:cellname forIndexPath:indexPath];
        if (self.user.invitedParty) {
            if (indexPath.item == 0) {
                cell.textLabel.text =
                    [NSString stringWithFormat:NSLocalizedString(@"Invited to %@", nil),
                                               self.user.invitedPartyName];
            } else if (indexPath.item == 1) {
                cell.textLabel.text = NSLocalizedString(@"Accept", nil);
            } else if (indexPath.item == 2) {
                cell.textLabel.text = NSLocalizedString(@"Reject", nil);
            }
        } else {
            if (indexPath.section == 2 && indexPath.item == 0) {
                UILabel *userIDLabel = (UILabel *)[cell viewWithTag:1];
                userIDLabel.text = self.user.id;
            }
        }
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GroupFormSegue"]) {
        if (!self.group) {
            UINavigationController *navigationController =
                (UINavigationController *)segue.destinationViewController;
            HRPGGroupFormViewController *partyFormViewController =
                (HRPGGroupFormViewController *)navigationController.topViewController;
            partyFormViewController.editGroup = NO;
            partyFormViewController.groupType = @"party";
            return;
        }
    }
    [super prepareForSegue:segue sender:sender];
}

- (NSDictionary *)getDefinitonForTutorial:(NSString *)tutorialIdentifier {
    if ([tutorialIdentifier isEqualToString:@"party"]) {
        return @{
            @"text" :
                NSLocalizedString(@"This is where you and your friends can hold each other "
                                  @"accountable to your goals and fight monsters with your tasks!",
                                  nil)
        };
    } else if ([tutorialIdentifier isEqualToString:@"inviteParty"]) {
        return
            @{ @"text" : NSLocalizedString(@"Tap to invite friends and view party members.", nil) };
    }
    return nil;
}

- (bool)canInviteToQuest {
    return YES;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
}

- (IBAction)unwindToListSave:(UIStoryboardSegue *)segue {
    HRPGGroupFormViewController *formViewController =
        (HRPGGroupFormViewController *)segue.sourceViewController;
    if (formViewController.editGroup) {
        [self.sharedManager updateGroup:formViewController.group onSuccess:nil onError:nil];
    } else {
        [self.sharedManager createGroup:formViewController.group
                              onSuccess:^() {
                                  [self fetchGroup];
                                  [self.tableView reloadData];
                              }
                                onError:nil];
    }
}

@end
