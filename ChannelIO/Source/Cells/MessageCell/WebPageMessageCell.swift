//
//  WebPageMessageCell.swift
//  CHPlugin
//
//  Created by Haeun Chung on 26/03/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

class WebPageMessageCell: MessageCell {
  let webView = WebPageMessageView()
  
  var topConstraint: Constraint? = nil
  var topToTextConstraint: Constraint? = nil
  
  var rightConstraint: Constraint? = nil
  var leftConstraint: Constraint? = nil
  
  override func initialize() {
    super.initialize()
    self.contentView.addSubview(self.webView)
  }
  
  override func setLayouts() {
    super.setLayouts()
    self.webView.snp.makeConstraints { [weak self] (make) in
      make.top.equalTo((self?.textMessageView.snp.bottom)!).offset(3)
      self?.rightConstraint = make.right.equalToSuperview().inset(Metric.cellRightPadding).constraint
      self?.leftConstraint = make.left.equalToSuperview().inset(Metric.messageCellMinMargin).constraint
    }
    
    self.resendButtonView.snp.remakeConstraints { [weak self] (make) in
      make.size.equalTo(CGSize(width: 40, height: 40))
      make.bottom.equalTo((self?.webView.snp.bottom)!)
      make.right.equalTo((self?.webView.snp.left)!).inset(4)
    }
  }
  
  override func configure(_ viewModel: MessageCellModelType, presenter: ChatManager? = nil) {
    super.configure(viewModel, presenter: presenter)
    self.webView.configure(message: viewModel)
    
    if viewModel.createdByMe == true {
      self.rightConstraint?.update(inset: Metric.cellRightPadding)
      self.leftConstraint?.update(inset: Metric.messageCellMinMargin)
    } else {
      self.rightConstraint?.update(inset: Metric.messageCellMinMargin)
      self.leftConstraint?.update(inset: Metric.bubbleLeftMargin)
    }
  }
  
  override class func cellHeight(fits width: CGFloat, viewModel: MessageCellModelType) -> CGFloat {
    var height = super.cellHeight(fits: width, viewModel: viewModel)
    height += 3
    height += WebPageMessageView.viewHeight(fits: width, webpage: viewModel.message.webPage)
    return height
  }
}
