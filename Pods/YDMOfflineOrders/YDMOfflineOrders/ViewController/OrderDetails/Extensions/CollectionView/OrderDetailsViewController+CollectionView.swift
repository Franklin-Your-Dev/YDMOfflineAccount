//
//  OrderDetailsViewController+CollectionView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import UIKit
import YDExtensions
import YDB2WColors

// MARK: DataSource
extension OrderDetailsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel?.order.value.products?.count ?? 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OrderDetailsCollectionViewCell.identifier,
            for: indexPath
    ) as? OrderDetailsCollectionViewCell,
    let product = viewModel?.order.value.products?.at(indexPath.row)
    else {
      fatalError("dequeue cell OrderDetailsCollectionViewCell")
    }

    cell.config(with: product)
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard let header = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: OrdersCollectionFooterReusableView.identifier,
          for: indexPath
        ) as? OrdersCollectionFooterReusableView
        else {
          fatalError("viewForSupplementaryElementOfKind: OrdersCollectionFooterReusableView")
        }
        
        let label = UILabel()
        header.addSubview(label)
        label.textColor = YDColors.Gray.light
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13)
        label.text = "qtd"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
          label.bottomAnchor.constraint(equalTo: header.bottomAnchor),
          label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 26)
        ])

        return header

      case UICollectionView.elementKindSectionFooter:
        guard let footer = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionFooter,
          withReuseIdentifier: OrdersCollectionFooterReusableView.identifier,
          for: indexPath
        ) as? OrdersCollectionFooterReusableView
        else {
          fatalError("viewForSupplementaryElementOfKind: OrdersCollectionFooterReusableView")
        }

        return footer

      default:
        fatalError("viewForSupplementaryElementOfKind")
    }
  }
}

// MARK: Delegate
extension OrderDetailsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let product = viewModel?.order.value.products?.at(indexPath.row) else { return }

    viewModel?.openDetailsForProduct(product)
  }
}
