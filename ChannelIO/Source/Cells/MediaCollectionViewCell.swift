//
//  MediaCollectionViewCell.swift
//  ChannelIO
//
//  Created by Jam on 2019/12/16.
//

import RxSwift
import SDWebImage
import UIKit

class MediaCollectionViewCell: BaseCollectionViewCell {
  let imageView = SDAnimatedImageView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 6.f
    $0.layer.borderColor = UIColor.grey300.cgColor
    $0.layer.borderWidth = 1
    $0.backgroundColor = .darkGray
    $0.contentMode = .scaleAspectFill
    $0.sd_imageIndicator = SDWebImageActivityIndicator.white
  }

  let videoView = VideoPlayerView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 6.f
    $0.layer.borderColor = UIColor.grey300.cgColor
    $0.layer.borderWidth = 1
    $0.isHidden = true
  }

  private var disposeBag = DisposeBag()
  private var model: FileCellModel?

  override func initialize() {
    super.initialize()

    self.contentView.addSubview(self.imageView)
    self.contentView.addSubview(self.videoView)

    self.videoView.delegate = self
  }

  override func setLayouts() {
    super.setLayouts()

    self.imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.videoView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.videoView.prepareForReuse()
  }

  func configure(with model: FileCellModel) {
    guard model.type == .image || model.type == .video else {
      return
    }
    
    self.model = model
    self.imageView.isHidden = model.type == .video
    self.videoView.isHidden = model.type != .video
    self.videoView.observeNotificationIfNeeded(model: model)

    switch model.type {
    case .image:
      self.imageView.sd_setImage(with: model.thumbUrl) { _, error, _, _ in
        if let error = error {
        }
      }
    case .video:
      self.videoView.configure(with: model)
    default:
      break
    }
  }
}

extension MediaCollectionViewCell: VideoPlayerDelegate {
  func didFinish() {
    if let model = self.model {
      self.videoView.configure(with: model)
    }
  }
}
