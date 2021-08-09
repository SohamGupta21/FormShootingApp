//
//  EntryViewModel.swift
//  ShootingApp
//
//  Created by soham gupta on 8/6/21.
//

import Foundation


final class EntryViewModel: ObservableObject {
    @Published var show = false
    @Published var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    func addObserver(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
            self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
        }
    }
}
