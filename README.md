# UserNotificaitonDemo
iOS10通知UserNotifications.framework学习(一)

##两个代理方法

    /*此代理方法只会在app处于前台是执行，如果需要前台显示则有Badge、Sound、Alert三种类型可以设置：
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    */
    - (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
    
    /*
    这个代理方法，只有用户点击消息才会触发，用户长按（3DTouch）、Action并不会触发
    */
    - (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
