//
//  AnalyticSearchController.swift
//  Rifa
//
//  Created by Roushil Singla on 03/10/23.
//

import Cocoa

class AnalyticSearchController: NSViewController {
    
    @IBOutlet weak var visualEffectView: NSVisualEffectView!
    @IBOutlet weak var notfView: AppNotificationView!
    @IBOutlet weak var searchView: SearchBarView!
    @IBOutlet weak var informationView: NSView!
    @IBOutlet weak var informationViewHeight: NSLayoutConstraint!
    

    private var showAppNotificationsView = false
    private var suggestionView: SuggestionsView?
    private var resultView: ResultDisplayView?
    let alert = CustomAlert()
    
    var welcomeModel: WelcomeModel?
        
    private var searchBarPurpose: SearchBarPurpose {
        get {
            searchView.barPurpose
        } set {
            searchView.barPurpose = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notfView.delegate = self
        searchView.delegate = self
        updateInformationHeight(animate: false, value: 0)
        handleNotificationDisplay(animate: false)
        getUserDetails()
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.view.window?.performDrag(with: event)
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        view.wantsLayer = true
        visualEffectView.wantsLayer = true
        view.layer?.cornerRadius = 10
        visualEffectView.layer?.cornerRadius = 10
    }
    
    private func handleNotificationDisplay(animate: Bool) {
        if animate {
            notfView.animator().alphaValue = showAppNotificationsView ? 1 : 0
        } else {
            notfView.alphaValue = showAppNotificationsView ? 1 : 0
        }
    }
    
    private func showSuggestions() {
        if suggestionView == nil {
            suggestionView = SuggestionsView(delegate: self, suggestions: welcomeModel?.suggestions ?? [])
            updateInformationHeight(animate: true, value: AppSize.suggestionViewHeight)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [ unowned self] in
                informationView.addView(of: suggestionView ?? NSView())
            }
        }
    }
    
    private func removeSuggestions() {
        suggestionView?.removeFromSuperview()
        suggestionView = nil
    }
    
    private func showResults(text: String) {
        if resultView == nil {
            resultView = ResultDisplayView()
            informationView.addView(of: resultView ?? NSView())
            resultView?.displayResult(text: text)
        }
    }
    
    private func removeResults() {
        resultView?.removeFromSuperview()
        resultView = nil
    }
    
    private func updateInformationHeight(animate: Bool, value: CGFloat) {
        if animate {
            informationViewHeight.animator().constant = value
        } else {
            informationViewHeight.constant = value
        }
    }
    
    private func getUserDetails() {
        
        LogicWorker.shared.requestProfile() { [weak self] result in
            guard let _self = self else { return }
            switch result {
            case .success(let welcomeModel):
                _self.welcomeModel = welcomeModel
                UserInfo.placeholder = welcomeModel?.placeholder ?? ""
                DispatchQueue.main.async {
                    _self.searchView.updatePlaceholder()
                    _self.showSuggestions()
                    _self.updateNotification()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateNotification() {
        notfView.updateNotifications(notification: welcomeModel?.notifications ?? [])
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [ unowned self] in
            onLogoClick()
        }
    }
    
}


extension AnalyticSearchController: AppNotificationDelegate {
    
    func onClearClick() {
        showAppNotificationsView = false
        handleNotificationDisplay(animate: true)
    }
}


extension AnalyticSearchController: SearchBarDelegate {
    
    func onBackClick() {
        removeResults()
        updateInformationHeight(animate: true, value: AppSize.suggestionViewHeight)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [ unowned self] in
            showSuggestions()
        }
    }
    
    func onLogoClick() {
        showAppNotificationsView = true
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.5
            context.allowsImplicitAnimation = true
            handleNotificationDisplay(animate: true)
        }
    }
    
    
    func onSearchClick() {
        
        //if searchBarPurpose == .query {
        //suggestionView?.setInteraction(false)
        //suggestionView?.resetSelection()
        removeSuggestions()
        removeResults()
        alert.showLoader(view: informationView, message: "Rifa is curating results for your query")
        LogicWorker.shared.searchQuery(delegate: self, text: searchView.searchedQuery)
        
        //        } else {
        //            //handle_AI_Conversation
        //
        //        }
    }
    
    func onTextChange(text: String) {
        if searchBarPurpose == .query {
            if text.isEmpty {
                suggestionView?.resetSelection()
            }
        }
    }
}

extension AnalyticSearchController: SuggestionViewDelegate {
    
    func onSingleSelection(index: Int) {
        let suggestion = welcomeModel?.suggestions[index]
        if suggestion?.execute == true {
            searchView.updateText(text: "")
        } else {
            searchView.updateText(text: suggestion?.text ?? "")
        }
    }
    
    func onDoubleSelection(index: Int) {
        let suggestion = welcomeModel?.suggestions[index]
        if suggestion?.execute == true {
            onSearchClick()
        }
    }
}


extension AnalyticSearchController: QueryResultDelegate {
    
    func responeOfQuery(string: String) {
        DispatchQueue.main.async {
            self.searchBarPurpose = .conversation
            self.alert.removeLoader()
            self.updateInformationHeight(animate: true, value: AppSize.resultViewHeight)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [ unowned self] in
                showResults(text: string)
            }
        }
    }
}
