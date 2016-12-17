//
//  ViewController.swift
//  PushNotification
//
//  Created by Kokpheng on 12/16/16.
//  Copyright © 2016 KSHRD. All rights reserved.
//

import UIKit

import Firebase
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    var remoteConfig : FIRRemoteConfig?
    @IBOutlet var showLabel : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view, typically from a nib.
        // RemoteConfig
        remoteConfig = FIRRemoteConfig.remoteConfig()
        let remoteConfigSetting = FIRRemoteConfigSettings(developerModeEnabled: true)
        remoteConfig?.configSettings = remoteConfigSetting!
        remoteConfig?.setDefaultsFromPlistFileName("FireSwiftRemoteConfigDefaults")
        
        fetchConfiguration()
        
        // AdMob
        print("Google Mobile Ads SDK version : \(GADRequest.sdkVersion())")
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.adUnitID = "ca-app-pub-2053250789776715/4075049383"
        bannerView.rootViewController = self
        bannerView.load(request)
    }
    override func viewDidAppear(_ animated: Bool) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        NSLog("Subscribed to news topic");
    }
    func fetchConfiguration() {
        print("Before fetch \(remoteConfig?["sampleURL"].stringValue)")
        
        var expirationDuration = 3600
        if (remoteConfig?.configSettings.isDeveloperModeEnabled)! {
            expirationDuration = 0
        }
        
        remoteConfig?.fetch(withExpirationDuration: TimeInterval(expirationDuration), completionHandler: { (status, error) in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig?.activateFetched()
            } else {
                print("Config not fetched")
                print("Error \(error!.localizedDescription)")
            }
        })
        
        print("After fetch \(remoteConfig?["sampleURL"].stringValue)")
        showLabel.text = remoteConfig?["sampleURL"].stringValue
    }

}








