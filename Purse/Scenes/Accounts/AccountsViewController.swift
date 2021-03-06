import Foundation
import UIKit

protocol AccountsViewProtocol: class {
    func setOperationTypesConfiguration(onIncomePressed: @escaping () -> ()?, onOutgoPressed: @escaping () -> ()?, onTransferPressed: @escaping () -> ()?)
    func setAccountsButtonConfiguration(with title: String, dropDownOptions: [String])
}

class AccountsViewController: UIViewController, AccountsViewProtocol, OperationTypesViewProtocol {
    var operationTypesView: OperationTypesView!

    static let reuseId = "AccountsViewController_reuseId"
   private var accountsButton = dropDownButton()
    
    var presenter: AccountsPresenterProtocol!

    @IBOutlet private weak var sumLabel: UILabel!
    
    @IBAction func operationsButtonPressed(_ sender: Any) {
        if operationTypesView == nil {
            presenter.configureOperationTypesView()
        }
        operationTypesView.show(in: self)
    }
    
    func setOperationTypesConfiguration(onIncomePressed: @escaping () -> ()?, onOutgoPressed: @escaping () -> ()?, onTransferPressed: @escaping () -> ()?) {
        operationTypesView = OperationTypesView()
        operationTypesView.onIncomePressed = onIncomePressed
        operationTypesView.onOutgoPressed = onOutgoPressed
        operationTypesView.onTransferPressed = onTransferPressed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountsButton = dropDownButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(accountsButton)

        presenter.configureAccountsButton()
    }
    
    func setAccountsButtonConfiguration(with title: String, dropDownOptions: [String]) {
        accountsButton.setTitle(title, for: .normal)
        accountsButton.dropView.dropDownOptions = dropDownOptions 
    }
    
    override func updateViewConstraints() {
        let btnWidth = 200.0
        let btnHeight = 60.0
        
        accountsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        accountsButton.widthAnchor.constraint(equalToConstant: CGFloat(btnWidth)).isActive = true
        accountsButton.heightAnchor.constraint(equalToConstant: CGFloat(btnHeight)).isActive = true
        
        let verticalConstraint = NSLayoutConstraint(item: sumLabel, attribute: NSLayoutAttribute.bottomMargin, relatedBy: NSLayoutRelation.equal, toItem: accountsButton, attribute: NSLayoutAttribute.topMargin, multiplier: 1, constant: -10)
        self.view.addConstraint(verticalConstraint)
        verticalConstraint.isActive = true
        accountsButton.translatesAutoresizingMaskIntoConstraints = false 
        super.updateViewConstraints()
    }
}

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.operationsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OperationTableViewCell.reuseId, for: indexPath) as? OperationTableViewCell else {
            return UITableViewCell()
        }
        presenter.configure(cell: cell, for: indexPath.row)
        return cell
    }
}
