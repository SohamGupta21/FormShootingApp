import SwiftUI
import Firebase

class ChatViewModel: ObservableObject {
    @Published var txt = ""
    @Published var msgs: [MsgModel] = []
    @AppStorage("current_user") var user = ""
    @Published var ref : CollectionReference
    
    init(teamID : String) {
        ref = Firestore.firestore().collection("teams").document(teamID).collection("Msgs")
        readAllMsgs()
    }
    
    func onAppear() {
        // Checking whether user is joined already
        if user == "" {
            // Join Alert
            UIApplication.shared.windows.first?.rootViewController?.present(alertView(), animated: true)
        }
    }
    
    func alertView() -> UIAlertController {
        let alert = UIAlertController(title: "Join Chat!", message: "Enter Nick Name", preferredStyle: .alert)
        
        alert.addTextField { (txt) in
            txt.placeholder = "e.g. Kavsoft"
        }
        
        let join = UIAlertAction(title: "Join", style: .default) { (_) in
            // checking for empty click
            let user = alert.textFields![0].text ?? ""
            
            if user != "" {
                self.user = user
                return
            }
            
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        }
        
        alert.addAction(join)
        
        return alert
    }
    
    func readAllMsgs() {
        ref.order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            guard let data = snap else { return }
            
            data.documentChanges.forEach { doc in
                if doc.type == .added {
                    let msg = try! doc.document.data(as: MsgModel.self)!
                    
                    DispatchQueue.main.async {
                        self.msgs.append(msg)
                    }
                }
            }
        }
    }
    
    func writeMsg() {
        let msg = MsgModel(msg: txt, user: user, timeStamp: Date())
        
        let _ = try! ref.addDocument(from: msg) { err in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            self.txt = ""
        }
    }
}
