//
//  UserDataViewController+TableView.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 25/01/21.
//

import UIKit

import YDB2WModels

// MARK: Actions
extension UserDataViewController {
  func dequeueCellConstructor(
    at indexPath: IndexPath,
    withData data: YDLasaClientDataSet
  ) -> UITableViewCell {
    switch data.type {
      case .info:
        return dequeueUsersInfoCell(at: indexPath, withData: data)

      case .separator:
        return dequeueSeparatorCell(at: indexPath)

      case .marketing:
        return dequeueMarketingSwitchCell(at: indexPath)

      case .termsAndSave:
        return dequeueTermsSwitchCell(at: indexPath)
    }
  }

  func dequeueSeparatorCell(at indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserDataSeparatorTableViewCell.identifier,
            for: indexPath) as? UserDataSeparatorTableViewCell else {
      return UITableViewCell()
    }
    return cell
  }

  func dequeueUsersInfoCell(
    at indexPath: IndexPath,
    withData data: YDLasaClientDataSet
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserDataInfoTableViewCell.identifier,
            for: indexPath) as? UserDataInfoTableViewCell else {
      return UITableViewCell()
    }

    cell.config(with: data)
    return cell
  }

  func dequeueMarketingSwitchCell(
    at indexPath: IndexPath
  ) -> UITableViewCell {
    guard let viewModel = viewModel,
          let userInfo = viewModel.userData,
          let cell = tableView.dequeueReusableCell(
            withIdentifier: UserDataMarketingTableViewCell.identifier,
            for: indexPath) as? UserDataMarketingTableViewCell
    else {
      return UITableViewCell()
    }

    cell.config(withValue: userInfo.marketing) { value in
      //
      viewModel.userData?.marketing = value
    }
    return cell
  }

  func dequeueTermsSwitchCell(at indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = viewModel,
          let userInfo = viewModel.userData,
          let cell = tableView.dequeueReusableCell(
            withIdentifier: UserDataTermsAndButtonTableViewCell.identifier,
            for: indexPath) as? UserDataTermsAndButtonTableViewCell
    else {
      return UITableViewCell()
    }

    cell.config(
      withValue: userInfo.terms,
      onTerms: {
        viewModel.openTerms()
      },
      onSave: { value in
        viewModel.userData?.terms = value
        viewModel.updateInfo()
      }
    )
    return cell
  }
}

// MARK: TableView Data Source
extension UserDataViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.usersInfo.value.count ?? 0
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let data = viewModel?[indexPath.row] else {
      return UITableViewCell()
    }

    return dequeueCellConstructor(at: indexPath, withData: data)
  }
}

// MARK: TableView Delegate
extension UserDataViewController: UITableViewDelegate {}
