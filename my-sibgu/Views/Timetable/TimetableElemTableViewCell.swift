//
//  TimetableElemTableViewCell.swift
//  my-sibgu
//
//  Created by art-off on 28.01.2021.
//

import UIKit

protocol TimetableElemTableViewCellDelegate {
    func didTapButton(at indexPath: IndexPath)
}

class TimetableElemTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TimetableElemCell"
    
    var indexPath: IndexPath!
    var delegate: TimetableElemTableViewCellDelegate?
    
    private let button = UIButton()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(50)
        }
        
        textLabel?.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(button.snp.leading)
        }
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapButton() {
        delegate?.didTapButton(at: indexPath)
    }

}
