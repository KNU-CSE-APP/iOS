//
//  ISImage.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/29.
//

import UIKit

public class ISImageView: UIImageView {
    public var isInteractable: Bool = false {
        didSet {
            guard oldValue != isInteractable else { return }
            if isInteractable {
                setupGesture()
                cellForTarget(superview: superview)?.clipsToBounds = false
                isUserInteractionEnabled = true
                pinchGesture.map { addGestureRecognizer($0) }
                panGesture.map { addGestureRecognizer($0) }
                doubleTapGestrue.map {addGestureRecognizer($0)}
            } else {
                pinchGesture.map { removeGestureRecognizer($0) }
                panGesture.map { removeGestureRecognizer($0) }
            }
        }
    }
    
    private var isPinching = false
    private var pinchGesture: UIPinchGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer?
    private var doubleTapGestrue: UITapGestureRecognizer?
    private var originalCenter: CGPoint?
    
    private func setupGesture() {
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(sender:)))
        pinchGesture?.delegate = self
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
        panGesture?.delegate = self
        doubleTapGestrue = UITapGestureRecognizer(target: self, action: #selector(reset))
        doubleTapGestrue?.delegate = self
        doubleTapGestrue?.numberOfTapsRequired = 2
    }
    
    private func cellForTarget(superview: UIView?) -> UIView? {
        guard superview != nil else {
            return nil
        }
        if superview is UITableViewCell || superview is UICollectionViewCell {
            return superview
        } else {
            return cellForTarget(superview: superview?.superview)
        }
    }
    
    @objc private func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            isPinching = sender.scale > 1
            layer.zPosition = 1
            cellForTarget(superview: superview)?.layer.zPosition = 1
        case .changed:
            guard let view = sender.view, isPinching else { return }
            let center = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                 y: sender.location(in: view).y - view.bounds.midY)
            view.transform = view.transform
                .translatedBy(x: center.x, y: center.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -center.x, y: -center.y)
            sender.scale = 1
        case .ended, .cancelled, .failed:
            reset()
            break
        default:
            break
        }
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began where isPinching:
            originalCenter = sender.view?.center
        case .changed where isPinching:
            guard let view = sender.view else { return }
            let translation = sender.translation(in: self)
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
            sender.setTranslation(.zero, in: superview)
        default:
            break
        }
    }
    
    @objc private func reset() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = .identity
            self.center = self.originalCenter ?? self.center
        }) { _ in
            self.isPinching = false
            self.layer.zPosition = 1
            self.cellForTarget(superview: self.superview)?.layer.zPosition = 1
        }
    }
}

extension ISImageView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pinchGesture && otherGestureRecognizer.view is UIScrollView {
            return false
        }
        if gestureRecognizer == panGesture && otherGestureRecognizer.view is UIScrollView {
            return true
        }
        return true
    }
}
