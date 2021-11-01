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
  func dequeueGradeCell(
    with component: YDSpaceyComponentNPSQuestion,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyGradeListCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    cell.configure(with: component)
    cell.callback = { [weak self] grades in
      guard let self = self else { return }
      guard let component = self.viewModel?.componentsList
              .value.at(indexPath.row)?.component as? YDSpaceyComponentNPSQuestion,
            component.answerType == .grade
      else {
        return
      }

      if let component = self.viewModel?.componentsList
          .value[indexPath.row].component as? YDSpaceyComponentNPSQuestion {
        component.childrenAnswers = grades

        component.storedValue = grades.first(where: { $0.selected })?.answerText

        NotificationCenter.default.post(
          name: YDConstants.Notification.SpaceyNPSChangeValue,
          object: nil
        )
      }
    }
    return cell
  }
}
