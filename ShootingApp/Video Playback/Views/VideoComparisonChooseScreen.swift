//
//  VideoComparisonChooseScreen.swift
//  ShootingApp
//
//  Created by Soham Gupta on 3/15/22.
//

import SwiftUI
import FirebaseFirestore

struct VideoComparisonChooseScreen: View {
    
    @State private var videos : [Video]
    
    @State private var isLoading = true
    
    @State var video1 = Video(date: "", url: "", color: .black)
    
    @State var video2 = Video(date: "", url: "", color: .black)
    
    init() {
        videos = []
    }
    
    var body: some View {
        ZStack{
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            if !isLoading {
                VStack {
                    Heading("Form 1:")
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(0..<videos.count) {num in
                                Button(action: {
                                    video1 = videos[num]
                                }, label: {
                                    VideoCard(videoCardObject: videos[num])
                                })
                            }
                        }
                    }
                    Heading("Form 2:")
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(0..<videos.count) {num in
                                Button(action: {
                                    video2 = videos[num]
                                }, label: {
                                    VideoCard(videoCardObject: videos[num])
                                })
                            }
                        }
                    }
                    
                    
                    NavigationLink(destination: {
                        VideoPlaybackView(video1: self.video1, video2: self.video2)
                    }){
                        Heading("COMPARE")
                    }
                }.padding()
            }
            
            if isLoading {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        .scaleEffect(5)
                }
            }

        }
        .onAppear(perform: {
            Firestore.firestore().collection("videos").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        videos.append(Video(date:document.get("date") as! String, url: document.get("url") as! String, color: .orange))
                        print("\(document.documentID) => \(document.get("url"))")
                    }
                }
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                print("running timer")
                if videos.count > 0{
                    isLoading = false
                    timer.invalidate()
                }
            }
        })
    }
}

struct VideoComparisonChooseScreen_Previews: PreviewProvider {
    static var previews: some View {
        VideoComparisonChooseScreen()
    }
}
