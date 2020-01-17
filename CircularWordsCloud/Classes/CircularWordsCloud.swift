//
//  CircularWordsCloud.swift
//  CircularWordsCloud
//
//  Created by 최민섭 on 2020/01/17.
//

import UIKit
import Foundation


public enum CircularWordsCloudPosition {
    case top, bottom, center
}

@available(iOS 9.0, *)
@objc public protocol CircularWorsCloudDelegate: NSObjectProtocol {
    // MARK:- Functions
    @objc optional func circularWordsCloud(_ circularWordsCloud: CircularWordsCloud,
                                           didSelectWord: String)
    
    @objc optional func circularWordsCloud(_ circularWordsCloud: CircularWordsCloud,
                                           didDeselectWord: String)
    
    @objc optional func circularWordsCloudDidExpand()
    
    @objc optional func circularWordsCloudDidCollapse()
    
    @objc optional func circularWordsCloud(_ circularWordsCloud: CircularWordsCloud,
                                           newAxisWord: String,
                                           depth: Int,
                                           completion: @escaping ( _ newCloudWords: [String])-> Void)
    
    // MARK:- Properties
    var wordForAxis: String { get }
    var wordsForCloud: [String] { get }
    @objc optional var ranksForWords: [Int] { get }
}

@available(iOS 9.0, *)
extension CircularWorsCloudDelegate {
    var keywordForAxis: Keyword {
        Keyword(text: wordForAxis)
    }
    var keywordsForCloud: [Keyword] {
        var keywords: [Keyword] = []
        for i in 0 ..< wordsForCloud.count {
            let rank = ranksForWords?.count ?? 0 > i ? ranksForWords![i] : 0
            keywords.append(Keyword(text: wordsForCloud[i],
                                    rank: rank))
        }
        return keywords
    }
}

@available(iOS 9.0, *)
public class CircularWordsCloud: UIView {
    
    // MARK:- Public Properties
    public var delegate: CircularWorsCloudDelegate! {
        didSet {
            keywordForAxis = Keyword(text: delegate.wordForAxis)
            var keywords: [Keyword] = []
            for i in 0 ..< delegate.wordsForCloud.count {
                let rank = delegate.ranksForWords?.count ?? 0 > i ? delegate.ranksForWords![i] : 0
                keywords.append(Keyword(text: delegate.wordsForCloud[i],
                                        rank: rank))
            }
            keywordsForCloud = keywords
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            let width = bounds.width
            let maxWidthOfLabel = width/4
            let radius = width*1/2 - maxWidthOfLabel*1/2
            self.maxWidthOfLabel = maxWidthOfLabel
            self.fontSize = maxWidthOfLabel/3
            self.radius = radius
            self.setupSubviews()
        }
    }
    
    public var enableLongPressGesture: Bool = false
    
    // MARK:- Private Properties
    fileprivate var fontSize: CGFloat = 0.0
    fileprivate var minFonSize: CGFloat {
        return fontSize * 0.5
    }
    fileprivate var maxFontSize: CGFloat {
        return fontSize * 1
    }
    
    fileprivate var maxWidthOfLabel: CGFloat = 0.0
    fileprivate var radius: CGFloat = 0.0
    
    fileprivate var axisLabel: UILabel = UILabel()
    fileprivate var cloudLabels: [UILabel] = []

    fileprivate var isCollapse = true
    fileprivate var isPossibleExplore: Bool = true
    
    fileprivate var keywordForAxis: Keyword!
    fileprivate var keywordsForCloud: [Keyword] = []
    
    fileprivate var position: CircularWordsCloudPosition!
    fileprivate var depth = 0
    fileprivate var selectedWords: [String] = []
    
    public func getSelectedWords() -> [String] {
        return selectedWords
    }
    
    public init(position: CircularWordsCloudPosition = .center) {
        super.init(frame: .zero)
        
        self.position = position
    }
    
    public override func didMoveToSuperview() {
        anchor(position: position)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
}

// MARK:- Actions
@available(iOS 9.0, *)
extension CircularWordsCloud {
    @objc fileprivate func longPressCloud(_ recognizer: UILongPressGestureRecognizer) {
        if !enableLongPressGesture { return }
        
        if recognizer.state == .ended || !isPossibleExplore { return }
        isPossibleExplore = false
        guard
            let label = recognizer.view as? UILabel,
            let text = label.text
            else { return }
        keywordForAxis = keywordsForCloud.filter { $0.text.elementsEqual(text) }.last!
        
        delegate.circularWordsCloud?(self,
                                     newAxisWord: keywordForAxis.text,
                                     depth: depth,
                                     completion: { [unowned self] (words: [String]) in
                                        self.keywordsForCloud = words.map { Keyword(text: $0) }
                                        self.collapsed {
                                            self.setupCloudLabels()
                                        }
        })
        
    }
    
    @objc fileprivate func tapAxis() {
        isCollapse ? expanded() : collapsed()
        isCollapse = !isCollapse
    }
    
    @objc fileprivate func tapCloud(_ recognizer: UITapGestureRecognizer) {
        guard
            let label = recognizer.view as? UILabel,
            let index = cloudLabels.firstIndex(of: label),
            let selectedText = label.text
            else { return }
        
        let isSelected = keywordsForCloud[index].isSelected
        label.bounce()
        label.changeAlphaWithAnimation(alpha: !isSelected ? 1 : 0.4)
        
        !isSelected ?
            selectKeyword(text: selectedText, index: index) :
            deSelectKeyword(text: selectedText, index: index)
    }
}

// MARK:- Animations
@available(iOS 9.0, *)
extension CircularWordsCloud {
    fileprivate func collapsed(completion: @escaping () -> Void = {} ) {
        updateAxisLabel()
        fadeInAxis()
        fadeOutCloud() {
            completion()
            self.updateCloudLabels()
            self.delegate.circularWordsCloudDidCollapse?()
            self.isPossibleExplore = true
        }
    }
    private func expanded() {
        self.delegate.circularWordsCloudDidExpand?()
        fadeOutAxis()
        fadeInCloud()
    }
    
    private func fadeOutAxis() {
        UIView.animate(withDuration: 0.7) {
            self.axisLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.axisLabel.alpha = 0.3
        }
    }
    private func fadeInAxis(completion: @escaping () -> Void = {}) {
        UIView.animate(withDuration: 0.7, animations: {
            self.axisLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.axisLabel.alpha = 1
        }, completion: { _ in
            completion()
        })
    }
    private func fadeOutCloud(completion: @escaping () -> Void) {
        let wholeDuration: Double = 0.7
        UIView.animateKeyframes(withDuration: wholeDuration, delay: 0, options: [.calculationModeCubic], animations: {
            for index in 0..<self.cloudLabels.count {
                let child = self.cloudLabels[index]
                let startTime = Double(index)/Double(self.cloudLabels.count)
                let duration = wholeDuration/Double(self.cloudLabels.count) * (1 - 0.1 * Double(index))
                UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: duration) {
                    child.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    child.alpha = 0
                }
            }
        }, completion: { res in
            completion()
        })
    }
    private func fadeInCloud() {
        let wholeDuration: Double = 1
        let bounceTime: Double = 0.1
        UIView.animateKeyframes(withDuration: wholeDuration+bounceTime, delay: 0, options: [.calculationModeCubic], animations: {
            for index in 0..<self.cloudLabels.count {
                let child = self.cloudLabels[index]
                let startTime = Double(index)/Double(self.cloudLabels.count)
                let duration = wholeDuration/Double(self.cloudLabels.count) * (1 - 0.1 * Double(index))
                UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: duration) {
                    child.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    //TODO
                    child.alpha = self.keywordsForCloud[index].isSelected ? 1 : 0.4
                }
                UIView.addKeyframe(withRelativeStartTime: startTime+duration, relativeDuration: bounceTime) {
                    child.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
        })
    }
    
    private func selectKeyword(text: String, index: Int) {
        selectedWords.append(text)
        keywordsForCloud[index].isSelected = true
        delegate.circularWordsCloud?(self, didSelectWord: keywordsForCloud[index].text)
    }
    
    private func deSelectKeyword(text: String, index: Int) {
        selectedWords = selectedWords.filter { !$0.elementsEqual(text) }
        keywordsForCloud[index].isSelected = false
        delegate.circularWordsCloud?(self, didSelectWord: keywordsForCloud[index].text)
    }
}

// MARK:- Update Datas
@available(iOS 9.0, *)
extension CircularWordsCloud {
    fileprivate func updateAxisLabel() {
        UIView.transition(with: self.axisLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [unowned self] in
                            self.axisLabel.text = self.keywordForAxis.text
        })
    }
    
    fileprivate func updateCloudLabels() {
        for i in 0 ..< cloudLabels.count {
            cloudLabels[i].text = keywordsForCloud[i].text
        }
        
        setAdjustedFontSizeForCloud()
    }
    
}

// MARK:- SetupLayout
@available(iOS 9.0, *)
extension CircularWordsCloud {
    fileprivate func setupSubviews() {
        setupLabels()
    }
    
    fileprivate func setupCloudGestures() {
        cloudLabels.forEach { label in
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(tapCloud)))
            label.addGestureRecognizer(UILongPressGestureRecognizer(target: self,
                                                                    action: #selector(longPressCloud)))
        }
    }
    
    fileprivate func setupAxisGestures() {
        axisLabel.isUserInteractionEnabled = true
        axisLabel.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(tapAxis)))
    }
    
    fileprivate func setupLabels() {
        addSubview(axisLabel)
        axisLabel.addShadowOnLabel()
        axisLabel.text = delegate.keywordForAxis.text
        axisLabel.font = axisLabel.font.withSize(fontSize)
        
        axisLabel.translatesAutoresizingMaskIntoConstraints = false
        axisLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        axisLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        axisLabel.widthAnchor.constraint(equalToConstant: maxWidthOfLabel).isActive = true
        axisLabel.heightAnchor.constraint(equalToConstant: fontSize*2).isActive = true
        axisLabel.lineBreakMode = .byClipping
        axisLabel.numberOfLines = 0
        axisLabel.adjustsFontSizeToFitWidth = true
        
        setupAxisGestures()
        setupCloudLabels()
    }
    
    fileprivate func setupCloudLabels() {
        subviews.filter { !$0.isEqual(axisLabel) }.map { $0.removeFromSuperview() }
        cloudLabels = []
        
        for i in 0 ..< keywordsForCloud.count {
            let label = UILabel()
            cloudLabels.append(label)
            addSubview(label)
            label.addShadowOnLabel()
            label.text = keywordsForCloud[i].text
            label.font = label.font.withSize(minFonSize)
            label.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        
        self.radius = (radius * 0.6) * CGFloat(1 + CGFloat(cloudLabels.count) * 0.1)
        
        let startTheta = Float.pi / 2
        let thetaStatus = 2 * Float.pi / Float(cloudLabels.count)
        for i in 0..<cloudLabels.count {
            let label = cloudLabels[i]
            let theta = (startTheta + thetaStatus * Float(i+1)).truncatingRemainder(dividingBy: 2 * Float.pi)
                    
            let x = radius * CGFloat(cos(theta))
            let y = radius * CGFloat(sin(theta))
            label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: x).isActive = true
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: y).isActive = true
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalToConstant: maxWidthOfLabel).isActive = true
            //Adjust Font Size with LabelSize
            label.heightAnchor.constraint(equalToConstant: fontSize*2).isActive = true
            label.lineBreakMode = .byClipping
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
        }
        
        setupCloudGestures()
        setAdjustedFontSizeForCloud()
    }
    
    private func setAdjustedFontSizeForCloud() {
        let gap = (maxFontSize - minFonSize) / CGFloat(cloudLabels.count)
        for i in 0..<cloudLabels.count {
            let childLabel = cloudLabels[i]
            let rank = cloudLabels.count - keywordsForCloud[i].rank
            childLabel.font = childLabel.font.withSize(minFonSize + gap * CGFloat(rank))
        }
    }
}
