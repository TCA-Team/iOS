[![Build Status](https://travis-ci.org/TUM-Dev/Campus-iOS.svg?branch=master)](https://travis-ci.org/TUM-Dev/Campus-iOS)
<a href="https://beta.tumcampusapp.de">
<img src="https://developer.apple.com/assets/elements/icons/testflight/testflight-64x64_2x.png" height="42" align="right">
</a>
<a href="https://itunes.apple.com/us/app/tum-campus-app/id1217412716?mt=8">
<img src="https://devimages-cdn.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg" height="42" align="right">
</a>

# Tum Campus App - An Unofficial Guide Through University Life

The TUM Campus App (TCA) is an open source project, developed by volunteers and [available on the App Store](https://itunes.apple.com/app/id1217412716).

It mostly targets phones, but can also be used on tablets or any other device that runs iOS. This is the repo for the iOS version of the TUM Campus App.

## Features

- [x] Calendar Access
- [x] Lecture Details
- [x] Grades
- [x] Tuition Fees Information
- [x] Study Room Availability
- [x] MVG Departure Times
- [x] News Feed
- [x] Cafeteria Menus
- [x] TU Film Schedule
- [x] Personal Contact Information
- [x] Room Maps
- [x] Universal Search: Persons, Rooms, Lectures
- [x] [TUM.sexy](https://tum.sexy) Redirects

## Contributing
You're welcome to contribute to this app!
Check out our detailed information at [CONTRIBUTING.md](https://github.com/TCA-Team/iOS/blob/master/CONTRIBUTING.md)!

## Publishing a new version
- You can use `fastlane snapshot` to automatically generate localized screenshots. If you want to add a view, just record a UI Test and add it to the [`AutomatedScreenshots.swift`](./AutomatedScreenshots/AutomatedScreenshots.swift) test
- App Store metadata is managed in the directory [`fastlane/metadata/`](./fastlane/metadata). Go edit those and they'll be updated on the store with the next release
- Members of the Apple Developer Team of this app can run `fastlane deliver` to update the metadata on iTunes Connect (run `fastlane deliver init` first)

## Beta
If you want to participate in the beta of this app, enter your details [here](https://beta.tumcampusapp.de) to get invited via TestFlight.

## Policies
[Privacy policy](https://app.tum.de/landing/privacy/)  
[T&Cs of the lecture chat](https://app.tum.de/landing/chatterms/)

## Support
You can reach us on [Facebook](https://www.facebook.com/TUMCampus), [Github](https://github.com/TCA-Team/iOS) or via E-Mail [app@tum.de](mailto:app@tum.de)

## License
Licensed under [GNU GPL v3](http://www.gnu.org/licenses/gpl.html)

