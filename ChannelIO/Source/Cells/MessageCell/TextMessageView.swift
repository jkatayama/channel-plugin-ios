//
//  TextMessageView.swft
//  CHPlugin
//
//  Created by 이수완 on 2017. 3. 20..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import SnapKit

class TextMessageView : BaseView {

  //MARK: Constant

  struct Metric {
    static let topBottomPadding = 10.f
    static let leftRightPadding = 12.f
    static let actionLabelTopMargin = 10.f
    static let actionLabelTopBottomPadding = 10.f
  }

  struct Constant {
    static let cornerRadius = 12.f
    static let singleCornerRadius = 2.f
    static let actionViewBottomRadius = 12.f
    static let borderWidth: CGFloat = 1
  }

  struct Font {
    static let actionLabel = UIFont.boldSystemFont(ofSize: 13)
    static let messageView = UIFont.systemFont(ofSize: 15)
  }

  struct Color {
    static let actionLabel = CHColors.blueyGrey
    static let message = UIColor.black
  }

  //MARK: Properties

  let messageView = UITextView().then {
    $0.font = Font.messageView
    $0.textAlignment = NSTextAlignment.left
    $0.backgroundColor = UIColor.clear
    $0.isScrollEnabled = false
    $0.isEditable = false
    $0.isSelectable = true
    $0.dataDetectorTypes = UIDataDetectorTypes.link
    $0.textContainer.lineFragmentPadding = 0
    $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
  }

  var viewModel: MessageCellModelType?
  var corners: UIRectCorner = [.allCorners]
  
  //MARK: init

  override func initialize() {
    super.initialize()
    self.messageView.delegate = self
    
    self.layer.cornerRadius = Constant.singleCornerRadius
    self.addSubview(self.messageView)
  }
  
  override func setLayouts() {
    super.setLayouts()

    self.messageView.snp.makeConstraints({ (make) in
      make.leading.equalToSuperview().inset(Metric.leftRightPadding)
      make.top.equalToSuperview().inset(Metric.topBottomPadding)
      make.trailing.equalToSuperview().inset(Metric.leftRightPadding)
      make.bottom.equalToSuperview().inset(Metric.topBottomPadding)
    })
  }
  
  func configure(_ viewModel: MessageCellModelType, text: String) {
    self.backgroundColor = viewModel.pluginColor
    self.corners =  [.topLeft, .bottomRight, .bottomLeft]
    
    self.messageView.text = text
    self.messageView.textColor = viewModel.textColor
    self.messageView.linkTextAttributes = [
      NSAttributedStringKey.foregroundColor.rawValue: viewModel.textColor,
      NSAttributedStringKey.underlineStyle.rawValue: 1]
  }
  
  func configure(_ viewModel: MessageCellModelType) {
    if viewModel.isContinuous == true {
      self.corners = [.allCorners]
    } else if viewModel.createdByMe == true {
      self.corners = [.topLeft, .bottomRight, .bottomLeft]
    } else {
      self.corners = [.topRight, .bottomRight, .bottomLeft]
    }
    
    self.backgroundColor = viewModel.bubbleBackgroundColor
    self.isHidden = viewModel.message.isEmpty()
    
    if let attributedText = viewModel.message.messageV2 {
      self.messageView.attributedText = attributedText
    } else {
      self.messageView.text = viewModel.message.message
    }
    
    self.messageView.textColor = viewModel.createdByMe ? viewModel.textColor : Color.message
    //self.messageView.tintColor = viewModel.createdByMe ? viewModel.textColor : UIColor.blue
    let linkColor = viewModel.createdByMe ? viewModel.textColor : CHColors.cobalt
    self.messageView.linkTextAttributes = [
      NSAttributedStringKey.foregroundColor.rawValue: linkColor,
      NSAttributedStringKey.underlineStyle.rawValue: 1]
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    self.roundCorners(corners: self.corners, radius: Constant.cornerRadius)
  }
  
  //MARK: layout
  class func viewHeight(fits width: CGFloat, viewModel: MessageCellModelType) -> CGFloat {
    var viewHeight: CGFloat = 0.0

    if let message = viewModel.message.messageV2 {
      //let extraPadding: CGFloat = message.string.guessLanguage() == "日本語" ? 40 : 0
      var range = NSRange(location:0, length: message.string.count)
      viewHeight += message.string.height(
        fits: width - Metric.leftRightPadding * 2,
        attributes:  message.attributes(at: 0, effectiveRange: &range))
      viewHeight += Metric.topBottomPadding * 2
    }

    return viewHeight
  }
  
  class func viewHeight(fits width: CGFloat, text: String) -> CGFloat {
    var viewHeight: CGFloat = 0.f
    viewHeight += text.height(
      fits: width - Metric.leftRightPadding * 2,
      font: UIFont.systemFont(ofSize: 15))
    viewHeight += Metric.topBottomPadding * 2
    
    return viewHeight
  }
}

extension TextMessageView : UITextViewDelegate {
  func textView(_ textView: UITextView,
                shouldInteractWith URL: URL,
                in characterRange: NSRange) -> Bool {
    let shouldhandle = ChannelIO.delegate?.onClickChatLink?(url: URL)
    return shouldhandle == true || shouldhandle == nil
  }
  
  @available(iOS 10.0, *)
  func textView(_ textView: UITextView,
                shouldInteractWith URL: URL,
                in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    let shouldhandle = ChannelIO.delegate?.onClickChatLink?(url: URL)
    if shouldhandle == true || shouldhandle == nil {
      URL.openWithUniversal()
    }
    
    return false
  }

}
