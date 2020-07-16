import LitewalletPartnerAPI
import Security
import UIKit

@objc protocol LitecoinCardRegistrationViewDelegate {
    func didReceiveOpenLitecoinCardAccount(account: Data)
    func litecoinCardAccountExists(error: Error)
    func floatingRegistrationHeader(shouldHide: Bool)
    func shouldReturnToLoginView()
}

class SpendViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, LFAlertViewDelegate {
    static let serviceName = "com.litewallet.litecoincard.service"
    let mockDict: [String: Any] = ["firstname":"Test",
            "lastname":"User",
            "email":  "kwashington+" + String(Int.random(in: 20000 ..< 30099)) + "@gmail.com",
            "address1":"123 Main",
            "city":"Sat",
            "country":"US",
            "phone":"1234567890",
            "zip_code":"95014",
            "username":"test"
    ]
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var headerLabel: UILabel!

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var address1TextField: UITextField!
    @IBOutlet var address2TextField: UITextField! 
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var postalCodeTextField: UITextField!
    @IBOutlet var mobileTextField: UITextField!

    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!

    var currentTextField: UITextField?
    var isRegistered: Bool?
    var pickerView: UIPickerView?
    var countries = [String]()
    let idTypes = [S.LitecoinCard.kycDriversLicense, S.LitecoinCard.kycPassport]

    let attrSilver = [NSAttributedString.Key.foregroundColor: UIColor.litecoinSilver]
    let attrOrange = [NSAttributedString.Key.foregroundColor: UIColor.litecoinOrange]

    var alertModal: LFAlertViewController?
    var userNotRegistered = true
    var delegate: LitecoinCardRegistrationViewDelegate?

    var manager = PartnerAPIManager()

    override func viewDidLoad() {
        setupModelData()
        super.viewDidLoad()
        setupSubViews()

        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchToCardViewController), name: kDidReceiveNewLitecoinCardData, object: nil)
    }

    override func viewWillLayoutSubviews() {}

    override func viewWillAppear(_: Bool) {}

    private func setupModelData() {
        // Phase 0 only supports US transactions on LitecoinCard
        countries.append(Country.unitedStates.name)
    }

    private func setupSubViews() {
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self

        automaticallyAdjustsScrollViewInsets = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        scrollView.delegate = self
        scrollView.isScrollEnabled = true

        emailTextField.placeholder = S.LitecoinCard.emailPlaceholder
        passwordTextField.placeholder = S.LitecoinCard.passwordPlaceholder
        confirmPasswordTextField.placeholder = S.LitecoinCard.confirmPasswordPlaceholder
        firstNameTextField.placeholder = S.LitecoinCard.firstNamePlaceholder
        lastNameTextField.placeholder = S.LitecoinCard.lastNamePlaceholder
        address1TextField.placeholder = S.LitecoinCard.addressPlaceholder
        address2TextField.placeholder = S.LitecoinCard.addressPlaceholder
        cityTextField.placeholder = S.LitecoinCard.cityPlaceholder
        stateTextField.placeholder = S.LitecoinCard.statePlaceholder
        postalCodeTextField.placeholder = S.LitecoinCard.postalPlaceholder
        mobileTextField.placeholder = S.LitecoinCard.mobileNumberPlaceholder
        registerButton.setTitle(S.LitecoinCard.registerButtonTitle, for: .normal)
        registerButton.layer.cornerRadius = 5.0
        countryTextField.text = Country.unitedStates.name

        let textFields = [emailTextField, firstNameTextField, lastNameTextField, passwordTextField, confirmPasswordTextField, address1TextField, address2TextField, cityTextField, stateTextField, countryTextField, mobileTextField, postalCodeTextField]
        textFields.forEach { textField in
            textField?.inputAccessoryView = okToolbar()
        }

        registerButton.layer.cornerRadius = 5.0
        registerButton.clipsToBounds = true

        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = #colorLiteral(red: 0.2053973377, green: 0.3632233143, blue: 0.6166344285, alpha: 1)

        loginButton.layer.cornerRadius = 5.0
        loginButton.clipsToBounds = true
    }
 
    @IBAction func registerAction(_: Any) {
        // Validate registration data
        // TODO: Uncomment
        if 1 > 0 /*registeredParams = didValidateRegistrationParams()*/ {
          print("XXXX \(mockDict)")
          print("XXXX") 
            manager.createUser(userDataParams: mockDict) { newUser in
                
                let jsonEncoder = JSONEncoder()
                do {
                    let jsonData = try jsonEncoder.encode(newUser)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    print("JSON String : " + jsonString!)
                    self.delegate?.didReceiveOpenLitecoinCardAccount(account: jsonData)

                }
                catch {

                }
                
 
            }

        } else {
            
        }

     }

    @IBAction func returnToLoginView(_: Any) {
        delegate?.shouldReturnToLoginView()
    }

    private func didValidateRegistrationParams() -> [String: Any]? {

         do {
            let email = try emailTextField.validatedText(validationType: ValidatorType.email)
            let password = try passwordTextField.validatedText(validationType: ValidatorType.password)
            let confirmPassword = try confirmPasswordTextField.validatedText(validationType: ValidatorType.password)
            if password != confirmPassword {
               throw ValidationError("Password and Confirm password must match")
            }
            let firstName = try firstNameTextField.validatedText(validationType: ValidatorType.firstName)
            let lastname = try self.lastNameTextField.validatedText(validationType: ValidatorType.lastName)
            let address1 = try address1TextField.validatedText(validationType: ValidatorType.address)
            let address2 = try address2TextField.validatedText(validationType: ValidatorType.address)

            let city = try cityTextField.validatedText(validationType: ValidatorType.city)
            let state = try stateTextField.validatedText(validationType: ValidatorType.state)
            let postalCode = try postalCodeTextField.validatedText(validationType: ValidatorType.postalCode)
            let country = try countryTextField.validatedText(validationType: ValidatorType.country)
            let mobile = try mobileTextField.validatedText(validationType: ValidatorType.mobileNumber)
             
            return [
                "email": email,
                "password": password,
                "confirm_password": confirmPassword,
                "firstname": firstName,
                "lastname": lastname,
                "address1": address1,
                "address2": address2,
                "city": city,
                "state": state,
                "zip_code": postalCode,
                "country": country,
                "phone": mobile
            ]
 
           } catch(let error) {

            let message = (error as! ValidationError).message
            showErrorAlert(for: message)

           }
        return nil
    }

    func showErrorAlert(for alert: String) {
        // TODO: Refactor whenTernio OAUTH is ready

        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
 
    private func createLitecoinCardWallet(cardAccountData _: LitecoinCardAccountData) {
        // TODO: Refactor whenTernio OAUTH is ready

        // self.delegate?.didReceiveTernioAccount(account: account)
    }

    // MARK: Card VC Methods

    @objc func switchToCardViewController() {
        if let cardVC = UIStoryboard(name: "Spend", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
            print("Switch to CardView")
            addChild(cardVC)
            view.addSubview(cardVC.view)
            didMove(toParent: self)
        }
    }

    // MARK: UI Keyboard Methods

    @objc func dismissKeyboard() {
        currentTextField?.resignFirstResponder()
        resignFirstResponder()
    }

    func alertViewCancelButtonTapped() {
        dismiss(animated: true) {
            NSLog("Cancel Alert")
        }
    }

    @objc func dismissAlertView(notification _: Notification) {
        dismiss(animated: true) {
            NSLog("Dismissed Spend View Controller")
        }
    }

    func okToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 88))
        let okButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        okButton.tintColor = .liteWalletBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, okButton, flexibleSpace], animated: true)
        toolbar.tintColor = .litecoinDarkSilver
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }

    @objc private func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            guard let yPosition = currentTextField?.frame.origin.y else {
                NSLog("ERROR:  - Could not get y position")
                return
            }

            scrollView.contentInset = UIEdgeInsets(top: 20 - yPosition, left: 0, bottom: keyboardViewEndFrame.height - view.frame.height, right: 0)
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }
    }

    // MARK: UIPickerView Delegate & Setup

    func numberOfComponents(in _: UIPickerView) -> Int { return 1 }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return 0
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return ""
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        if countryTextField.isFirstResponder {
            countryTextField.text = countries[row]
        }
    }

    // MARK: UITextField Delegate & Setup

    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }

    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString _: String) -> Bool {
        return true
    }
}
