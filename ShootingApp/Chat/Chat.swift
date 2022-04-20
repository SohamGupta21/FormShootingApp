//
//  Home.swift
//  FirebaseGlobalChat
//
//  Created by Ginger on 29/12/2020.
//

import SwiftUI

struct Chat: View {
    @StateObject var chatViewModel : ChatViewModel
    @AppStorage("current_user") var user = ""
    @State var scrolled = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Global Chat")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color("Color"))
            
            ScrollViewReader { reader in
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(chatViewModel.msgs) { msg in
                            ChatRow(chatData: msg)
                                .onAppear {
                                    // First Time SCroll
                                    if msg.id == self.chatViewModel.msgs.last!.id && !scrolled {
                                        reader.scrollTo(chatViewModel.msgs.last!.id, anchor: .bottom)
                                        scrolled = true
                                    }
                                }
                            
                        }
                        .onChange(of: chatViewModel.msgs) { (value) in
                            // You can restrict only for current user scroll
                            reader.scrollTo(chatViewModel.msgs.last!.id, anchor: .bottom)
                        }
                    }
                    .padding(.vertical)
                }
            }
            
            HStack(spacing: 15) {
                TextField("Enter Message", text: $chatViewModel.txt)
                    .padding(.horizontal)
                    // Fixed Height For Animation
                    .frame(height: 45)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
                
                if chatViewModel.txt != "" {
                    Button(action: chatViewModel.writeMsg) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color("Color"))
                            .clipShape(Circle())
                    }
                }
            }
            .animation(.default)
            .padding()
        }
        .onAppear(perform: {
            chatViewModel.onAppear()
        })
        .ignoresSafeArea(.all, edges: .top)
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Chat()
//    }
//}
