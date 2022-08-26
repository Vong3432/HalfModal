# HalfModal

A reusable modal component for SwiftUI that can be half/full height and support necessarily properties from the UISheetPresentationController.

## Support iOS version
- iOS 14 (Modal is presented with PresentationController)
- iOS 15 and above (Modal is presented with UISheetPresentationController) 

## Features
- Customise modal height (support multiple detents).
- Customise modal corner radius. (iOS 15)
- Customise dimmed area. (iOS 15)
- Default detent from array of detents. (iOS 15)  

## (iOS 15) Currently supported properties from UISheetPresentationController
To avoid confusion, most of the naming of the property variables will be the same with the properties in UISheetPresentationController, unless there is a better naming to replace it.
- detents
- selectedDetentIdentifier
- largestUndimmedDetentIdentifier
- preferredCornerRadius (cornerRadius in HalfModal)
- prefersGrabberVisible (showGrabber in HalfModal)
- prefersScrollingExpandsWhenScrolledToEdge
- prefersEdgeAttachedInCompactHeight
- widthFollowsPreferredContentSizeWhenEdgeAttached

## Demo

### iOS 14.0
#### Half height modal only
```
HalfModalView14(
    content: { Text("Content") }, 
    detent: .medium, 
    isPresented: $presented) {
    print("Dismissed")
}
```

#### Full height modal only
```
HalfModalView14(
    content: { Text("Content") }, 
    detent: .large, 
    isPresented: $presented) {
    print("Dismissed")
}
```

#### Usage with modifiers
```
    NavigationView {
        VStack {
            Button("Tap") { presented = true }
        }
    }
    .sheet(
        isPresented: $presented,
        detent: .medium,
        onDismiss: onDismissed,
        content: {
            Text("Detail")
        }
    )
```

### iOS 15.0 and above
#### Half height modal only
```
HalfModal(
    content: { DetailView() }, 
    isPresented: $show,
    detents: [.medium()],
    )
```

#### Half + Full height modal only
```
HalfModal(
    content: { DetailView() }, 
    isPresented: $show,
    detents: [.medium(), .large()],
    )
```

#### Half + Full height modal and other features from UISheetPresentationController.
```
HalfModal(
    content: { ... }, 
    isPresented: $presented, 
    detents: [.medium(), .large()], 
    selectedDetentIdentifier: .large, // default detent for the modal
    cornerRadius: 50.0, 
    showGrabber: true) 
```

#### Usage with modifiers
```
    NavigationView {
        VStack {
            Button("Tap") { presented = true }
        }
    }
    .sheet(
        isPresented: $presented,
        detents: [.medium(),.large()],
        selectedDetentIdentifier: .large
        ,
        cornerRadius: 50.0,
        showGrabber: true, 
        content: {
            Text("Detail")
        }
    )
```
