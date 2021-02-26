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
    
    private let doneButton = CenterTitleButton()
    
    private let activityIndicatorView = UIActivityIndicatorView()
    private let alertView = AlertView()
    
    
    private var questionViews: [UIView] = []
    
    
    convenience init(shortSurvey: ShortSurvey) {
        self.init()
        self.shortSurvey = shortSurvey
    }
    
    // MARK: - Life Circle
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.Pallete.background
        
        if shortSurvey == nil {
            shortSurvey = ShortSurvey(id: 3, name: "Связаться с разработчиками")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        
        setupScrollView()
        setupStackView()
        
        loadSurvey()
        
        addRecognizerToHideKeyboard()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:UIResponder.keyboardWillHideNotification, object: nil)
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
        questionsStackView.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        
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
                questionViews.append(oneAnswerQuestionView)
                questionsStackView.addArrangedSubview(oneAnswerQuestionView)
            } else if question.type == .manyAnswers {
                let manyAnswerQuestionView = SelectAnswerQuesionView(question: question, questionType: .many)
                questionViews.append(manyAnswerQuestionView)
                questionsStackView.addArrangedSubview(manyAnswerQuestionView)
            } else if question.type == .textAnswer {
                let textAnswerQuestionView = TextAnswerQuestionView(question: question)
                questionViews.append(textAnswerQuestionView)
                questionsStackView.addArrangedSubview(textAnswerQuestionView)
            }
        }
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.titleText = "Отправить"
        doneButton.titleColor = UIColor.Pallete.sibsuBlue
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        questionsStackView.addArrangedSubview(doneButton)
    }
    
    // MARK: - Actions
    @objc
    private func doneButtonTapped() {
        var answers: [AnswerPost] = []
        
        for view in questionViews {
            if let selectAnswerView = view as? SelectAnswerQuesionView {
                let question = selectAnswerView.question!
                let answerIds = selectAnswerView.selectedIds
                // Если ответов нет, а вопрос обязательный - то не отправляем ответ
                if answerIds.isEmpty && question.necessarily {
                    self.showAlert(withText: "Ответьте на все\n обязательные вопросы (с *)")
                    return
                }
                
                let answer = AnswerPost.select(SelectAnswerPost(id: question.id, answers: Array(answerIds)))
                answers.append(answer)
            } else if let textAnswerView = view as? TextAnswerQuestionView {
                let question = textAnswerView.question!
                let textAnswer = textAnswerView.textAnswer
                // Если ответа нет, а вопрос обязательный - то не отправляем
                if textAnswer.isEmpty && question.necessarily {
                    self.showAlert(withText: "Ответьте на все\n обязательные вопросы (с *)")
                    return
                }
                
                let answer = AnswerPost.text(TextAnswerPost(id: question.id, text: textAnswer))
                answers.append(answer)
            }
        }
        
        self.startActivityIndicator()
        surveysService.post(surveyId: shortSurvey.id, answers: answers) { isDone in
            if isDone {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.showAlert(withText: "Что-то полшло не так\nПопробуйте позже")
                }
            }
        }
    }
    
    // MARK: - Methods for Hide Keyboard
    private func addRecognizerToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Methods For Notification -
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
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

extension SurveyViewController: AlertingViewController {
    
    func alertingSuperViewForDisplay() -> UIView {
        view
    }
    
    func alertingAlertView() -> AlertView {
        alertView
    }
    
}
