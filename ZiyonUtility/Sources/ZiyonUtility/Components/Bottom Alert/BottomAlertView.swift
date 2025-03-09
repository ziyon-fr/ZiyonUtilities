//
//  BottomAlertView.swift
//
//
//  Created by Leon Salvatore on 10/02/2024.
//

import SwiftUI
import Observation

struct BottomAlertView: View {
    var body: some View {
        Button("Present Alert", systemImage: "") {
            
            BottomAlertObserver
                .shared
                .presentAlert(title: "Success coping Data", allowUserInterraction: true, duration: .long)
        }
        .tint(.primary)
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        RootViewOverlay {
            BottomAlertView()
        }
    } else {
        Text("Another version")
            .format(color: .primary)
    }
}


public struct RootViewOverlay<T:View> : View {
    
    var content: T
    
    @State private var overlayWindow: UIWindow?
    
    public init(@ViewBuilder content: @escaping ()-> T) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .preferredColorScheme(.light)
            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
                   let window = PassThroughtWindow(windowScene: windowScene)
                    window.backgroundColor = .clear
                    let rootView = UIHostingController(rootView: BottomAlert())
                    rootView.view.frame = windowScene.keyWindow?.frame ?? .zero
                    rootView.view.backgroundColor = .clear
                    window.rootViewController = rootView
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = 100
                    overlayWindow = window
                }
            }
            
    }
}

fileprivate class PassThroughtWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let inputView = super.hitTest(point, with: event) else { return nil}
        return rootViewController?.view == inputView ? nil : inputView
    }
}

public final class BottomAlertObserver: ObservableObject {
    
    public static let shared = BottomAlertObserver()
    
    @Published fileprivate var bottomAlerts = [BottomAlertModel]()
    
    public func presentAlert(
        title: LocalizedStringResource,
        symbol: String? = nil,
        color: Color = .black,
        allowUserInterraction: Bool = .init(),
        duration: BottomAlertTime = .long) {
            
            let item: BottomAlertModel = .init(
                title: title,
                symbol: symbol,
                color: color,
                allowUserInterraction: allowUserInterraction,
                duration: duration)
            
            withAnimation(.snappy) {
                bottomAlerts.append(item)
            }
            
    }
    
}

struct BottomAlertModel: Identifiable {
    let id: UUID = .init()
    var title: LocalizedStringResource
    var symbol: String?
    var color: Color
    var allowUserInterraction: Bool
    var duration: BottomAlertTime = .default
}

public enum BottomAlertTime: CGFloat {
    
    case `default` = 1.0
    case medium = 2.0
    case long = 3.5
}

fileprivate struct BottomAlert: View {
    
    @StateObject var observer = BottomAlertObserver.shared
    
    var body: some View {
        GeometryReader { geometryProxy in
            let size = geometryProxy.size
            let safeArea = geometryProxy.safeAreaInsets
            ZStack {
                ForEach(observer.bottomAlerts) { alert in
                    AlertView(size: size, item: alert)
                        .scaleEffect(scale(alert))
                        .offset(y:offset(alert))
                        .zIndex(.init(observer.bottomAlerts.firstIndex(where: {$0.id == alert.id}) ?? .zero))
                }
            }
            .padding(.bottom, safeArea.top == .zero ? 15 : 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .preferredColorScheme(.light)
    }
    
    func offset(_ item: BottomAlertModel) -> CGFloat {
         let index = CGFloat(observer.bottomAlerts.firstIndex(where: { $0.id == item.id}) ?? .zero)
        let total = CGFloat(observer.bottomAlerts.count) - 1
        return (total - index) >= 2 ? -20 : ((total - index) * -10)
    }
    func scale(_ item: BottomAlertModel) -> CGFloat {
         let index = CGFloat(observer.bottomAlerts.firstIndex(where: { $0.id == item.id}) ?? .zero)
        let total = CGFloat(observer.bottomAlerts.count) - 1
        return 1.0 - ((total - index) >= 2 ? 0.2 : ((total - index) * 0.1))
    }
}

fileprivate struct AlertView : View {
    
    var size: CGSize
    var item: BottomAlertModel
    
    @State private var delayNotification: DispatchWorkItem?
    var body: some View {
        HStack(spacing: .zero){
            if let symbol = item.symbol {
                Image(systemName: symbol)
                    .font(.title3)
                    .padding(.trailing,.spacer10)
                    .foregroundStyle(.green.gradient)
            }
            Text(item.title)
                .padding(.trailing, .spacer10)
                .lineLimit(1)
                .foregroundStyle(.primary)
        }
        .onTapGesture(perform: removeNotification)
        .foregroundStyle(item.color)
        .padding(.horizontal, .spacer15)
        .padding(.vertical, .spacer8)
        .background(
            .background
                .shadow(.drop(color: .black.opacity(0.05),radius: 5, x: 5, y: 5))
                .shadow(.drop(color: .black.opacity(0.05),radius: 8, x: -5, y: -5)), in: .capsule
        )
        .contentShape(.capsule)
        .gesture(swipeToDismissCapsule)
        .onAppear {
            guard delayNotification == nil  else { return }
            delayNotification = .init { removeNotification()}
            if let delayNotification {
                DispatchQueue
                    .main
                    .asyncAfter(deadline: .now() + item.duration.rawValue, execute: delayNotification)
            }
        }
        .frame(maxWidth: size.width * 0.7)
        .transition(.offset(y:150))
    }
    private func removeNotification() {
        if let delayNotification {
            delayNotification.cancel()
        }
        withAnimation(.snappy) {
            BottomAlertObserver
                .shared
                .bottomAlerts
                .removeAll(where: { $0.id == item.id})
        }

    }
    private var swipeToDismissCapsule: some Gesture {
        DragGesture(minimumDistance: .zero)
            .onEnded { value in
                
                guard item.allowUserInterraction else { return }
                
                let endY = value.translation.height
                let velocityY = value.velocity.height
                
                if (endY +  velocityY) > 100 {
                    removeNotification()
                }
            }
    }
}
