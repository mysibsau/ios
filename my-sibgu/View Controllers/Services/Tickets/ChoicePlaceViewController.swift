//
//  ChoicePlaceViewController.swift
//  my-sibgu
//
//  Created by art-off on 04.03.2021.
//

import UIKit

class ChoicePlaceViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private var roomStructView: RoomStructView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupRoomStructView()
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
        scrollView.backgroundColor = .red
    }
    
    private func setupRoomStructView() {
        view.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        view.backgroundColor = .darkGray
        scrollView.backgroundColor = .red
        
        let roomStructViewWidth = scrollView.frame.width
        let roomStructViewHeight = scrollView.frame.height - 200

        roomStructView = RoomStructView(rows: 20, columns: 30, viewWidth: roomStructViewWidth, viewHeight: roomStructViewHeight)
        scrollView.addSubview(roomStructView)
        roomStructView.frame = CGRect(x: 0, y: 0, width: roomStructViewWidth, height: roomStructViewHeight)
        roomStructView.backgroundColor = .blue
    }

}

extension ChoicePlaceViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return roomStructView
    }
}
