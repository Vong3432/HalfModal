import SwiftUI
import UIKit

struct HalfModalViewModifier<MyContent>: ViewModifier where MyContent: View {
    @Binding var isPresented: Bool
    
    /// Closure that calls when modal is dismissed.
    public let onDismiss: (() -> Void)?
    /// View inside the modal.
    public let swiftUIContent: () -> MyContent
    
    ///  The array of heights where a sheet can rest. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801903-detents)
    public let detents: [UISheetPresentationController.Detent]
    
    ///   The largest detent that doesn’t dim the view underneath the sheet. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3858107-largestundimmeddetentidentifier)
    public let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    
    ///  The identifier of the most recently selected detent. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801908-selecteddetentidentifier)
    public let selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    
    ///  A Boolean value that determines whether the sheet shows a grabber at the top. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801906-prefersgrabbervisible)
    public let showGrabber: Bool
    
    
    ///  The corner radius that the sheet attempts to present with. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3852556-preferredcornerradius)
    ///  Default value is 10.0
    public let cornerRadius: CGFloat?
    
    /// A Boolean value that determines whether scrolling expands the sheet to a larger detent. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801907-prefersscrollingexpandswhenscrol)
    /// Default is true
    public let prefersScrollingExpandsWhenScrolledToEdge: Bool
    
    /// A Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801905-prefersedgeattachedincompactheig)
    /// Default is false
    public let prefersEdgeAttachedInCompactHeight: Bool
    
    /// A Boolean value that determines whether the sheet's width matches its view controller's preferred content size. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801911-widthfollowspreferredcontentsize)
    /// Default is false
    public let widthFollowsPreferredContentSizeWhenEdgeAttached: Bool
    
    init(
        @ViewBuilder content: @escaping () -> MyContent,
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.large()],
        selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        cornerRadius: CGFloat = 10.0,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        prefersEdgeAttachedInCompactHeight: Bool = false,
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        showGrabber: Bool = false,
        onDismiss: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.swiftUIContent = content
        self.detents = detents
        self.onDismiss = onDismiss
        self.showGrabber = showGrabber
        self.selectedDetentIdentifier = selectedDetentIdentifier
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.cornerRadius = cornerRadius
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
    }
    
    func body(content: Content) -> some View {
        ZStack {
            HalfModal(
                content: swiftUIContent,
                isPresented: $isPresented,
                detents: detents,
                selectedDetentIdentifier: selectedDetentIdentifier,
                largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                cornerRadius: cornerRadius ?? 0.0,
                prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
                prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
                showGrabber: showGrabber
            ).fixedSize()
            content
        }
    }
}


extension View {
    /**
     Custom modifier that let you use HalfModal component in modifier.
     To lookup the definition of the parameters, you may visit the documentation at <doc:HalfModal/HalfModal>
     - Parameters:
     - isPresented: State of modal
     - detents: The array of heights where a sheet can rest. View more at <doc:HalfModal/HalfModal/detents>
     - selectedDetentIdentifier: The identifier of the most recently selected detent. View more at <doc:HalfModal/HalfModal/selectedDetentIdentifier>
     - largestUndimmedDetentIdentifier: The largest detent that doesn’t dim the view underneath the sheet. View more at <doc:HalfModal/HalfModal/largestUndimmedDetentIdentifier>
     - cornerRadius: The corner radius that the sheet attempts to present with. View more at <doc:HalfModal/HalfModal/cornerRadius>
     - showGrabber: A Boolean value that determines whether the sheet shows a grabber at the top. View more at <doc:HalfModal/HalfModal/showGrabber>
     - onDismiss: Closure that calls when modal is dismissed. View more at <doc:HalfModal/HalfModal/onDismiss>
     - content: The view inside of the modal. View more at <doc:HalfModal/HalfModal/content>
     - prefersScrollingExpandsWhenScrolledToEdge: A Boolean value that determines whether scrolling expands the sheet to a larger detent. View more at <doc:HalfModal/HalfModal/prefersScrollingExpandsWhenScrolledToEdge>
     - prefersEdgeAttachedInCompactHeight: A Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class. <doc:HalfModal/HalfModal/prefersEdgeAttachedInCompactHeight>
     - widthFollowsPreferredContentSizeWhenEdgeAttached: A Boolean value that determines whether the sheet's width matches its view controller's preferred content size. <doc:HalfModal/HalfModal/widthFollowsPreferredContentSizeWhenEdgeAttached>
     */
    public func sheet<Content>(isPresented: Binding<Bool>,detents: [UISheetPresentationController.Detent] = [.large()],
                               selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                               largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                               cornerRadius: CGFloat = 10.0,
                               prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
                               prefersEdgeAttachedInCompactHeight: Bool = false,
                               widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
                               showGrabber: Bool = false, onDismiss: (() -> Void)? = nil,
                               @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        //        print("\(#function) :: isPresented == \(isPresented)")
        return modifier(
            HalfModalViewModifier(
                content: content,
                isPresented: isPresented,
                detents: detents,
                selectedDetentIdentifier: selectedDetentIdentifier,
                largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                cornerRadius: cornerRadius,
                prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
                prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
                showGrabber: showGrabber,
                onDismiss: onDismiss)
        )
    }
}

public struct HalfModal<Content>: UIViewRepresentable where Content: View {
    @Binding var isPresented: Bool
    
    /// Closure that calls when modal is dismissed.
    public let onDismiss: (() -> Void)?
    /// View inside the modal.
    public let content: Content
    
    ///  The array of heights where a sheet can rest. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801903-detents)
    public let detents: [UISheetPresentationController.Detent]
    
    ///   The largest detent that doesn’t dim the view underneath the sheet. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3858107-largestundimmeddetentidentifier)
    public let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    
    ///  The identifier of the most recently selected detent. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801908-selecteddetentidentifier)
    public let selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    
    ///  A Boolean value that determines whether the sheet shows a grabber at the top. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801906-prefersgrabbervisible)
    public let showGrabber: Bool
    
    
    ///  The corner radius that the sheet attempts to present with. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3852556-preferredcornerradius)
    ///  Default value is 10.0
    public let cornerRadius: CGFloat?
    
    /// A Boolean value that determines whether scrolling expands the sheet to a larger detent. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801907-prefersscrollingexpandswhenscrol)
    /// Default is true
    public let prefersScrollingExpandsWhenScrolledToEdge: Bool
    
    /// A Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801905-prefersedgeattachedincompactheig)
    /// Default is false
    public let prefersEdgeAttachedInCompactHeight: Bool
    
    /// A Boolean value that determines whether the sheet's width matches its view controller's preferred content size. [Learn more at apple developer documentation.](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/3801911-widthfollowspreferredcontentsize)
    /// Default is false
    public let widthFollowsPreferredContentSizeWhenEdgeAttached: Bool
    
    public init(
        @ViewBuilder content: () -> Content,
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.large()],
        selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        cornerRadius: CGFloat = 10.0,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        prefersEdgeAttachedInCompactHeight: Bool = false,
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        showGrabber: Bool = false,
        onDismiss: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.content = content()
        self.detents = detents
        self.onDismiss = onDismiss
        self.showGrabber = showGrabber
        self.selectedDetentIdentifier = selectedDetentIdentifier
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.cornerRadius = cornerRadius
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        let viewController = UIViewController()
        
        // Create the UIHostingController that will embed the SwiftUI View
        let hostingController = UIHostingController(rootView: content)
        
        viewController.addChild(hostingController)
        viewController.view.addSubview(hostingController.view)
        
        // Set constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.leftAnchor.constraint(equalTo: viewController.view.leftAnchor).isActive = true
        hostingController.view.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        hostingController.view.rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        hostingController.didMove(toParent: viewController)
        
        // Set the presentationController as a UISheetPresentationController
        if let sheetController = viewController.presentationController as? UISheetPresentationController {
            sheetController.detents = detents
            sheetController.prefersGrabberVisible = showGrabber
            sheetController.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
            sheetController.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
            sheetController.selectedDetentIdentifier = selectedDetentIdentifier
            sheetController.preferredCornerRadius = cornerRadius
            sheetController.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
        }
        
        // Set the coordinator (delegate)
        // We need the delegate to use the presentationControllerDidDismiss function
        viewController.presentationController?.delegate = context.coordinator
        
        if isPresented {
            // Prevent showing modal twice
            if uiView.window?.rootViewController?.presentedViewController == nil {
                // Present the viewController
                uiView.window?.rootViewController?.present(viewController, animated: true)
            }
        } else {
            guard uniqueIdentifier == uiView.window?.rootViewController?.view.accessibilityIdentifier else {
                return
            }
            
            // Dismiss the viewController
            uiView.window?.rootViewController?.dismiss(animated: true)
        }
    }
    
    private let uniqueIdentifier = UUID().uuidString
    
    public func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.accessibilityIdentifier = uniqueIdentifier
        return view
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, onDismiss: onDismiss)
    }
    
    public class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        @Binding var isPresented: Bool
        let onDismiss: (() -> Void)?
        
        init(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil) {
            self._isPresented = isPresented
            self.onDismiss = onDismiss
        }
        
        public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            isPresented = false
            if let onDismiss = onDismiss {
                onDismiss()
            }
        }
        
    }
}

