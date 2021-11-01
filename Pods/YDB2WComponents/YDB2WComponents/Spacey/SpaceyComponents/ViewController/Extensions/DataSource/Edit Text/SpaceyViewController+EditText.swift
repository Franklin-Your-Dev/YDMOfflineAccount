//
//  SpaceyViewController+EditText.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 01/06/21.
//

import UIKit

import YDB2WModels
import YDUtilities

extension YDSpaceyViewController {
  func dequeueEditTextCell(
    with component: YDSpaceyComponentNPSQuestion,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyEditTextCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    cell.configure(with: component)
    cell.callback = { [weak self] answer in
      guard let self = self else { return }
      guard let component = self.viewModel?.componentsList
              .value.at(indexPath.row)?.component as? YDSpaceyComponentNPSQuestion,
            component.answerType == .textView
      else {
        return
      }

      (
        self.viewModel?.componentsList
          .value[indexPath.row].component as? YDSpaceyComponentNPSQuestion
      )?.storedValue = answer

      NotificationCenter.default.post(
        name: YDConstants.Notification.SpaceyNPSChangeValue,
        object: nil
      )
    }
    return cell
  }
}
