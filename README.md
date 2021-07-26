<img width="128" alt="mac256" src="https://user-images.githubusercontent.com/18324562/126957963-e2190870-4f52-481a-b9e3-88bfe84bc663.png">

# Transitions
A simple iOS app with one default and four custom transitions.
The app uses the same two view controllers for every transition.

## Slide
The presented view controller slides in from the right with little overshoot. It uses the default animation provided by UIKit for its dismissal.

## Action Sheet
The presented view controller slides in from the bottom with the default animation provided by UIKit.

Along with the transition, the background (presenting view controller) is dimmed by the blurred view.

The view controller can be dismissed by tap on the dimmed view or by pulling it down. It uses the default animation provided by UIKit for its dismissal.

## Alert
The presented view controller appears in the center by enlarging and fading in.

Along with the transition, the background (presenting view controller) is dimmed with the blurred view.

The view controller disappears by shrinking and fading out.

## Fancy
The presented view controller fades in while the selected button of the presenting view controller moves across the screen to the position of the presented view controller's title label. Other elements fades out.



![custom action sheet](https://user-images.githubusercontent.com/18324562/126958186-e73e8b65-3ac2-4c61-a38c-f3d9c4a05048.gif)

