# MemeMe
### iOS Developer Nanodegree Project

The MemeMe app is result of Udacity's iOS Developer Nanodegree course.

MemeMe is a meme-generating app that enables a user to attach a caption to a picture from their phone. After adding text to an image chosen from the Photo Album or Camera, the user can share it with friends. MemeMe also temporarily stores sent memes which users can browse in a table or a grid.

## Implementation
MemeMe has three Scenes:
- **Meme Editor View**: Enables a user to add text to an image and share it. 
- **Sent Memes View**: Enables a user to browse sent memes in a table or a grid.
- **Meme Detail View**: Displays an image of a sent meme

## User Flow
When the user first launches the app the Sent Memes View will appear. It will be the root view of the navigation stack. When the user taps the + button in the top right corner the app should push the Meme Editor View on top of the Sent Memes View.

## Requirements
- Xcode 9+
- Swift 4
