//
//  SurveyViewController.swift
//  my-sibgu
//
//  Created by art-off on 17.01.2021.
//

import UIKit
import SnapKit

class SurveyViewController: UIViewController {
    
    private let surveysService = SurveysService()
    
    var shortSurvey: ShortSurvey!
    
    private var survey: Survey?
    
    // MARK: - Private UI
    private let scrollView = UIScrollView()
    private let questionsStackView = UIStackView()
    
    private let activityIndicatorView = UIActivityIndicatorView()
    
    
    convenience init(shortSurvey: ShortSurvey) {
        self.init()
        self.shortSurvey = shortSurvey
    }
    
    // MARK: - Life Circle
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        
        setupScrollView()
        setupStackView()
        
        loadSurvey()
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setLeftTitle(title: shortSurvey.name)
    }
    
    private func loadSurvey() {
        self.startActivityIndicator()
        surveysService.getSurvey(with: shortSurvey.id) { survey in
            guard let s = survey else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.set(survey: s)
                self.stopActivityIndicator()
            }
        }
    }
    
    // MARK: - Setup Views
    private func setupScrollView() {
        view.addSubview(scrollView)
        // убираем полосы прокрутки
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        // настраиваем свойства StackView
        questionsStackView.axis = .vertical
        questionsStackView.distribution = .equalSpacing
        questionsStackView.spacing = 20
        questionsStackView.isLayoutMarginsRelativeArrangement = true
        questionsStackView.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        scrollView.addSubview(questionsStackView)
        questionsStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(scrollView)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView)
        }
    }
    
    private func set(survey: Survey) {
        for question in survey.questions {
            if question.type == .oneAnswer {
                let oneAnswerQuestionView = SelectAnswerQuesionView(question: question, questionType: .one)
                questionsStackView.addArrangedSubview(oneAnswerQuestionView)
            } else if question.type == .manyAnswers {
                let manyAnswerQuestionView = SelectAnswerQuesionView(question: question, questionType: .many)
                questionsStackView.addArrangedSubview(manyAnswerQuestionView)
            }
        }
    }

}

extension SurveyViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
    
}