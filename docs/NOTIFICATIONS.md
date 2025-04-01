# PackPal Notification System

This document describes the notification system implemented in PackPal.

## Overview

PackPal uses Flutter Local Notifications plugin to schedule reminders for users to pack their items before their travel date. The notification system is designed to:

1. Send reminders 1 day before the departure date
2. Allow users to toggle notifications on/off in settings
3. Automatically schedule notifications when users create or update packing lists
4. Handle both foreground and background notifications

## Implementation Details

### Core Components

- `NotificationService`: A singleton service that handles all notification-related functionality
- `HivePackingListRepository`: Extended to handle notification scheduling when packing lists are created, updated, or deleted

### Features

- **Localized Notifications**: All notification content is localized using the app's existing localization system
- **Platform-specific Setup**: Configured for both iOS and Android platforms
- **Permission Handling**: Handles permission requests and status checks
- **Notification Scheduling**: Schedules notifications based on packing list departure dates
- **Notification Management**: Allows canceling individual or all notifications

### How Notifications Work

1. When the app starts, the notification service is initialized
2. Notifications are scheduled for all existing packing lists with departure dates
3. When a new packing list is created, a notification is scheduled if a departure date is set
4. When a packing list is updated, its notification is rescheduled
5. When a packing list is deleted, its notification is canceled
6. Users can toggle notifications on/off in the app settings

## User Experience

When a notification is received:

1. If the app is in the foreground, the notification appears as an in-app alert
2. If the app is in the background, the notification appears in the system notification tray
3. Tapping the notification can take the user to the relevant packing list (future implementation)

## Adding New Notification Types

To add a new type of notification:

1. Add the appropriate translation keys to `/assets/translations/en.json` and `/assets/translations/tr.json`
2. Regenerate localization files with `flutter pub run easy_localization:generate`
3. Add a new method in `NotificationService` to schedule the new notification type
4. Update the appropriate repository to trigger the new notification

## Testing Notifications

To test notifications:
1. Create a packing list with a departure date set to tomorrow
2. Check that a notification is scheduled
3. Modify the packing list and verify that the notification is rescheduled
4. Delete the packing list and verify that the notification is canceled
5. Toggle notifications off in settings and verify that all notifications are canceled

## Debugging

When debugging notification issues:
- On Android, check the notification channel settings
- On iOS, verify that notification permissions have been granted
- Use the `flutter_local_notifications` debug tools to verify scheduled notifications 