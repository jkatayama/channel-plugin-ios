//
//  WatermarkView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 08/01/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit

class WatermarkView : BaseView {
  let contentView = UIView()
  let brandImageview = UIImageView().then {
    $0.image = CHAssets.getImage(named: "chSymbol")
    $0.contentMode = .scaleToFill
  }
  
  let descLabel = UILabel().then {
    let attributes = [
      NSAttributedStringKey.foregroundColor: CHColors.blueyGrey,
      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11)
    ]
    
    let tagAttributes = [StringTagType.bold:[
      NSAttributedStringKey.foregroundColor: CHColors.blueyGrey,
      NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 11)
    ]]
    
    $0.attributedText = CHAssets.localized(
      "ch.watermark",
      attributes: attributes,
      tags: [.bold],
      tagAttributes: tagAttributes)
  }
  
  override func initialize() {
    super.initialize()
    self.backgroundColor = UIColor.clear
    self.contentView.backgroundColor = UIColor.clear
    
    self.contentView.addSubview(self.brandImageview)
    self.contentView.addSubview(self.descLabel)
    self.addSubview(self.contentView)
  }
  
  override func setLayouts() {
    super.setLayouts()
        
    self.contentView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    self.brandImageview.snp.makeConstraints { (make) in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    self.descLabel.snp.makeConstraints { [weak self] (make) in
      make.leading.equalTo((self?.brandImageview.snp.trailing)!).offset(5)
      make.trailing.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
  
}
