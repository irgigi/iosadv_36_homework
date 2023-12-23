//
//  LocalNotificationsService.swift
//  Navigation


import Foundation
import UserNotifications

class LocalNotificationsService {
    
    func request() async throws {
        do {
            if try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                print("разрешение получено")
            }
            
        } catch {
            print("error", error)
            throw error
        }
        
    }
    
    func authorizationEnabled() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus == .authorized 
    }
    
    func authorizationDenied() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus == .denied
    }
    
    func addNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Ежедневное напоминание"
        content.body = "Посмотрите последние обновления"
        content.sound = .default
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Yekaterinburg")!
        
        let currentDate = Date()
        
        var dateComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) {  (error) in
            if let error = error {
                print(error)
            } else {
                print("запрос уведомления добавлен")
            }
        }
    }

}
