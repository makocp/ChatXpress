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
### Widget Tree / Inspector and Navigation
The Widget Inspector is a good way to understand the Widget Tree of the App. Especially, if you want to implement Navigation and Routes. There you can get a good understanding how it works and to find bugs regarding navigation, if there are any.

### Apple Sign In
- You need an Apple Developer account to set this up.
- Additional: If you implement Google Sign In, you also have to implement Apple Sign In (according to Apple App Store policiy)
- Just follow the tutorial below for more detailed Information.

### Git
- Undo last commit: `git reset --soft HEAD~`

### Firebase Firestore
- Solve error with CocoaPods and compatible version for Firestore pre-compiled framework (otherwise build wouldn't start):
    - Added `pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => '10.12.0'` to Podfile according to [Documentation](https://firebase.google.com/docs/firestore/quickstart?authuser=0&_gl=1*1wowrp2*_ga*MTI2NzE5MzExMy4xNjg1OTE0ODMy*_ga_CW55HF8NVT*MTY5MTU1ODAwOC40MC4xLjE2OTE1NTgxNjEuMC4wLjA.#dart)
    - Downgraded version from 10.13.0 to 10.12.0
    - cd ios -> pod deintegrate -> pod repo update -> pod install

### Async Programming
- Future: Represents the result of an asynchronous operation with two states (complete / uncomplete)
- Async: To turn function async + automatically wrap return with Future.
    - IMPORTANT: if method is declared as async, BUT returns void, the function stays synchronous! (no error warning)
- Await: In combination with Async -> makes async functions appear synchronous -> waits for a future to complete before executing the subsequent lines of code.
- For more information, see reference below.

### Unfocus context for keyboard dismiss (ChatView -> Drawer)
- The keyboard gets reopened again, after the drawer gets opened. Here the reference for fixing this issue: [](https://github.com/flutter/flutter/issues/54277#issuecomment-640998757)

### Login Validation
- There is only one error message to hint, that email OR password are incorrect. Otherwise a  malicious user could potentially brute force the password from another user or see if a given email is registered or not.

### Firestore
- Data Structure: In this case, we decided to go with the rule "Shape your data like your queries". That means, data hierarchy of the data in the app is mirrored in the data structure in Firestore, for simplicity reasons.
- Because each chat is directly assignable to an user (1-n), we chose the nested data structure. In case of many to many relation, it would make sense, to save the chats in a separate collection at root.
- Important: Each Read/Write gets billed -> minimize as much as possible.
- Important: Load only data, which is needed at the moment for the user, to avoid massive, unnecassery data load. (e.g.: load only title to display and if user clicks on it, then load the rest data for this object).

### GPT API
- [Meaning of roles in GPT messages](https://ai.stackexchange.com/a/40308)

## References/Info

- [Mitch Koko](https://www.youtube.com/@createdbykoko)
- [Firebase Authentication with E-Mail and Password](https://firebase.google.com/docs/auth/flutter/password-auth)
- [Sign In/Up UI Tutorial incl. Authentication](https://www.youtube.com/watch?v=GvIoBgmNgQw&t=12s&ab_channel=HarsivoEdu)
- Firebase/Authentication Android manually added via Firebase, because Flutterfire via CLI console does not work in our case, helpful resources:
    - [Add Plugin in (old) buildscript way](https://firebase.google.com/docs/android/troubleshooting-faq?hl=en&authuser=0&_gl=1*gbdhlt*_ga*MTI2NzE5MzExMy4xNjg1OTE0ODMy*_ga_CW55HF8NVT*MTY5MDg3ODI2MS4yMy4xLjE2OTA4ODM1MDkuMC4wLjA.#add-plugins-using-buildscript-syntax)
    - [Change minSdk version](https://stackoverflow.com/questions/71014470/android-minsdkversion-with-flutterv2-8-1)
- [Add Google Sign In](https://pub.dev/packages/google_sign_in)
- [Add Apple Sign In](https://www.youtube.com/watch?v=ettlLq2gW0U&t=315s&ab_channel=dbestech)
- [Firebase Firestore](https://firebase.google.com/docs/firestore/quickstart?authuser=0&_gl=1*1wowrp2*_ga*MTI2NzE5MzExMy4xNjg1OTE0ODMy*_ga_CW55HF8NVT*MTY5MTU1ODAwOC40MC4xLjE2OTE1NTgxNjEuMC4wLjA.#dart)
- [GetIt Explanation](https://www.youtube.com/watch?v=DbV5RV2HRUk&ab_channel=FlutterExplained)
- [Future, Async, Await](https://sarunw.com/posts/how-to-use-async-await-in-flutter/)
- [Difference set, update, create](https://stackoverflow.com/questions/46597327/difference-between-firestore-set-with-merge-true-and-update)