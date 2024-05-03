//
//  FloatingBtn.swift
//  cheq
//
//  Created by Isaac Jang on 5/3/24.
//

import Foundation
import UIKit
import Lottie

class FloatingBtn {
    private var parent : JVC
    init(jvc parent: JVC) {
        self.parent = parent
    }
    
    public struct FloatingChildModel {
        var indexId: Int
        var iconName: String
        var clickEvent: ()->Void
    }
    
    private var childList : [FloatingChildModel] = []
    
    public func addChild(list: [FloatingChildModel]) {
        if isAddedViews {
            return
        }
        
        for item in list {
            addChild(item: item)
        }
    }
    
    public func addChild(item: FloatingChildModel) {
        if isAddedViews {
            return
        }
        childList.append(item)
    }
    
    public func clearChild() {
        if isAddedViews {
            ftBtnList.forEach { v in
                v.removeFromSuperview()
            }
            floatingMenuBtn.removeFromSuperview()
            lottieView.removeFromSuperview()
            menuActiveBackground.removeFromSuperview()
            ftBtnList.removeAll()
            ftBtnConstraintList.removeAll()
            isAddedViews = false
        }
        childList.removeAll()
    }
    
    
    @MainActor public func build() {
        if childList.count < 1 {
            DLog.p("return count")
            return
        }
        
        drawFloatingBtn()
    }
    
    private let floatingButtonSize = CGSize(width: 60, height: 60)
    private let floatingButtonPadding : CGFloat = 10
    private let floatingMargin : CGFloat = 30
    private let floatingSpacing : CGFloat = 10
    private let floatingAnimationTime : CGFloat = 0.3
    
    private let floatingMenuBtn = UIView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .gray
        v.cornerRadius = 30
        v.isUserInteractionEnabled = true
        v.clipsToBounds = false
        v.setShadow = true
    }
    
    private let lottieView : LottieAnimationView = {
        let animView = LottieAnimationView(name:"menu")
        animView.translatesAutoresizingMaskIntoConstraints = false
        animView.contentMode = .scaleAspectFill
        animView.isUserInteractionEnabled = false
        animView.animationSpeed = 3
        return animView
    }()
    
    private let menuActiveBackground = UIView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.isHidden = true
        v.alpha = 0
        v.isUserInteractionEnabled = true
    }
    
    private lazy var ftBtnList : [UIView] = []
    private lazy var ftBtnConstraintList : [NSLayoutConstraint] = []
    
    
    private func getFloatingButtonView(named: String) -> UIView {
        let v = UIView().then { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .gray
            v.clipsToBounds = true
            v.cornerRadius = 30
            v.isUserInteractionEnabled = true
            v.layer.shadowColor = UIColor.black.cgColor
            v.layer.shadowOpacity = 1
            v.isHidden = true
        }
    
        v.setShadow = true
        
        let subView = getIconImageView(named: named)
        v.addSubview(subView)
        
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: v.topAnchor, constant: floatingButtonPadding),
            subView.leftAnchor.constraint(equalTo: v.leftAnchor, constant: floatingButtonPadding),
            subView.rightAnchor.constraint(equalTo: v.rightAnchor, constant: (floatingButtonPadding * -1)),
            subView.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: (floatingButtonPadding * -1)),
            
            v.widthAnchor.constraint(equalToConstant: floatingButtonSize.width),
            v.heightAnchor.constraint(equalToConstant: floatingButtonSize.height),
        ])
        return v
    }

    private func getIconImageView(named: String) -> UIImageView {
        return UIImageView(image: UIImage(named: named)).then { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            v.contentMode = .scaleAspectFit
            v.tintColor = .black
        }
    }
    
    private var isAddedViews = false
    private var isActiveFloating = false
    
    @objc private func onClickFloatingChild(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            DLog.p("tag is nil")
            return
        }
        if tag >= childList.count {
            DLog.p("tag is too high : \(tag)")
            return
        }
        
        childList[tag].clickEvent()
    }
    
    @MainActor
    private func drawFloatingBtn() {
        if isAddedViews {
            DLog.p("isAddedViews")
            return
        }
        
        isAddedViews = true
        
        childList = childList.sorted { prev, next in
            prev.indexId < next.indexId
        }
        for i in 0 ..< childList.count {
            let v = getFloatingButtonView(named: childList[i].iconName)
            ftBtnList.append(v)
            v.tag = i
            v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFloatingChild)))
        }
        
        
        DLog.p("childList : \(childList.count)")
        DLog.p("ftBtnList : \(ftBtnList.count)")
        if ftBtnList.count < 1 {
            isAddedViews = false
            return
        }
        
        if ftBtnList.count == 1 {
            DLog.p(childList.first?.iconName)
            addSingleBtn(btn: ftBtnList.first!)
            return
        }
        
        addMenuBtn()
    }
    
    private func addMenuBtn() {
        DLog.p("addMenuBtn")
        parent.view.addSubview(menuActiveBackground)

        
        for btnView in ftBtnList {
            parent.view.addSubview(btnView)
        }
        
        parent.view.addSubview(floatingMenuBtn)
        floatingMenuBtn.addSubview(lottieView)
        
        NSLayoutConstraint.activate([
            menuActiveBackground.topAnchor.constraint(equalTo: parent.view.topAnchor),
            menuActiveBackground.leftAnchor.constraint(equalTo: parent.view.leftAnchor),
            menuActiveBackground.rightAnchor.constraint(equalTo: parent.view.rightAnchor),
            menuActiveBackground.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor),
            
            floatingMenuBtn.widthAnchor.constraint(equalToConstant: floatingButtonSize.width),
            floatingMenuBtn.heightAnchor.constraint(equalToConstant: floatingButtonSize.height),
            floatingMenuBtn.bottomAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.bottomAnchor, constant: (floatingMargin * -1)),
            floatingMenuBtn.rightAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.rightAnchor, constant: (floatingMargin * -1)),
            
            lottieView.topAnchor.constraint(equalTo: floatingMenuBtn.topAnchor, constant: floatingButtonPadding),
            lottieView.rightAnchor.constraint(equalTo: floatingMenuBtn.rightAnchor, constant: (floatingButtonPadding * -1)),
            lottieView.leftAnchor.constraint(equalTo: floatingMenuBtn.leftAnchor, constant: floatingButtonPadding),
            lottieView.bottomAnchor.constraint(equalTo: floatingMenuBtn.bottomAnchor, constant: (floatingButtonPadding * -1)),
        ])
        
        for ftBtn in ftBtnList {
            let constriant = ftBtn.bottomAnchor.constraint(equalTo: floatingMenuBtn.bottomAnchor, constant: (floatingMargin * -1))
            ftBtnConstraintList.append(constriant)
            
            NSLayoutConstraint.activate([
                constriant,
                ftBtn.rightAnchor.constraint(equalTo: parent.view.rightAnchor, constant: (floatingMargin * -1))
            ])
        }
        
        floatingMenuBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFloating)))
        menuActiveBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFloating)))
    }
    
    private func addSingleBtn(btn: UIView) {
        DLog.p("addSingleBtn")
        btn.isHidden = false
        btn.alpha = 1
        parent.view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.widthAnchor.constraint(equalToConstant: floatingButtonSize.width),
            btn.heightAnchor.constraint(equalToConstant: floatingButtonSize.height),
            btn.bottomAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.bottomAnchor, constant: (floatingMargin * -1)),
            btn.rightAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.rightAnchor, constant: (floatingMargin * -1)),
        ])
    }
    
    
    @MainActor
    @objc private func onClickFloating() {
        floatingActive(setActive: !isActiveFloating)
    }
    
    @objc func floatingActive(setActive : Bool) {
        if childList.count < 2 {
            return
        }
        
        if setActive {
            menuActiveBackground.alpha = 0
            menuActiveBackground.isHidden = false
            
            for v in self.ftBtnList {
                v.isHidden = false
            }
            
            UIView.animate(withDuration: floatingAnimationTime, delay: 0, options: .curveEaseInOut, animations: {
                self.menuActiveBackground.alpha = 0.3
                
                for i in 0 ..< self.ftBtnConstraintList.count {
                    let c = self.ftBtnConstraintList[i]
                    let index : CGFloat = CGFloat(i) + CGFloat(1)
                    c.constant = ((self.floatingSpacing * index) + (self.floatingButtonSize.height * index)) * -1
                }
                self.parent.view.layoutIfNeeded()
            })
            lottieView.play(fromProgress: 0, toProgress: 0.5)
        } else {
            UIView.animate(withDuration: floatingAnimationTime, delay: 0, options: .curveEaseInOut, animations: {
                self.menuActiveBackground.alpha = 0
                for c in self.ftBtnConstraintList {
                    c.constant = (self.floatingMargin * -1)
                }
                self.parent.view.layoutIfNeeded()
            }, completion: { Bool in
                for v in self.ftBtnList {
                    v.isHidden = true
                }
            })
            lottieView.play(fromProgress: 0.5, toProgress: 1) {completed in
                self.menuActiveBackground.isHidden = true
            }
        }
        
        
        isActiveFloating = setActive
    }
}
