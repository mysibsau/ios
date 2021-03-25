//
//  ChoicePlaceViewController.swift
//  my-sibgu
//
//  Created by art-off on 04.03.2021.
//

import UIKit

class ChoicePlaceViewController: UIViewController {
    
    var concert: PerformanceConcert!
    
    
    private let activityIndicatorView = UIActivityIndicatorView()
    private let alertView = AlertView()
    
    
    private let scrollView = UIScrollView()
    private var roomStructView: RoomStructView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        loadItems()
    }
    
    private func setupScrollView() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.flashScrollIndicators()
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func loadItems() {
        startActivityIndicator()
        
        TicketsService().getConcert(id: concert.id) { items in
            DispatchQueue.main.async {
                guard let items = items else {
                    self.stopActivityIndicator()
                    self.showNetworkAlert()
                    return
                }
                self.setupScrollView()
                self.setupRoomStructView(items: items)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func setupRoomStructView(items: [[RoomItem?]]) {
        view.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        
        let roomStructViewWidth = scrollView.frame.width
        let roomStructViewHeight = scrollView.frame.height - 200
        
        roomStructView = RoomStructView(items: items, viewWidth: roomStructViewWidth, viewHeight: roomStructViewHeight)
        scrollView.addSubview(roomStructView)
        roomStructView.frame = CGRect(x: 0, y: 0, width: roomStructViewWidth, height: roomStructViewHeight)
    }

}

extension ChoicePlaceViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return roomStructView ?? nil
    }
}

extension ChoicePlaceViewController: AnimatingNetworkProtocol {
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
}

extension ChoicePlaceViewController: AlertingViewController {
    func alertingSuperViewForDisplay() -> UIView {
        view
    }
    
    func alertingAlertView() -> AlertView {
        alertView
    }
}
