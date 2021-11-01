//
//  StoreAndProductView+TableView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 26/03/21.
//

import UIKit

import YDExtensions

extension YDStoreAndProductView: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return product?.getTechnicalInformation().count ?? 0
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StoreAndProductTableViewCell.identifier,
            for: indexPath) as? StoreAndProductTableViewCell,
          let attribute = product?.getTechnicalInformation().at(indexPath.row)
    else {
      fatalError("dequeue StoreAndProductTableViewCell")
    }

    cell.config(with: attribute)

    if indexPath.row == 0 {
      cell.separatorView.isHidden = true
    }

    return cell
  }
}
