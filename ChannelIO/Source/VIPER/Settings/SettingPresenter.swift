//
//  SettingPresenter.swift
//  ChannelIO
//
//  Created by Haeun Chung on 23/04/2019.
//  Copyright © 2019 ZOYI. All rights reserved.
//

import Foundation
import RxSwift

class SettingPresenter: NSObject, SettingPresenterProtocol {
  weak var view: SettingViewProtocol?
  var interactor: SettingInteractorProtocol?
  var router: SettingRouterProtocol?
  
  var schemas: [CHProfileSchema] = []
  
  var disposeBag = DisposeBag()
  
  func viewDidLoad() {
    if let version = Bundle(for: ChannelIO.self)
      .infoDictionary?["CFBundleShortVersionString"] as? String {
      self.view?.displayVersion(version: "v\(version)")
    }
    
    self.interactor?.updateGeneral()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] (channel, plugin) in
        let headerModel = SettingHeaderViewModel(channel: channel, plugin: plugin)
        self?.view?.displayHeader(with: headerModel)
      }).disposed(by: self.disposeBag)
    
    self.interactor?.updateOptions()
      .debounce(1, scheduler: MainScheduler.instance)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] (_) in
        let settingOptions = SettingOptionModel.generate(
          options: [.language, .closeChatVisibility, .translation])
        self?.view?.displayOptions(with: settingOptions)
      }).disposed(by: self.disposeBag)
    
    self.interactor?.updateGuest()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] (guest) in
        let profiles = mainStore.state.guest.profile
        let models = GuestProfileItemModel.generate(
          from: profiles,
          schemas: self?.schemas ?? []
        )
        self?.view?.displayProfiles(with: models)
      }).disposed(by: self.disposeBag)
    
    self.interactor?.getProfileSchemas()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] (schemas) in
        let profiles = mainStore.state.guest.profile
        let models = GuestProfileItemModel.generate(
          from: profiles,
          schemas: schemas
        )
        self?.schemas = schemas
        self?.view?.displayProfiles(with: models)
      }, onError: { (error) in
          
      }).disposed(by: self.disposeBag)
  }
  
  func prepare() {
    let settingOptions = SettingOptionModel.generate(options: [.language, .closeChatVisibility, .translation])
    self.view?.displayOptions(with: settingOptions)

    self.interactor?.subscribeDataSource()
  }
  
  func cleanup() {
    self.interactor?.unsubscribeDataSource()
  }
  
  func didClickOnOption(item: SettingOptionModel, nextValue: Any?, from view: UIViewController?) {
    if item.type == .language {
      self.router?.pushLanguageSelector(from: view)
    }
    else if item.type == .translation, let nextValue = nextValue as? Bool {
      mainStore.dispatch(UpdateVisibilityOfTranslation(show: nextValue))
    }
    else if item.type == .closeChatVisibility, let nextValue = nextValue as? Bool {
      mainStore.dispatch(UpdateVisibilityOfCompletedChats(show: nextValue))
    }
  }
  
  func didClickOnProfileSchema(with item: GuestProfileItemModel, from view: UIViewController?) {
    self.router?.pushProfileSchemaEditor(with: item, from: view)
  }
}
