# chatxpress

A cross-platform Flutter project with Firebase backend and ChatGPT API.

## Developers
- mako.codeproducer@gmail.com
- jalal.codeproducer@gmail.com

## Purpose of this App

## Functionalities

## Learnings
### Firebase Authentication
`flutterfire configure` is a good and convenient way to implement the Firebase connection, BUT it has some problems with Android. After some time I did it like this:
- Implement Android configuration manually
- Implement iOS/macOS/Web with flutterfire configure.
- After each implementation (step by step for each OS), I checked, which files changed. With this method I could understand better what really happens respectively, which changes happen in the code, so in case of an error I could comprehend where it came from.

## References/Info

- [Mitch Koko](https://www.youtube.com/@createdbykoko)
- [Firebase Authentication with E-Mail and Password](https://firebase.google.com/docs/auth/flutter/password-auth)
- [Sign In/Up UI Tutorial incl. Authentication](https://www.youtube.com/watch?v=GvIoBgmNgQw&t=12s&ab_channel=HarsivoEdu)
- Firebase/Authentication Android manually added via Firebase, because Flutterfire via CLI console does not work in our case, helpful resources:
    - [Add Plugin in (old) buildscript way](https://firebase.google.com/docs/android/troubleshooting-faq?hl=en&authuser=0&_gl=1*gbdhlt*_ga*MTI2NzE5MzExMy4xNjg1OTE0ODMy*_ga_CW55HF8NVT*MTY5MDg3ODI2MS4yMy4xLjE2OTA4ODM1MDkuMC4wLjA.#add-plugins-using-buildscript-syntax)
    - [Change minSdk version](https://stackoverflow.com/questions/71014470/android-minsdkversion-with-flutterv2-8-1)
- [Add Google Sign In](https://pub.dev/packages/google_sign_in)
