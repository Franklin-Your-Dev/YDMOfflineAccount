//
//  SpaceyViewController+DataSource.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import UIKit

import YDB2WModels
import YDExtensions

// MARK: Data Source
extension YDSpaceyViewController: UICollectionViewDataSource {
  // How many items
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel?.componentsList.value.count ?? 0
  }

  // Dequeue Cell
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    return dequeueCell(at: indexPath)
  }

  // Header & Footer
  public func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
      case UICollectionView.elementKindSectionHeader:
        let headerView = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: EmptyCollectionReusableView.identifier,
          for: indexPath
        )
        return headerView

      case UICollectionView.elementKindSectionFooter:
        let footerView = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: EmptyCollectionReusableView.identifier,
          for: indexPath
        )
        return footerView

      default:
        fatalError("Header Section")
    }
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    didEndDisplaying cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    switch cell {
      case is SpaceyBannerCarrouselCollectionViewCell:
        guard let cell = cell as? SpaceyBannerCarrouselCollectionViewCell else { return }
        didEndDisplayBannerCarrouselCell(cell, forItemAt: indexPath)
        
      case is SpaceyProductCarrouselCollectionViewCell:
        guard let cell = cell as? SpaceyProductCarrouselCollectionViewCell else { return }
        didEndDisplayProductCarrouselCell(cell, forItemAt: indexPath)
        
      default: break
    }
  }
}

// MARK: Actions
extension YDSpaceyViewController {
  private func dequeueCell(at indexPath: IndexPath) -> UICollectionViewCell {
    guard let itemAndType = viewModel?.getComponentAndType(at: indexPath),
          let component = itemAndType.component,
          let type = itemAndType.type
    else {
      return UICollectionViewCell()
    }

    if case .bannerCarrousel = type,
       let bannerCarrousel = component as? YDSpaceyComponentCarrouselBanner {
      return dequeueBannerCarrouselCell(
        withCarrousel: bannerCarrousel,
        at: indexPath
      )
    }
    
    if case .productCarrousel = type,
       let productCarrousel = component as? YDSpaceyComponentCarrouselProduct {
      return dequeueProductCarrouselCell(withCarroulse: productCarrousel, at: indexPath)
    }

    if case .npsQuestion = type,
       let questionComponent = component as? YDSpaceyComponentNPSQuestion {
      switch questionComponent.answerType {
        case .star:
          return dequeueStarCell(with: questionComponent, at: indexPath)
        case .option:
          return dequeueOptionsCell(with: questionComponent, at: indexPath)
        case .grade:
          return dequeueGradeCell(with: questionComponent, at: indexPath)
        case .multiple:
          return dequeueMultipleChoicesCell(with: questionComponent, at: indexPath)

        default:
          fatalError("type: \(questionComponent.answerType) isn't support yet")
      }
    }

    if case .npsEditText = type,
       let questionComponent = component as? YDSpaceyComponentNPSQuestion {
      return dequeueEditTextCell(with: questionComponent, at: indexPath)
    }

    if case .termsOfUse = type,
       let termsComponent = component as? YDSpaceyComponentTermsOfUse {
      return dequeueTermsOfUseCell(with: termsComponent, at: indexPath)
    }

//    #warning("STAND BY")
//    if case .grid = type,
//       let gridComponent = component as? YDSpaceyComponentGrid {
//      return dequeueGridCell(with: gridComponent, at: indexPath)
//    }
    
    if case .liveNPS = type,
       let liveNPSComponent = component as? YDSpaceyComponentLiveNPS {
      return dequeueLiveNPSCell(with: liveNPSComponent, at: indexPath)
    }
    
    if case .nextLiveParent = type,
       let nextLiveParent = component as? YDSpaceyComponentNextLiveStruct {
      return dequeueNextLiveCell(with: nextLiveParent, at: indexPath)
    }

    if case .custom = type,
       let customComponent = component as? YDSpaceyCustomComponentDelegate {
      return dequeueCustomCell(with: customComponent, at: indexPath)
    }

    guard let item = component.children.first else {
      fatalError("type: \(type)")
    }

    switch item {
      case .banner(let banner):
        return dequeueBannerCell(withBanner: banner, at: indexPath)

      case .title(let title):
        return dequeueTitleCell(withTitle: title, at: indexPath)

      default:
        fatalError("type: \(type) isn't support yet")
    }
  }
  
  private func didEndDisplayBannerCarrouselCell(
    _ cell: SpaceyBannerCarrouselCollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let component = viewModel?.componentsList.value.at(
      indexPath.item
    )?.component as? YDSpaceyComponentCarrouselBanner
    else {
      return
    }
    
    component.currentRectList = cell.collectionViewOffset
  }
  
  private func didEndDisplayProductCarrouselCell(
    _ cell: SpaceyProductCarrouselCollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    viewModel?.carrouselProducts[indexPath.item]?.currentRectList = cell.collectionViewOffset
  }
}
