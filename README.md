[![Travis](https://api.travis-ci.org/TCA-Team/iOS.svg?branch=master)]()

# TumCampusApp - an unofficial guide through university life

The [TUM Campus App (TCA)](https://itunes.apple.com/app/id1217412716) is an open source project, developed by volunteers and available on the App Store.

The TCA mostly targets phones, but can also be used on tablets or any other device that runs iOS. This is the repo for the iOS Version of the TUM Campus App.

## Work In Progress
This app is currently being developed and is not yet released to the public via the App Store. We are working on setting up the correct pipelines and hope to publish it in the SS 2017.

Features already implemented:
* Calendar Access
* Lecture Details
* Personal Contact Information
* Room Maps
* Tuition Fees Information
* Universal (Person, Room, Lecture) Search
* Cafeteria Information

## Contributing
You're welcome to contribute to this app!
Check out our detailed information at [CONTRIBUTING.md](https://github.com/TCA-Team/iOS/blob/master/CONTRIBUTING.md)!

## Publishing a new version
- You can use _fastlane snapshot_ to automatically generate localized screenshots. If you want to add a view, just record a UI Test and add it to the AutomatedScreenshots.swift test
- App Store metadata is managed in the directory _fastlane/metadata/_. Go edit those and they'll be updated on the store with the next release
- Members of the Apple Developer Team of this app can run _fastlane deliver_ to update the metadata on iTunes Connect (run _fastlane deliver init_ first)

## Policies:
[Privacy policy](https://app.tum.de/landing/privacy/)  
[T&Cs of the lecture chat](https://app.tum.de/landing/chatterms/)

## Support:
You can reach us on [Facebook](https://www.facebook.com/TUMCampus), [Github](https://github.com/TCA-Team/iOS) or via E-Mail [app@tum.de](mailto:app@tum.de)

## License:
Licensed under [GNU GPL v3](http://www.gnu.org/licenses/gpl.html)

