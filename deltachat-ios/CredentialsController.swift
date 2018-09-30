//
//  CredentialsController.swift
//  deltachat-ios
//
//  Created by Jonas Reinsch on 15.11.17.
//  Copyright © 2017 Jonas Reinsch. All rights reserved.
//

import UIKit

class TextFieldCell:UITableViewCell {
    let textField = UITextField()
    
    init(description: String, placeholder: String) {
        super.init(style: .value1, reuseIdentifier: nil)
        
        textLabel?.text = "\(description):"
        contentView.addSubview(textField)

        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // see: https://stackoverflow.com/a/35903650
        // this makes the textField respect the trailing margin of
        // the table view cell
        let margins = contentView.layoutMarginsGuide
        let trailing = margins.trailingAnchor
        textField.trailingAnchor.constraint(equalTo: trailing).isActive = true
        textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textField.textAlignment = .right

        textField.placeholder = placeholder
        
        selectionStyle = .none
        
        textField.enablesReturnKeyAutomatically = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            textField.becomeFirstResponder()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func makeEmailCell() -> TextFieldCell {
        let emailCell = TextFieldCell(description: "Email", placeholder: "you@example.com")
        
        emailCell.textField.keyboardType = .emailAddress
        // switch off quicktype
        emailCell.textField.autocorrectionType = .no
        emailCell.textField.autocapitalizationType = .none
        
        return emailCell
    }
    
    static func makePasswordCell() -> TextFieldCell {
        let passwordCell = TextFieldCell(description: "Password", placeholder: "your IMAP password")
        
        passwordCell.textField.textContentType = UITextContentType.password
        passwordCell.textField.isSecureTextEntry = true
        
        return passwordCell
    }
    
    static func makeNameCell() -> TextFieldCell {
        let nameCell = TextFieldCell(description: "Name", placeholder: "new contacts nickname")
        
        nameCell.textField.autocapitalizationType = .words
        nameCell.textField.autocorrectionType = .no
        // .namePhonePad doesn't support autocapitalization
        // see: https://stackoverflow.com/a/36365399
        // therefore we use .default to capitalize the first character of the name
        nameCell.textField.keyboardType = .default
        
        return nameCell
    }
    
    static func makeConfigCell(label: String, placeholder: String) -> TextFieldCell {
        let nameCell = TextFieldCell(description: label, placeholder: placeholder)
        
        nameCell.textField.autocapitalizationType = .words
        nameCell.textField.autocorrectionType = .no
        // .namePhonePad doesn't support autocapitalization
        // see: https://stackoverflow.com/a/36365399
        // therefore we use .default to capitalize the first character of the name
        nameCell.textField.keyboardType = .default
        
        return nameCell
    }
    
    
}

class CredentialsController: UITableViewController {
    let emailCell = TextFieldCell.makeEmailCell()
    let passwordCell = TextFieldCell.makePasswordCell()
    
    let imapCellLoginName = TextFieldCell.makeConfigCell(label: "IMAP Login Name", placeholder: "Automatic")
    let imapCellServer = TextFieldCell.makeConfigCell(label: "IMAP Server", placeholder: "Automatic")
    let imapCellPort = TextFieldCell.makeConfigCell(label: "IMAP Port", placeholder: "Automatic")
    let imapCellSecurity = TextFieldCell.makeConfigCell(label: "Security", placeholder: "Automatic")
    
    let smtpCellLoginName = TextFieldCell.makeConfigCell(label: "SMTP Login Name", placeholder: "Automatic")
    let smtpCellPassword = TextFieldCell.makeConfigCell(label: "SMTP Password", placeholder: "As above")
    let smtpCellServer = TextFieldCell.makeConfigCell(label: "SMTP Server", placeholder: "Automatic")
    let smtpCellPort = TextFieldCell.makeConfigCell(label: "SMTP Port", placeholder: "Automatic")
    let smtpCellSecurity = TextFieldCell.makeConfigCell(label: "Security", placeholder: "Automatic")
    
    var doneButton:UIBarButtonItem?
    var advancedButton:UIBarButtonItem?
    let progressBar = UIProgressView(progressViewStyle: .default)
    
    func readyForLogin() -> Bool {
        return Utils.isValid(model.email) && !model.password.isEmpty
    }
    
    var advancedMode = false {
        didSet {
            if advancedMode {
                advancedButton?.title = "Standard"
            } else {
                advancedButton?.title = "Advanced"
            }
            tableView.reloadData()
        }
    }
    var model:(
        email:String,
        password:String,
        imapLoginName:String?,
        imapServer:String?,
        imapPort:String?,
        imapSecurity:String?,
        smtpLoginName:String?,
        smtpPassword:String?,
        smtpServer:String?,
        smtpPort:String?,
        smtpSecurity:String?
        ) = ("", "", nil, nil, nil, nil, nil, nil, nil, nil, nil) {
        didSet {
            if readyForLogin() {
                doneButton?.isEnabled = true
            } else {
                doneButton?.isEnabled = false
            }
            print(model)
        }
    }
    
    let cells:[UITableViewCell]
    
    init() {
        cells = [emailCell, passwordCell]

        super.init(style: .grouped)
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didPressSaveAccountButton))
        doneButton?.isEnabled = false
        advancedButton = UIBarButtonItem(title: "Advanced", style: .done, target: self, action: #selector(didPressAdvancedButton))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = advancedButton
        
        // FIXME: refactor: do not use target/action here for text field changes
        //        but text field delegate
        emailCell.textField.addTarget(self, action: #selector(emailTextChanged), for: UIControlEvents.editingChanged)
        passwordCell.textField.addTarget(self, action: #selector(passwordTextChanged), for: UIControlEvents.editingChanged)
        imapCellLoginName.textField.addTarget(self, action: #selector(imapLoginNameChanged), for: .editingChanged)
        imapCellServer.textField.addTarget(self, action: #selector(imapServerChanged), for: .editingChanged)
        imapCellPort.textField.addTarget(self, action: #selector(imapPortChanged), for: .editingChanged)
        imapCellSecurity.textField.addTarget(self, action: #selector(imapSecurityChanged), for: .editingChanged)
        
        smtpCellLoginName.textField.addTarget(self, action: #selector(smtpLoginNamedChanged), for: .editingChanged)
        smtpCellPassword.textField.addTarget(self, action: #selector(smtpPasswordChanged), for: .editingChanged)
        smtpCellServer.textField.addTarget(self, action: #selector(smtpServerChanged), for: .editingChanged)
        smtpCellPort.textField.addTarget(self, action: #selector(smtpPortChanged), for: .editingChanged)
        smtpCellSecurity.textField.addTarget(self, action: #selector(smtpSecurityChanged), for: .editingChanged)
        
        emailCell.textField.textContentType = UITextContentType.emailAddress
        emailCell.textField.delegate = self
        passwordCell.textField.delegate = self
        emailCell.textField.returnKeyType = .next
        passwordCell.textField.returnKeyType = .done
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailCell.textField.becomeFirstResponder()
    }

    
    @objc func didPressSaveAccountButton() {
        dismiss(animated: true) {
            initCore(withCredentials: true, email: self.model.email, password: self.model.password)
        }
    }
    
    @objc func didPressAdvancedButton() {
        advancedMode = !advancedMode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Account"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return advancedMode ? 3 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cells.count
        }
        if section == 1 {
            return 4
        }
        if section == 2 {
            return 5
        }
        return 0 // should never happen
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "IMAP"
        }
        if section == 2 {
            return "SMTP"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((indexPath.section == 1) && (indexPath.row == 3)) || ((indexPath.section == 2) && (indexPath.row == 4)) {
            // FIXME: deselect row here
            let actionSheet = UIAlertController(title: "Security", message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Automatic", style: .default, handler: {a in}))
            actionSheet.addAction(UIAlertAction(title: "SSL/TLS", style: .default, handler: {a in}))
            actionSheet.addAction(UIAlertAction(title: "STARTTLS", style: .default, handler: {a in}))
            actionSheet.addAction(UIAlertAction(title: "Off", style: .default, handler: {a in}))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {a in}))
            self.present(actionSheet, animated: true, completion: {})
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            return cells[row]
        }
        
        if section == 1 {
            if row == 0 {
                return imapCellLoginName
            } else if row == 1 {
                return imapCellServer
            } else if row == 2 {
                return imapCellPort
//            } else if row == 3 {
//                return imapCellSecurity
            } else if row == 3 {
                // FIXME: support iPad
                let imapCellSec = UITableViewCell(style: .default, reuseIdentifier: nil)
                imapCellSec.textLabel?.text = "Security:"
                imapCellSec.selectionStyle = .none
                //                return smtpCellSecurity
                return imapCellSec
        }
        }
        if section == 2 {
            if row == 0 {
                return smtpCellLoginName
            } else if row == 1 {
                return smtpCellPassword
            } else if row == 2 {
                return smtpCellServer
            } else if row == 3 {
                return smtpCellPort
            } else if row == 4 {
                // FIXME: support iPad

                let smtpCellSec = UITableViewCell(style: .default, reuseIdentifier: nil)
                smtpCellSec.selectionStyle = .none
                smtpCellSec.textLabel?.text = "Security:"
//                return smtpCellSecurity
                return smtpCellSec
            }
        }
        return UITableViewCell()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CredentialsController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailCell.textField {
            if let emailText = emailCell.textField.text {
                // only jump to next field if valid email
                if Utils.isValid(emailText) {
                    passwordCell.textField.becomeFirstResponder()
                }
            }
        }
        if textField == passwordCell.textField {
            if readyForLogin() {
                self.didPressSaveAccountButton()
            }
        }
        
        return true
    }
}

extension CredentialsController {
    @objc func emailTextChanged() {
        let emailText = emailCell.textField.text ?? ""
        
        model.email = emailText
    }
    @objc func passwordTextChanged() {
        let passwordText = passwordCell.textField.text ?? ""
        
        model.password = passwordText
    }
    @objc func imapLoginNameChanged() {
        model.imapLoginName = imapCellLoginName.textField.text
    }
    @objc func imapServerChanged() {
        model.imapServer = imapCellServer.textField.text
    }
    @objc func imapPortChanged() {
        model.imapPort = imapCellPort.textField.text
    }
    @objc func imapSecurityChanged() {
        model.imapSecurity = imapCellPort.textField.text
    }
    @objc func smtpLoginNamedChanged() {
        model.smtpLoginName = smtpCellLoginName.textField.text
    }
    @objc func smtpPasswordChanged() {
        model.smtpPassword = smtpCellPassword.textField.text
    }
    @objc func smtpServerChanged() {
        model.smtpServer = smtpCellServer.textField.text
    }
    @objc func smtpPortChanged() {
        model.smtpPort = smtpCellPort.textField.text
    }
    @objc func smtpSecurityChanged() {
        model.smtpSecurity = smtpCellSecurity.textField.text
    }
}
