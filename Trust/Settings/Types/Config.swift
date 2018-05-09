// Copyright SIX DAY LLC. All rights reserved.

import Foundation

struct Config {

    struct Keys {
        static let chainID = "chainID"
        static let isCryptoPrimaryCurrency = "isCryptoPrimaryCurrency"
        static let isDebugEnabled = "isDebugEnabled"
        static let currencyID = "currencyID"
        static let dAppBrowser = "dAppBrowser"
        static let testNetworkWarningOff = "testNetworkWarningOff"
        static let autoLockOption = "autoLock"
    }

    static let current: Config = Config()

    let defaults: UserDefaults

    init(
        defaults: UserDefaults = UserDefaults.standard
    ) {
        self.defaults = defaults
    }

    var currency: Currency {
        get {
            //If it is saved currency
            if let currency = defaults.string(forKey: Keys.currencyID) {
                return Currency(rawValue: currency)!
            }
            //If ther is not saved currency try to use user local currency if it is supported.
            let avaliableCurrency = Currency.allValues.first { currency in
                return currency.rawValue == Locale.current.currencySymbol
            }
            if let isAvaliableCurrency = avaliableCurrency {
                return isAvaliableCurrency
            }
            //If non of the previous is not working return USD.
            return Currency.USD
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.currencyID) }
    }

    var autoLockOption: AutoLock {
        get {
            let id = defaults.integer(forKey: Keys.autoLockOption)
            guard let autoLock = AutoLock(rawValue: id) else {
                return .disabled
            }
            return autoLock
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.autoLockOption) }
    }

    var chainID: Int {
        get {
            let id = defaults.integer(forKey: Keys.chainID)
            guard id > 0 else { return RPCServer.main.chainID }
            return id
        }
        set { defaults.set(newValue, forKey: Keys.chainID) }
    }

    var isCryptoPrimaryCurrency: Bool {
        get { return defaults.bool(forKey: Keys.isCryptoPrimaryCurrency) }
        set { defaults.set(newValue, forKey: Keys.isCryptoPrimaryCurrency) }
    }

    var server: RPCServer {
        return RPCServer(chainID: chainID)
    }

    var testNetworkWarningOff: Bool {
        get { return defaults.bool(forKey: Keys.testNetworkWarningOff) }
        set { defaults.set(newValue, forKey: Keys.testNetworkWarningOff) }
    }

    var tickersKey: String {
        get {
            return "tickers-" + self.currency.rawValue + "-" + String(self.chainID)
        }
    }
}
