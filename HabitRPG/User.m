//
//  User.m
//  HabitRPG
//
//  Created by Phillip Thelen on 21/04/14.
//  Copyright (c) 2014 Phillip Thelen. All rights reserved.
//

#import "User.h"
#import "Egg.h"
#import "Gear.h"
#import "Group.h"
#import "Quest.h"
#import "Reward.h"
#import "Tag.h"
#import "Task.h"
#import "HRPGAppDelegate.h"
#import "HRPGManager.h"

@implementation User

@dynamic costumeArmor;
@dynamic costumeBack;
@dynamic costumeHead;
@dynamic costumeHeadAccessory;
@dynamic costumeShield;
@dynamic costumeWeapon;
@dynamic currentMount;
@dynamic currentPet;
@dynamic dayStart;
@dynamic equippedArmor;
@dynamic equippedBack;
@dynamic equippedHead;
@dynamic equippedHeadAccessory;
@dynamic equippedShield;
@dynamic equippedWeapon;
@dynamic experience;
@dynamic gold;
@dynamic hairBangs;
@dynamic hairBase;
@dynamic hairBeard;
@dynamic hairColor;
@dynamic hairMustache;
@dynamic hclass;
@dynamic health;
@dynamic id;
@dynamic level;
@dynamic magic;
@dynamic maxHealth;
@dynamic maxMagic;
@dynamic nextLevel;
@dynamic shirt;
@dynamic size;
@dynamic skin;
@dynamic sleep;
@dynamic username;
@dynamic groups;
@dynamic ownedEggs;
@dynamic ownedFood;
@dynamic ownedGear;
@dynamic ownedHatchingPotions;
@dynamic ownedQuests;
@dynamic party;
@dynamic rewards;
@dynamic tags;
@dynamic tasks;


- (void)setAvatarOnImageView:(UIImageView *)imageView {
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:16];
    for(int i = 0; i<=16; i++) {
        [imageArray addObject:[NSNull null]];
    }
    int currentLayer = 0;
    HRPGAppDelegate *appdelegate = (HRPGAppDelegate*)[[UIApplication sharedApplication] delegate];
    HRPGManager *sharedManager = appdelegate.sharedManager;
    __block UIImage *currentPet = nil;
    __block UIImage *currentMount = nil;
    __block UIImage *currentMountHead = nil;
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [sharedManager getImage:[NSString stringWithFormat:@"skin_%@", self.skin] onSuccess:^(UIImage *image) {
        [imageArray replaceObjectAtIndex:currentLayer withObject:image];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    currentLayer++;
    [sharedManager getImage:[NSString stringWithFormat:@"%@_shirt_%@", self.size, self.shirt] onSuccess:^(UIImage *image) {
        [imageArray replaceObjectAtIndex:currentLayer withObject:image];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    currentLayer++;
    [sharedManager getImage:[NSString stringWithFormat:@"head_0"] onSuccess:^(UIImage *image) {
        [imageArray replaceObjectAtIndex:currentLayer withObject:image];
        dispatch_group_leave(group);
    }];
    
    if (![self.equippedHead isEqualToString:@"head_base_0"]) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:self.equippedHead onSuccess:^(UIImage *image) {
            [imageArray replaceObjectAtIndex:currentLayer withObject:image];
            dispatch_group_leave(group);
        }];
    }
    
    if (![self.equippedArmor isEqualToString:@"armor_base_0"]) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:[NSString stringWithFormat:@"%@_%@", self.size, self.equippedArmor] onSuccess:^(UIImage *image) {
            [imageArray replaceObjectAtIndex:currentLayer withObject:image];
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.hairBase integerValue] != 0) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:[NSString stringWithFormat:@"hair_bangs_%@_%@", self.hairBangs, self.hairColor] onSuccess:^(UIImage *image) {
            [imageArray replaceObjectAtIndex:currentLayer withObject:image];
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.hairBase integerValue] != 0) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:[NSString stringWithFormat:@"hair_mustache_%@_%@", self.hairMustache, self.hairColor] onSuccess:^(UIImage *image) {
            [imageArray replaceObjectAtIndex:currentLayer withObject:image];
            dispatch_group_leave(group);
    }];
    }
        
    if ([self.hairBase integerValue] != 0) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:[NSString stringWithFormat:@"hair_beard_%@_%@", self.hairBeard, self.hairColor] onSuccess:^(UIImage *image) {
            [imageArray replaceObjectAtIndex:currentLayer withObject:image];
            dispatch_group_leave(group);
        }];
    }
    
    if (![self.equippedHead isEqualToString:@"head_base_0"]) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:self.equippedHead onSuccess:^(UIImage *image) {
            [imageArray replaceObjectAtIndex:currentLayer withObject:image];
            dispatch_group_leave(group);
        }];
    }
    
    if (![self.equippedHeadAccessory isEqualToString:@"headAccessory_base_0"]) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:self.equippedHeadAccessory onSuccess:^(UIImage *image) {
            [imageArray replaceObjectAtIndex:currentLayer withObject:image];
            dispatch_group_leave(group);
        }];
    }
    
    if (![self.equippedShield isEqualToString:@"shield_base_0"]) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:self.equippedShield onSuccess:^(UIImage *image) {
            [imageArray replaceObjectAtIndex:currentLayer withObject:image];
            dispatch_group_leave(group);
        }];
    }
    
    if (![self.equippedWeapon isEqualToString:@"weapon_base_0"]) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:self.equippedWeapon onSuccess:^(UIImage *image) {
            [imageArray replaceObjectAtIndex:currentLayer withObject:image];
            dispatch_group_leave(group);
        }];
    }
    
    if (self.sleep) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:@"zzz" onSuccess:^(UIImage *image) {
            [imageArray replaceObjectAtIndex:currentLayer withObject:image];
            dispatch_group_leave(group);
        }];
    }
    
    if (self.currentPet) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:[NSString stringWithFormat:@"Pet-%@", self.currentPet] onSuccess:^(UIImage *image) {
            currentPet = image;
            dispatch_group_leave(group);
        }];
    }
    
    if (self.currentMount) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:[NSString stringWithFormat:@"Mount_Head_%@", self.currentMount] onSuccess:^(UIImage *image) {
            currentMountHead = image;
            dispatch_group_leave(group);
        }];
    }
    
    if (self.currentMount) {
        dispatch_group_enter(group);
        currentLayer++;
        [sharedManager getImage:[NSString stringWithFormat:@"Mount_Body_%@", self.currentMount] onSuccess:^(UIImage *image) {
            currentMount = image;
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(140.f, 147.f), NO, 0.0f);
        int yoffset = 18;
        if (self.currentMount) {
            yoffset = 0;
            [currentMount drawInRect:CGRectMake(25, 18, currentMount.size.width, currentMount.size.height)];
        }
        for (id item in imageArray) {
            if (item != [NSNull null]) {
                UIImage *addImage = (UIImage*)item;
                [addImage drawInRect:CGRectMake(25, yoffset, addImage.size.width, addImage.size.height)];
            }
        }
        if (self.currentMount) {
            [currentMountHead drawInRect:CGRectMake(25, 18, currentMountHead.size.width, currentMountHead.size.height)];
        }
        if (self.currentPet) {
            [currentPet drawInRect:CGRectMake(0, 43, currentPet.size.width, currentPet.size.height)];
        }
        
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = resultImage;
        });
    });
}

@end
