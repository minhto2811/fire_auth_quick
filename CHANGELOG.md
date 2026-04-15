#2.2.0

* Update dependencies

---

#2.1.4

* Define `Exception` 

---

#2.1.3

* Fix `signOut` function

---

#2.1.2

* Add
  `required environment variables (only for desktop): --dart-define=GOOGLE_CLIENT_ID=xxx --dart-define=GOOGLE_SERVER_CLIENT_ID=xxx`
* Add `googleSignInSilentForDesktop` function

---

## 2.1.1

### 📝 Notes

* Fix:
  `GoogleSignInException(code GoogleSignInExceptionCode.unknownError, [28444] Developer console is not set up correctly., null)`

---

## 2.1.0

### ✨ New Features

* Added support for Google Sign-In on Windows platform.

### 📝 Notes

* This enables authentication via Google accounts in desktop (Windows) applications.
* Requires proper configuration of Google OAuth credentials (Web Client ID).
* Compatibility with Firebase Authentication may vary depending on platform limitations.

---

## 2.0.5

* Update `firebase_auth: ^6.2.0`

---

## 2.0.4

* Fix `serverClientId must be provided on Android` ~ `googleInitialize`

---

## 2.0.3

* Fix

---

## 2.0.2

* Update dependencies `google_sign_in: ^7.2.0`, `firebase_auth: ^6.0.2`

---

## 2.0.1

* Add Function `setScopes(List<String> scopes)`

---

## 2.0.0

* Update dependencies `Remove Facebook login`

---

## 1.0.0

* Update dependencies `firebase_auth: ^5.5.3, flutter_facebook_auth: ^7.1.2`

---

## 0.0.10

* Update dependencies `firebase_auth: ^5.5.2`

---

## 0.0.9

* Update dependencies

---

## 0.0.8

* Fix `await FireAuthQuick.delete();` duplicate

---

## 0.0.7

* Fix `await FireAuthQuick.delete();`

---

## 0.0.6

* Update: Export the methods and the original properties.

---

## 0.0.5

* Update dependencies: `firebase_auth: ^5.4.2`

---

## 0.0.4

* Add `unlink(String providerId);`

---

## 0.0.3

* Fix some bugs.

---

## 0.0.2

* Usage example.

---

## 0.0.1

* Describe initial release.
