//
//  SpaceyViewController+Star.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import YDB2WModels
import YDUtilities

extension YDSpaceyViewController {
  func dequeueStarCell(
    with component: YDSpaceyComponentNPSQuestion,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyStarCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    cell.configure(with: component)
    cell.callback = { [weak self] starNumber in
      guard let self = self else { return }
      guard let component = self.viewModel?.componentsList
              .value.at(indexPath.row)?.component as? YDSpaceyComponentNPSQuestion,
            component.answerType == .star
      else {
        return
      }

      (
        self.viewModel?.componentsList
          .value[indexPath.row].component as? YDSpaceyComponentNPSQuestion
      )?.storedValue = starNumber

      NotificationCenter.default.post(
        name: YDConstants.Notification.SpaceyNPSChangeValue,
        object: nil
      )
    }
    return cell
  }
}
