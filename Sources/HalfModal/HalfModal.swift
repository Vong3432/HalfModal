import SwiftUI
import UIKit


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
    
    public init(
        @ViewBuilder content: () -> Content,
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.large()],
        selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        cornerRadius: CGFloat = 10.0,
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
            sheetController.prefersScrollingExpandsWhenScrolledToEdge = false
            sheetController.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
            sheetController.selectedDetentIdentifier = selectedDetentIdentifier
            sheetController.preferredCornerRadius = cornerRadius
        }
        
        // Set the coordinator (delegate)
        // We need the delegate to use the presentationControllerDidDismiss function
        viewController.presentationController?.delegate = context.coordinator
        
        
        if isPresented {
            // Present the viewController
            uiView.window?.rootViewController?.present(viewController, animated: true)
        } else {
            // Dismiss the viewController
            uiView.window?.rootViewController?.dismiss(animated: true)
        }
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let view = UIView()
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

