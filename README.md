# YouTube Feed Example

<p align="center">
<img src="https://img.shields.io/badge/Swift-4.0-orange.svg" alt="Swift 4.0"/>
<img src="https://img.shields.io/badge/Carthage-✔-blue.svg" alt="Carthage compatible"/>
</a>
</p>

**YouTube Feed Example** reads a sample YouTube channel feed and displays a list of videos. Selecting a list item will display a detail view showing additional information.


## Features
- [x] Pure Swift 4.
- [x] Uses CollectionViewSlantedLayout.
- [x] Channel list and video playback with YouTube API.

## Dependencies

Uses [CollectionViewSlantedLayout](https://github.com/yacir/CollectionViewSlantedLayout) and [YouTubePlayer](https://github.com/gilesvangruisen/Swift-YouTube-Player) which can be installed by running Carthage in the project directory. Carthage can be installed from [here](https://github.com/Carthage/Carthage) .

```terminal
update --platform iOS
```
## Usage

You may need a YouTube API key to run the example project. An API key can be obtained from the [Google Developer Console](https://console.developers.google.com). The API key will then need to be set in the plist for the key "YouTube API Key"

Once the key is setup, you can change the defaultChannelKey property in the ContentFeed.swift file to display other channels.

## Author

[Nathan Quirl](https://github.com/nathanquirl)

## Acknowledgement

This project makes use of [CollectionViewSlantedLayout](https://github.com/yacir/CollectionViewSlantedLayout) and [YouTubePlayer](https://github.com/gilesvangruisen/Swift-YouTube-Player)


## License

**YouTube Feed Example** is available under the [MIT license](https://opensource.org/licenses/MIT).

