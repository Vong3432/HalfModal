import SwiftUI
import UIKit



/// Credits to: https://www.createwithswift.com/using-a-uisheetpresentationcontroller-in-swiftui/
public struct HalfModal<Content>: UIViewRepresentable where Content: View {
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    let content: Content
    let detents: [UISheetPresentationController.Detent]
    
    init(
        @ViewBuilder content: () -> Content,
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.large()],
        onDismiss: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.content = content()
        self.detents = detents
        self.onDismiss = onDismiss
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
            sheetController.prefersGrabberVisible = true
            sheetController.prefersScrollingExpandsWhenScrolledToEdge = false
            sheetController.largestUndimmedDetentIdentifier = .medium
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
