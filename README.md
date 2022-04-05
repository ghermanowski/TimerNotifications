# TimerNotifications (iOS)

Use TimerNotifications to remind yourself using notifications. After choosing a title you can select a duration after which you want to be notified or you can specify a time. The notifications are scheduled using the async/await API.

Created at Apple Developer Academy Napoli


## Tutorial: How to Use Local Notifications

In this tutorial you will learn how to send notifications in your app.

We will be using the async/await API throughout these steps. Some familiarity with it will be very helpful for you.

### Setup

After creating a new Xcode project, go to the build file and select info for the target. Add a new property called `NSUserNotificationsUsageDescription` in which you describe what your app needs to use notifications for. The system needs this property to ask the user for permission.

<img width="1280" alt="Setting NSUserNotificationsUsageDescription" src="https://user-images.githubusercontent.com/57409167/161842258-2f5a2957-7232-4ed0-a322-818e5891a377.png">

### Requesting Permission

Next create a new file with a class to manage the notifications — NotificationManager would be a fitting name. 

Inside the class add a constant called notificationCenter which you set to `UNUserNotificationCenter.current()`. `UNUserNotificationCenter` provides you tools to manage your apps notifications. Using the method `current()`, you get the notification center for your app.

With the following statement you can request permission from the user. We ask for permission to display alerts with sound and to set badges for our app on the home screen.

```swift
try? await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
```

<img width="320" alt="Permission Request Alert" src="https://user-images.githubusercontent.com/57409167/161842442-924a1608-52ba-430c-bfaa-a79f41f80587.png">

To check whether permission has been granted, you can use the following lines:

```swift
let settings = await notificationCenter.notificationSettings()
let canSendNotifications = settings.authorizationStatus == .authorized
```

### Scheduling Notifications

To schedule a notification, you need three parts to make up the `UNNotificationRequest` you will add to your `UNUserNotificationCenter`.

1. An identifier. Ideally you can use one from your model, otherwise you can just use `UUID().uuidString` to create a new one.
2. The content of the notification (`UNNotificationContent`) needs to have a title that is not empty, otherwise the notification does not appear. You can also add more information in the body parameter, or add a sound or attachments to present in the notification. In TimerNotifications, I included title, subtitle and body.
3. A trigger, to determine when your notification is sent. There a few different types including:
    - `UNTimeIntervalNotificationTrigger`: Send a notification after a specified amount of seconds.
    - `UNCalendarNotificationTrigger`: Send a notification at a certain date using the type `DateComponents`.
    - `UNLocationNotificationTrigger` and `UNPushNotificationTrigger` will not be covered here.

To see how I created the triggers, take a look at `NotificationManager.sendNotification(in:)` and `NotificationManager.sendNotification(at:)`.

Finally you can schedule the notification like this:

```swift
let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
try? await notificationCenter.add(request)
```

### Removing Notifications

If a scheduled notification should not be sent, you can remove them without the user noticing. Use the instance method of `UNUserNotificationCenter` called `removePendingNotificationRequests(withIdentifiers:)`.

### Conclusion

Now you know the basics of scheduling notifications locally. Take a look at the official documentation to find out more, like how to attach attachments or actions to notifications.

## Final Result

You can see how I used notifications in the project files. The notification content is created differently than in the tutorial, but the same principles apply.
