//
//  SpaceyViewController+NextLive.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 17/08/21.
//

import UIKit
import YDB2WModels
import YDUtilities

extension YDSpaceyViewController {
  func dequeueNextLiveCell(
    with component: YDSpaceyComponentNextLiveStruct,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let firstNextLive = component.children.first?.get() as? YDSpaceyComponentNextLive
    else {
      fatalError("No nextLive")
    }
    
    if component.title != nil || component.buttonTitle != nil {
      let cell: SpaceyNextLiveWithTitleAndButtonCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.configure(
        with: firstNextLive,
        withTitle: component.title,
        withButtonTitle: component.buttonTitle
      )
      
      cell.buttonCallback = { [weak self] _ in
        guard let self = self else { return }
        self.viewModel?.openNextLives()
      }
      
      cell.scheduleButtonCallback = { [weak self] in
        guard let self = self else { return }
        self.viewModel?.saveNextLiveOnCalendar(live: firstNextLive) { success in
          guard success else { return }
          
          DispatchQueue.main.async {
            firstNextLive.alreadyScheduled = true
            cell.configure(
              with: firstNextLive,
              withTitle: component.title,
              withButtonTitle: component.buttonTitle
            )
          }
        }
      }
      return cell
    }
    
    let cell: SpaceyNextLiveCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    cell.configure(with: firstNextLive)
    
    cell.scheduleButtonCallback = { [weak self] in
      guard let self = self else { return }
      self.viewModel?.saveNextLiveOnCalendar(live: firstNextLive) { success in
        guard success else { return }
        
        DispatchQueue.main.async {
          firstNextLive.alreadyScheduled = true
          cell.configure(with: firstNextLive)
        }
      }
    }
    
    return cell
  }
}
