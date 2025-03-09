//
//  PinchZoomGesture.swift
//  
//
//  Created by Elioene Silves Fernandes on 29/03/2024.
//

import SwiftUI

struct PinchZoomGesture: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


public extension View {
    
    @ViewBuilder
    func zoom(hiddenBackground: Bool = true)-> some View {
        PinchZoomGestureHelper(hiddenBackground: hiddenBackground) { self }
    }
}

/// Zoom Container View
/// Zoomed content will be displayed here
public struct ZoomContainerView<T:View>: View {
    
    var content: T
    
    @StateObject fileprivate var observer : PinchZoomGestureObserver = .init()
    
    public init(@ViewBuilder content: @escaping () -> T) {
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { _ in
            
            content.environmentObject(observer)
            
            ZStack(alignment: .topLeading) {
                
                if let view = observer.zoomedView {
                    Group {
                        if observer.hiddenBackground {
                            Rectangle()
                                .fill(.black.opacity(0.25))
                                .opacity(observer.zoom - 1)
                        }
                        
                        view
                            .scaleEffect(observer.zoom, anchor: observer.zoomAnchor)
                            .offset(observer.dragOffset)
                        /// View Position
                            .offset(x: observer.viewCoordinates.minX, y: observer.viewCoordinates.minY)
                    }
                    
                }
            }.ignoresSafeArea()
        }
    }
}

fileprivate final class PinchZoomGestureObserver: ObservableObject {
    
    
    @Published var zoomedView: AnyView?  = nil
    @Published var viewCoordinates: CGRect = .zero
    @Published var hiddenBackground: Bool = .init()
    
    /// View Properties
    @Published var zoom: CGFloat = 1
    @Published var zoomAnchor: UnitPoint = .center
    @Published var dragOffset: CGSize = .zero
    
    @Published var isResseting: Bool = .init()
    
    init() {
        print("\(Self.self) - Object initialized")
    }
    
    deinit {
        print("\(Self.self) - Object dealocated")
    }
}

/// View Helper
fileprivate struct PinchZoomGestureHelper<T:View>: View {
    
    var hiddenBackground: Bool
    
    @ViewBuilder var content: T
    
    @EnvironmentObject private var observing: PinchZoomGestureObserver
    /// View Properties
    @State private var config: Config = .init()
    
    var body: some View {
        content
            .opacity(config.hideSourceView ? 0 : 1)
            .overlay(GestureOverlay(config: $config))
            .overlay {
                GeometryReader {
                    
                    let rect = $0.frame(in: .global)
                    
                    Color.clear
                        .onChange(of: config.isGestureActive) { newValue in
                            /// Present View inside the Zoom Container
                            guard !observing.isResseting else { return }

                            if newValue {
                                observing.viewCoordinates = rect
                                observing.zoomAnchor = config.zoomAnchor
                                observing.hiddenBackground = hiddenBackground
                                observing.zoomedView = .init(erasing: content)
                                
                                /// Hides Source View
                                config.hideSourceView = true
                            } else {
                                /// Resetting view States
                                observing.isResseting = true
                                if #available(iOS 17.0, *) {
                                    withAnimation(.snappy(duration: 0.3, extraBounce: .zero), completionCriteria: .logicallyComplete) {
                                        
                                        observing.dragOffset = .zero
                                        observing.zoom = 1
                                    } completion: {
                                        /// Reseting Configurations
                                        config = .init()
                                        /// removing View from Container
                                        observing.zoomedView = nil
                                        observing.isResseting = .random()
                                    }
                                    
                                } else {
                                    observing.isResseting = true
                                    withAnimation(.snappy(duration: 0.3, extraBounce: .zero)) {
                                        observing.dragOffset = .zero
                                        observing.zoom = 1
                                        /// Reseting Configurations
                                        config = .init()
                                        /// removing View from Container
                                        observing.zoomedView = nil
                                        observing.isResseting = .init()
                                    }
                                }
                            }
                        }
                        .onChange(of: config) {  newValue in
                            /// Updating View Position, Scale and Zoom Container
                            if config.isGestureActive && observing.isResseting {
                                observing.zoom = config.zoom
                                observing.dragOffset = config.dragOffset
                            }
                        }
                }
            }
               
        
        
    }
}

/// Configurations
fileprivate struct Config: Equatable {
    var isGestureActive: Bool = .init()
    var zoom: CGFloat = 1
    var zoomAnchor: UnitPoint = .center
    var dragOffset: CGSize = .zero
    var hideSourceView: Bool = .init()
}

// Gesture
fileprivate struct GestureOverlay: UIViewRepresentable {
    
    /*
     The reason for creating a config struct is that
     we can easily transfer all the data we need to transfer
     from SwiftUl View to UlKit View as one binding rather than creating multiple bindings.
     */
    @Binding var config: Config
    
    func makeCoordinator() -> Coordinator {
        Coordinator(config: $config)
    }
    
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        /// `Pan Gesture`
        /// - A continuous gesture recognizer that interprets panning gestures.
        let panGesture = UIPanGestureRecognizer()
        panGesture.name = GesturesRegister.pan.rawValue
        panGesture.maximumNumberOfTouches = 2
        panGesture.addTarget(context.coordinator, action: #selector(Coordinator.panGesture))
        panGesture.delegate = context.coordinator
        view.addGestureRecognizer(panGesture)
        
        /// `Pinch Gesture`
        /// - A continuous gesture recognizer that interprets panning gestures.
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.name = GesturesRegister.pinch.rawValue
        pinchGesture.addTarget(context.coordinator, action: #selector(Coordinator.pinchGesture))
        pinchGesture.delegate = context.coordinator
        view.addGestureRecognizer(pinchGesture)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    class Coordinator : NSObject, UIGestureRecognizerDelegate {
        
        @Binding var config: Config
        
        init(config: Binding<Config>) {
            self._config = config
        }
        
        /// Methods for handling pan and pinch gestures.
        // MARK: - Methods

        /// Handles the pan gesture to update zoom and offset values.
        /// - Parameters:
        ///   - gesture: The UIPanGestureRecognizer instance.
        /// - If the gesture state is `.began`, it updates the zoom anchor point to the current location within the view's bounds.
        /// - If the gesture state is `.began` or `.changed`, it calculates the translation of the gesture and updates the drag offset accordingly, marking the gesture as active.
        /// - If the gesture state is neither `.began` nor `.changed`, it marks the gesture as inactive.
        @objc
        func panGesture(gesture: UIPanGestureRecognizer) {
            if gesture.state == .began {
                let location = gesture.location(in: gesture.view)
                if let bounds = gesture.view?.bounds {
                    /// - pinpointing the `anchor point` where the `touch began to pinch and zoom` the view from there.
                    config.zoomAnchor = .init(x:  location.x / bounds.width, y: location.y / bounds.height)
                }
            }
            if gesture.state == .began || gesture.state == .changed {
                let translation = gesture.translation(in: gesture.view)
                config.dragOffset = .init(width: translation.x, height: translation.y)
                config.isGestureActive = true
            } else {
                config.isGestureActive = .init()
            }
        }

        /// Handles the pinch gesture to update zoom value.
        /// - Parameters:
        ///   - gesture: The UIPinchGestureRecognizer instance.
        @objc
        func pinchGesture(gesture: UIPinchGestureRecognizer) {
            if gesture.state == .began || gesture.state == .changed {
                /// limiting the scale gesture to `1` but it can be changed to a lower or higher value
                let scale = max(gesture.scale, 1)
                config.zoom = scale
                config.isGestureActive = true
            } else {
                config.isGestureActive = .init()
            }
        }

        // MARK: - UIGestureRecognizerDelegate

        /// Makes both the pan gesture and pinch gesture work simultaneously.
        /// - NOTE: Don't use OR (&&)  operator, use  AND (||) operator.
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
                if gestureRecognizer.name == GesturesRegister.pan.rawValue  && otherGestureRecognizer.name == GesturesRegister.pinch.rawValue {
                    return true
                }
                return .init()
        }
    }
}

fileprivate enum GesturesRegister: String {
    case pan = "PINCH_PANGESTURE"
    case pinch = "PINCH_ZOOM_ESTURE"
}
#Preview {
    Preview().environmentObject(PinchZoomGestureObserver())
        
}

struct Preview: View {
    var body: some View {
        
        ZoomContainerView {
            Image(.post)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .zoom()
        }
        
    }
}
