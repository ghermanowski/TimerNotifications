# TimerNotifications (iOS)

Use TimerNotifications to remind yourself using notifications. After choosing a title you can select a duration after which you want to be notified or a specify a time. The notifications are scheduled using the async/await API.

Created at Apple Developer Academy Napoli


## Tutorial: How to Use Local Notifications

###### Setup

After creating a new Xcode project, go to the build file and select info for the target. Add a new property called NSUserNotificationsUsageDescription in which you describe what your app needs to use notifications for.

###### Requesting Permission

Next create a new file with a class to manage the notifications — NotificationManager would be a fitting name. Add the following method to the class:

```
func requestPermission() async {
	do {
		try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
	} catch {
		print(error)
	}
}
```

To check whether permission has been granted, you can use the following method:

```
func canSendNotfications() async -> Bool {
	let settings = await UNUserNotificationCenter.current().notificationSettings()
	return settings.authorizationStatus == .authorized
}
```


###### Scheduling Notifications

To schedule a notification, you need three parts to make up the ```UNNotificationRequest``` you will add to your ```UNUserNotificationCenter```.

1. An identifier. Ideally you can use one from your model, otherwise you can just use ```UUID().uuidString``` to create a new one.
2. The content of the notification (```UNMutableNotificationContent```) needs to have a title that is not empty, otherwise the notification does not appear. You can also add more information in the body or add a sound or attachements to present in the notification. In TimerNotifications, I included title, subtitle and body.
3. A trigger, to determine when your notification is sent. There a few different types including: 
   - ```UNTimeIntervalNotificationTrigger```: Send a notification after a specified amount of seconds.
   - ```UNCalendarNotificationTrigger```: Send a notification at a certain date (```DateComponents```).
   - ```UNLocationNotificationTrigger``` and ```UNPushNotificationTrigger``` will not be covered here.

To see out how I created the triggers, take a look at ```NotificationManager.sendNotification(in:)``` and ```NotificationManager.sendNotification(at:)```.

Finally you can schedule the notification like this:

```
private func scheduleNotification(identifier: String, content: UNNotificationContent, trigger: UNNotificationTrigger) async {
	let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
		
	do {
		try await UNUserNotificationCenter.current().add(request)
	} catch {
		print(error)
	}
}
```

###### Removing Notifications

If a scheduled notification should not be sent, you can remove it like this:

```
let identifiers = [String]()  // Replace with the ID(s)
UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
```

You can get all previously scheduled notifications using the async instance method of ```UNUserNotificationCenter``` called ```pendingNotificationRequests()```.

###### Finished

Now you know the basics of scheduling notifications. Take a look at the official documentation to find out more.
