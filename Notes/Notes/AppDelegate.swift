//
//  AppDelegate.swift
//  Notes
//
//  Created by Волнухин Виктор on 01/07/2019.
//  Copyright © 2019 Волнухин Виктор. All rights reserved.
//

import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setOptionsForLogger()
        DDLogInfo(getConfigurationName() + " configuration was powered.")
        DDLogDebug(getServerConfigurationURLDescription())
        return true
    }
    
    /// Установить настройки для логгера
    private func setOptionsForLogger() {
        // Будем использовать через os_log
        DDLog.add(DDOSLogger.sharedInstance)
    }
    
    /// Возвращает наименование запущенной конфигурации
    private func getConfigurationName() -> String {
        
        // Добавлена новая конфигурация "ADHOC", произведенная дублированием конфигурации "DEBUG".
        // Это сделано с целью быстрой проверки задания. Для тестирования необходимо просто запустить приложение.
        // (В "боевом" проекте правильнее было бы дублировать конфигурацию "RELEASE", поскольку
        // это был бы облегченный проект и ближе к пользователю).
        
        #if ADHOC
            return "ADHOC"
        #elseif DEBUG
            return "DEBUG"
        #else
            return "RELEASE"
        #endif
    }
    
    /// Возвращает URL сервера по конфигурации приложения
    private func getServerConfigurationURLDescription() -> String {
        
        // Свойство ServerConfigurationURL задано в Info.plist файле.
        // В зависимости от запущенной конфигурации выдаётся (вымышленный) URL для подключения к серверу.
        //
        // Например, adhoc.notes.yandex.ru, если запущено под конфигурацией Adhoc.
        
        guard let serverConfigurationURL = Bundle.main.infoDictionary?["ServerConfigurationURL"] as? String else {
            return "Server configuration URL wasn't set."
        }
        
        return "For this configuration will use '\(serverConfigurationURL)' URL."
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

