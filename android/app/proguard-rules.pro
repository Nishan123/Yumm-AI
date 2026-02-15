# Pushy SDK references Firebase Messaging optionally.
# Since we don't use Firebase, suppress the missing class warning for R8.
-dontwarn com.google.firebase.messaging.FirebaseMessaging
-dontwarn com.google.firebase.messaging.**
