//
//  GroupSubgroupVIew.swift
//  my-sibgu
//
//  Created by art-off on 25.11.2020.
//

import UIKit

class GroupSubgroupView: UIView {
    
    var professorsId: [Int]?
    var placeId: Int?
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var professor: UILabel!
    @IBOutlet weak var place: UILabel!
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        loadXib()
        setupViews()
        addRecongnizers()
    }
    
    // MARK: Setup Views
    private func loadXib() {
        // загружаем xib из какого-то Boundle (можно чекнуть документацию)
        Bundle.main.loadNibNamed("GroupSubgroupView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    private func setupViews() {
        setupLabels()
    }
    
    private func setupLabels() {
        for label in [subject, type, professor, place] {
            label?.textAlignment = .left
            label?.numberOfLines = 0
            label?.lineBreakMode = .byWordWrapping
        }
        place.textAlignment = .right
        place.textColor = UIColor.Pallete.gray
        
        subject.textColor = UIColor.Pallete.sibsuBlue
        type.textColor = UIColor.Pallete.sibsuGreen
        professor.textColor = UIColor.Pallete.gray
    }
    
    // MARK: - Recongnizers
    private func addRecongnizers() {
        let longRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.addGestureRecognizer(longRecognizer)
    }
    
    @objc func longPress() {
        // 1. let timetable = DataManager.sharedInstance.getTimetable(forProfessor: professorId)
        // NotificationCenter.default.post(name: .didSelectProfessor, object: self, userInfo: [0: timetalbe])
        
        // 2. let timetable = DataManager.sharedinstance.gettimetable(forPlace: placeId)
        // NotificationCenter.default.post(name: .didSelectPlace, object: self, userInfo: [0: timetalbe])
    }
    
}
