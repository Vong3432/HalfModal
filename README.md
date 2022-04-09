# HalfModal

A reusable modal component that can be half/full height for SwiftUI.

### Features
- Customize modal height

### Demo

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