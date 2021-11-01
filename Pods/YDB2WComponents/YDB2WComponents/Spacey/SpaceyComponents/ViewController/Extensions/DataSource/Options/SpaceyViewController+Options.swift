//
//  SpaceyViewController+Options.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import YDB2WModels
import YDUtilities

extension YDSpaceyViewController {
  func dequeueOptionsCell(
    with component: YDSpaceyComponentNPSQuestion,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyOptionsListCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    cell.configure(with: component)
    cell.callback = { [weak self] options in
      guard let self = self else { return }
      guard let component = self.viewModel?.componentsList
              .value.at(indexPath.row)?.component as? YDSpaceyComponentNPSQuestion,
            component.answerType == .option
      else {
        return
      }

      if let component = self.viewModel?.componentsList
          .value[indexPath.row].component as? YDSpaceyComponentNPSQuestion {
        component.childrenAnswers = options

        component.storedValue = options.first(where: { $0.selected })?.answerText

        NotificationCenter.default.post(
          name: YDConstants.Notification.SpaceyNPSChangeValue,
          object: nil
        )
      }
    }
    return cell
  }
}
