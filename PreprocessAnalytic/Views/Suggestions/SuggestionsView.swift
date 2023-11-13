//
//  SuggestionsView.swift
//  PreprocessAnalytic
//
//  Created by Roushil Singla on 05/11/23.
//

import Cocoa

protocol SuggestionViewDelegate: AnyObject {
    func onSingleSelection(index: Int)
    func onDoubleSelection(index: Int)
}

class SuggestionsView: NSView {
    
    @IBOutlet var customView: NSView!
    @IBOutlet weak var interactionView: UserInteractionView!
    @IBOutlet weak var suggestionTableView: NSTableView!
    
    private var suggestions: [Suggestions] = []
    weak var delegate: SuggestionViewDelegate?
    
    init(delegate: SuggestionViewDelegate?, suggestions: [Suggestions]) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.suggestions = suggestions
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

    }
    
    private func setupView() {
        addView()
        setUpTable()
    }
    
    private func addView() {
        Bundle(for: SuggestionsView.self).loadNibNamed("SuggestionsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        customView.frame = contentFrame
        addSubview(customView)
    }
    
    private func setUpTable() {
        suggestionTableView.dataSource               = self
        suggestionTableView.delegate                 = self
        suggestionTableView.selectionHighlightStyle  = .none
        suggestionTableView.doubleAction = #selector(doubleClicked)
        suggestionTableView.register(NSNib(nibNamed: "SuggestionCellView", bundle: Bundle(for: SuggestionCellView.self)), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SuggestionCellView"))
    }
    
    func resetSelection() {
        suggestions.indices.forEach({ suggestions[$0].isSelected = false })
        suggestionTableView.reloadData()
    }
    
    func setInteraction(_ value: Bool) {
        interactionView.isUserInteractionEnabled = value
    }
}

extension SuggestionsView: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        tableColumn?.width = tableView.frame.size.width - 40
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SuggestionCellView"), owner: self) as? SuggestionCellView else { return NSView() }
        cell.suggestion = suggestions[row]
        return cell
    }
}

extension SuggestionsView: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let selectedTableView = notification.object as? NSTableView else { return }
        let selectedRow = selectedTableView.selectedRow
        suggestions.indices.forEach({ suggestions[$0].isSelected = false })
        suggestions[selectedRow].isSelected = true
        delegate?.onSingleSelection(index: selectedRow)
        suggestionTableView.reloadData()
    }
    
    @objc func doubleClicked() {
        guard suggestionTableView.clickedRow >= 0 else { return }
        delegate?.onDoubleSelection(index: suggestionTableView.clickedRow)
    }
}
