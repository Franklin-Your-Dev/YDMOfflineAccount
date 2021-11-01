//
//  YDMFindStoreViewController.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 27/11/20.
//

import UIKit
import MapKit
import CoreLocation

import YDB2WAssets
import YDUtilities
import YDExtensions
import YDB2WComponents
import YDB2WColors

class YDMFindStoreViewController: UIViewController {
  // MARK: Properties
  var viewModel: YDMFindStoreViewModelDelegate?
  var alreadyPlaceCurrentLocationMarker = false
  var annotations: [MKAnnotation] = []
  var initialCoords: CLLocationCoordinate2D?
  var reAdjustinRect = false
  var currentStoreIndex = 0
  var showingVerticalList = false
  lazy var cardWidthSize: CGFloat = {
    var margin: CGFloat = 41

    if UIDevice.iPhone5 {
      margin = 20
    }

    return view.frame.size.width - margin
  }()
  lazy var verticalCardWidthSize: CGFloat = {
    var margin: CGFloat = 32

    if UIDevice.iPhone5 {
      margin = 20
    }

    return view.frame.size.width - margin
  }()

  // MARK: Components
  let blurView = UIVisualEffectView()
  let verticalListContainer = UIView()
  let howManyStoresVerticalLabel = UILabel()
  let verticalCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )
  let errorView = UIView()
  let errorViewActionButton = YDWireButton(withTitle: "atualizar")

  // MARK: IBOutlets
  @IBOutlet weak var mapView: MKMapView! {
    didSet {
      mapView.showsUserLocation = true
      mapView.tintColor = YDColors.branding
      mapView.delegate = self

      mapView.register(
        CustomLargerAnnotation.self,
        forAnnotationViewWithReuseIdentifier: CustomLargerAnnotation.identifier
      )

      mapView.register(
        CustomSmallAnnotation.self,
        forAnnotationViewWithReuseIdentifier: CustomSmallAnnotation.identifier
      )

      if #available(iOS 13, *) {
        let pointsFilter = MKPointOfInterestFilter(including: [
          .hotel,
          .hospital,
          .aquarium,
          .beach,
          .nationalPark,
          .museum,
          .stadium,
          .zoo,
          .theater,
          .movieTheater,
          .publicTransport,
          .airport
        ])

        mapView.showsPointsOfInterest = true
        mapView.pointOfInterestFilter = pointsFilter
      } else {
        mapView.showsPointsOfInterest = false
      }
    }
  }

  @IBOutlet weak var navBarContainer: UIView! {
    didSet {
      navBarContainer.backgroundColor = .clear
    }
  }

  @IBOutlet weak var exitButton: UIButton! {
    didSet {
      exitButton.layer.cornerRadius = exitButton.frame.height / 2
      exitButton.setImage(YDAssets.Icons.leftArrow, for: .normal)
    }
  }

  @IBOutlet weak var listButton: UIButton! {
    didSet {
      listButton.layer.cornerRadius = 16
      listButton.setImage(YDAssets.Icons.bars, for: .normal)

      if UIDevice.iPhone5 {
        listButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        listButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -7, bottom: 0, right: 0)
      }
    }
  }

  @IBOutlet weak var locationContainer: UIView!

  @IBOutlet weak var locationPinIcon: UIImageView! {
    didSet {
      locationPinIcon.image = YDAssets.Icons.locationPin
    }
  }

  @IBOutlet weak var locationButton: UIButton! {
    didSet {
      locationButton.setImage(YDAssets.Icons.point, for: .normal)
    }
  }

  @IBOutlet weak var locationActivityIndicator: UIActivityIndicatorView!

  @IBOutlet weak var locationChevronIcon: UIImageView! {
    didSet {
      locationChevronIcon.image = YDAssets.Icons.chevronDown
    }
  }

  @IBOutlet weak var storesListContainer: UIView!

  @IBOutlet weak var howManyStoresLabel: UILabel!

  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView.delegate = self
      collectionView.dataSource = self

      let bundle = Bundle.init(for: YDMFindStoreViewController.self)
      let storeCard = YDMFindStoreStoreCardCollectionViewCell.loadNib(bundle)

      collectionView.register(
        storeCard,
        forCellWithReuseIdentifier: YDMFindStoreStoreCardCollectionViewCell.identifier
      )
    }
  }

  @IBOutlet weak var myLocationButton: UIButton! {
    didSet {
      myLocationButton.layer.cornerRadius = myLocationButton.frame.height / 2
      myLocationButton.setImage(YDAssets.Icons.gps, for: .normal)
    }
  }

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    configureLayout()
    setUpBinds()

    storesListContainer.isHidden = true
    myLocationButton.isHidden = true

    locationActivity()

    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
      guard let self = self else { return }
      self.viewModel?.getPreviousAddress()
    }
  }

  deinit {
    mapView.delegate = nil
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let coords = initialCoords {
      zoomToPosition(coords)
    }
  }

  // MARK: IBActions
  @IBAction func onExitAction(_ sender: Any) {
    viewModel?.onExit()
  }

  @IBAction func onListAction(_ sender: Any) {
    toggleVerticalList()
  }

  @IBAction func onLocationAction(_ sender: Any) {
    locationActivity()
    viewModel?.onGetLocation()
    
    if showingVerticalList {
      toggleVerticalList()
    }
  }

  @IBAction func onMyLocationAction(_ sender: UIButton) {
    let userCoords = mapView.userLocation.coordinate

    if let firstStoreCoords = viewModel?.stores.value.first?.geolocation,
       let latitude = firstStoreCoords.latitude,
       let longitude = firstStoreCoords.longitude {

      let nearstStoreCoords = CLLocationCoordinate2D(
        latitude: latitude,
        longitude: longitude
      )
      setMapCenterBetween(positionA: userCoords, positionB: nearstStoreCoords)

      // To make list scroll to first item
      collectionView.scrollToItem(
        at: IndexPath(row: 0, section: 0),
        at: .centeredHorizontally,
        animated: true
      )

      redrawPins(highlightAt: 0, shouldCenterMap: false)

    } else {
      let span = mapView.region.span
      zoomToPosition(userCoords, withSpan: span)
    }
  }
}

// MARK: Actions
extension YDMFindStoreViewController {
  func toggleVerticalList() {
    storesListContainer.isHidden = !showingVerticalList
    myLocationButton.isHidden = !showingVerticalList
    blurView.isHidden = showingVerticalList
    verticalListContainer.isHidden = showingVerticalList

    listButton.setImage(
      showingVerticalList ?
        YDAssets.Icons.bars :
        YDAssets.Icons.map,
      for: .normal
    )

    listButton.setTitle(
      showingVerticalList ?
        "lista" :
        "mapa",
      for: .normal
    )

    showingVerticalList.toggle()
    
    if showingVerticalList {
      viewModel?.openListMetric()
    }
  }
  
  func formatHowManyStoresOnList(with howMany: Int) {
    howManyStoresLabel.text = "\(howMany) Americanas perto de você"

    howManyStoresVerticalLabel.text = String(
      format: howManyStoresLabel.text ?? "",
      howMany
    )

    howManyStoresLabel.isHidden = false
    howManyStoresVerticalLabel.isHidden = false
  }

  func onErrorActionButton(_ sender: UIButton) {
    viewModel?.refreshRequest()
  }

  func showErrorView(hide: Bool = false) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.errorView.isHidden = hide
      self.listButton.isEnabled = hide
      self.myLocationButton.isHidden = !hide
      self.storesListContainer.isHidden = !hide
    }
  }
}
