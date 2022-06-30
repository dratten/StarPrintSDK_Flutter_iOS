import UIKit
import Flutter

enum PaperSizeIndex: Int {
    case twoInch = 384
    case threeInch = 576
    case fourInch = 832
    case escPosThreeInch = 512
    case dotImpactThreeInch = 210
}

var portName:     String!
var portSettings: String!
var modelName:    String!
var macAddress:   String!
var paperSizeIndex: PaperSizeIndex? = nil
var currentSetting: PrinterSetting? = nil

@UIApplicationMain
@objc class AppDelegate: /*FlutterResponder,*/ FlutterAppDelegate {
    
    static let settingManager = SettingManager()
    
    /*static func isSystemVersionEqualTo(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame
    }
    
    static func isSystemVersionGreaterThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
    
    static func isSystemVersionGreaterThanOrEqualTo(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
    }
    
    static func isSystemVersionLessThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
    static func isSystemVersionLessThanOrEqualTo(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending
    }*/
    
    static func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    static func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    var window: UIWindow?
    
    var portName:     String!
    var portSettings: String!
    var modelName:    String!
    var macAddress:   String!
    
    var emulation:                StarIoExtEmulation!
    var cashDrawerOpenActiveHigh: Bool!
    var selectedIndex:            Int!
    var selectedLanguage:         LanguageIndex!
    var selectedPaperSize:        Int?
    var selectedModelIndex:       Int?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let printChannel = FlutterMethodChannel(name: "krossroads.flutter.dev/print", binaryMessenger: controller.binaryMessenger)
    printChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        
        guard call.method == "connectSample" else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        refreshPortInfo()
        didSelectModel(1)
        PrinterFunctions.createTextReceiptData(emulation, localizeReceipts: localizeReceipts, utf8: false)
        
        })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    fileprivate func loadParam() {
        AppDelegate.settingManager.load()
    }
    
    static func getPortName() -> String {
        return settingManager.settings[0]?.portName ?? ""
    }
    
    static func setPortName(_ portName: String) {
        settingManager.settings[0]?.portName = portName
        settingManager.save()
    }
    
    static func getPortSettings() -> String {
        return settingManager.settings[0]?.portSettings ?? ""
    }
    
    static func setPortSettings(_ portSettings: String) {
        settingManager.settings[0]?.portSettings = portSettings
        settingManager.save()
    }
    
    static func getModelName() -> String {
        return settingManager.settings[0]?.modelName ?? ""
    }
    
    static func setModelName(_ modelName: String) {
        settingManager.settings[0]?.modelName = modelName
        settingManager.save()
    }
    
    static func getMacAddress() -> String {
        return settingManager.settings[0]?.macAddress ?? ""
    }
    
    static func setMacAddress(_ macAddress: String) {
        settingManager.settings[0]?.macAddress = macAddress
        settingManager.save()
    }
    
    static func getEmulation() -> StarIoExtEmulation {
        return settingManager.settings[0]?.emulation ?? .starPRNT
    }
    
    static func setEmulation(_ emulation: StarIoExtEmulation) {
        settingManager.settings[0]?.emulation = emulation
        settingManager.save()
    }
    
    static func getCashDrawerOpenActiveHigh() -> Bool {
        return settingManager.settings[0]?.cashDrawerOpenActiveHigh ?? true
    }
    
    static func setCashDrawerOpenActiveHigh(_ activeHigh: Bool) {
        settingManager.settings[0]?.cashDrawerOpenActiveHigh = activeHigh
        settingManager.save()
    }
    
    static func getSelectedIndex() -> Int {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.selectedIndex!
    }
    
    static func setSelectedIndex(_ index: Int) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.selectedIndex = index
    }
    
    static func getSelectedLanguage() -> LanguageIndex {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.selectedLanguage!
    }
    
    static func setSelectedLanguage(_ index: LanguageIndex) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.selectedLanguage = index
    }
    
    static func getSelectedPaperSize() -> PaperSizeIndex {
        return AppDelegate.settingManager.settings[0]?.selectedPaperSize ?? .threeInch
    }
    
    static func setSelectedPaperSize(_ index: PaperSizeIndex) {
        AppDelegate.settingManager.settings[0]?.selectedPaperSize = index
        settingManager.save()
    }
    
    static func getSelectedModelIndex() -> ModelIndex? {
        return AppDelegate.settingManager.settings[0]?.selectedModelIndex
    }
    
    static func setSelectedModelIndex(_ modelIndex: ModelIndex?) {
        settingManager.settings[0]?.selectedModelIndex = modelIndex ?? .none
        settingManager.save()
    }
    
    @objc func refreshPortInfo() {
        let alert = UIAlertController(title: "Select Interface.",
                                      message: nil,
                                      preferredStyle: .alert)
        let buttonTitles = ["LAN", "Bluetooth", "Bluetooth Low Energy", "USB", "All"]
        for i in 0..<buttonTitles.count {
            alert.addAction(UIAlertAction(title: buttonTitles[i], style: .default, handler: { _ in
                self.didSelectRefreshPortInterfaceType(buttonIndex: i + 1)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func didSelectRefreshPortInterfaceType(buttonIndex: Int) {
        self.blind = true
        
        defer {
            self.blind = false
        }
        
        self.cellArray.removeAllObjects()
        
        self.selectedIndexPath = nil
        
        var searchPrinterResult: [PortInfo]? = nil
        
        do {
            switch buttonIndex {
            case 1  :     // LAN
                searchPrinterResult = try SMPort.searchPrinter(target: "TCP:") as? [PortInfo]
            case 2  :     // Bluetooth
                searchPrinterResult = try SMPort.searchPrinter(target: "BT:")  as? [PortInfo]
            case 3  :     // Bluetooth Low Energy
                searchPrinterResult = try SMPort.searchPrinter(target: "BLE:") as? [PortInfo]
            case 4  :     // USB
                searchPrinterResult = try SMPort.searchPrinter(target: "USB:") as? [PortInfo]
//          case 5  :     // All
            default :
                searchPrinterResult = try SMPort.searchPrinter(target: "ALL:") as? [PortInfo]
            }
        }
        catch {
            // do nothing
        }
            
        guard let portInfoArray: [PortInfo] = searchPrinterResult else {
            self.tableView.reloadData()
            return
        }
        
        let portName:   String = currentSetting?.portName ?? ""
        let modelName:  String = currentSetting?.portSettings ?? ""
        let macAddress: String = currentSetting?.macAddress ?? ""
        
        var row: Int = 0
        
        for portInfo: PortInfo in portInfoArray {
            self.cellArray.add([portInfo.portName, portInfo.modelName, portInfo.macAddress])
            
            if portInfo.portName   == portName  &&
                portInfo.modelName  == modelName &&
                portInfo.macAddress == macAddress {
                self.selectedIndexPath = IndexPath(row: row, section: 0)
            }
            
            row += 1
        }
        
        self.tableView.reloadData()
    }
    
    func didSelectModel(buttonIndex: Int) {
        let cellParam: [String] = self.cellArray[self.selectedIndexPath.row] as! [String]
        
        self.portName   = cellParam[CellParamIndex.portName  .rawValue]
        self.modelName  = cellParam[CellParamIndex.modelName .rawValue]
        self.macAddress = cellParam[CellParamIndex.macAddress.rawValue]
        
        let modelIndex: ModelIndex = ModelCapability.modelIndex(at: buttonIndex - 1)
        
        self.portSettings = ModelCapability.portSettings(at: modelIndex)
        self.emulation = ModelCapability.emulation(at: modelIndex)
        self.selectedModelIndex = modelIndex
        
        let supportedExternalCashDrawer = ModelCapability.supportedExternalCashDrawer(at: modelIndex)!
        switch self.emulation {
        case .escPos?:
            self.paperSizeIndex = .escPosThreeInch
        case .starDotImpact?:
            self.paperSizeIndex = .dotImpactThreeInch
        default:
            self.paperSizeIndex = nil
        }
        
        if (selectedPrinterIndex != 0) {
            self.paperSizeIndex = AppDelegate.settingManager.settings[0]?.selectedPaperSize
        }
        
        if self.paperSizeIndex == nil {
            self.showAlert(title: "Select paper size.",
                           buttonTitles: ["2\" (384dots)", "3\" (576dots)", "4\" (832dots)"],
                           handler: { selectedButtonIndex in
                            self.didSelectPaperSize(buttonIndex: selectedButtonIndex)
            })
        } else {
            if supportedExternalCashDrawer == true {
                self.showAlert(title: "Select CashDrawer Open Status.",
                               buttonTitles: ["High when Open", "Low when Open"],
                               handler: { selectedButtonIndex in
                                self.didSelectCashDrawerOpenActiveHigh(buttonIndex: selectedButtonIndex)
                })
            } else {
                self.saveParams(portName: self.portName,
                                portSettings: self.portSettings,
                                modelName: self.modelName,
                                macAddress: self.macAddress,
                                emulation: self.emulation,
                                isCashDrawerOpenActiveHigh: true,
                                modelIndex: self.selectedModelIndex,
                                paperSizeIndex: self.paperSizeIndex)
            
            }
        }
    }
    fileprivate func saveParams(portName: String,
                                portSettings: String,
                                modelName: String,
                                macAddress: String,
                                emulation: StarIoExtEmulation,
                                isCashDrawerOpenActiveHigh: Bool,
                                modelIndex: ModelIndex?,
                                paperSizeIndex: PaperSizeIndex?) {
        if let modelIndex = modelIndex,
            let paperSizeIndex = paperSizeIndex {
            
            AppDelegate.settingManager.settings[selectedPrinterIndex] = PrinterSetting(portName: portName,
                                                                                       portSettings: portSettings,
                                                                                       macAddress: macAddress,
                                                                                       modelName: modelName,
                                                                                       emulation: emulation,
                                                                                       cashDrawerOpenActiveHigh: isCashDrawerOpenActiveHigh,
                                                                                       selectedPaperSize: paperSizeIndex,
                                                                                       selectedModelIndex: modelIndex)
            
            AppDelegate.settingManager.save()
        } else {
            fatalError()
        }
        
        
    }}
