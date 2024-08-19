//
//  UIButton+Publisher.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/10/24.
//

import UIKit
import Combine

extension UIButton {
    func tapPublisher() -> AnyPublisher<Void, Never> {
        return controlEventPublisher(for: .touchUpInside)
    }
    
    private func controlEventPublisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {
        return Publishers.ControlEventPublisher(control: self, events: events)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

extension Publishers {
    struct ControlEventPublisher<Control: UIControl>: Publisher {
        typealias Output = Control
        typealias Failure = Never
        
        private let control: Control
        private let controlEvents: UIControl.Event
        
        init(control: Control, events: UIControl.Event) {
            self.control = control
            self.controlEvents = events
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
            let subscription = ControlEventSubscription(subscriber: subscriber, control: control, event: controlEvents)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private class ControlEventSubscription<S: Subscriber, Control: UIControl>: Subscription where S.Input == Control {
        private var subscriber: S?
        private weak var control: Control?
        
        init(subscriber: S, control: Control?, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            control?.addTarget(self, action: #selector(eventHandler), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {
        }
        
        func cancel() {
            subscriber = nil
        }
        
        @objc private func eventHandler() {
            _ = subscriber?.receive(control!)
        }
    }
}
