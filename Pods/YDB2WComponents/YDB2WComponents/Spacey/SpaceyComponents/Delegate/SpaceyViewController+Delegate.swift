//
//  SpaceyViewController+Delegate.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 16/04/21.
//

import UIKit
import YDB2WModels

public protocol YDSpaceyControllerDelegate: AnyObject {
  func onPlayerComponentID(_ videoId: String?)

  /**
   Exemplo for injecting custom components
   ```swift
   func onComponentsList(_ list: [YDSpaceyCommonStruct]) {
   if !hasCustomCells { return }

   guard let nextLiveStruct = spaceyComponent?
   .getList().first(
   where: { $0.component?.type == .nextLive }
   ),
   (nextLiveStruct.component?
   .children.first?.get() as? YDSpaceyComponentNextLive) != nil
   else {
   return
   }

   let countDownComponent = CountDownComponent()
   var arr = list
   print("arr.count", arr.count)
   arr.insert(
   YDSpaceyCommonStruct(
   id: "countDown",
   component: countDownComponent
   ),
   at: 0
   )
   print("arr.count", arr.count)
   spaceyComponent?.set(list: arr)
   }
   ```
   - Parameter list: [YDSpaceyCommonStruct]
   */
  func onComponentsList(_ list: [YDSpaceyCommonStruct])

  func scrollViewDidScroll(_ scrollView: UIScrollView)
  func onChange(size: CGSize)
  func registerCustomCells(_ collectionView: UICollectionView)
  func dequeueCustomCell(
    _ collectionView: UICollectionView,
    forIndexPath indexPath: IndexPath,
    component: YDSpaceyCustomComponentDelegate
  ) -> UICollectionViewCell
}
