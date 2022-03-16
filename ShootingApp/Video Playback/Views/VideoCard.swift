//
//  VideoCard.swift
//  ShootingApp
//
//  Created by Soham Gupta on 3/15/22.
//

import SwiftUI

struct VideoCard: View {
    
    var videoCardObject : Video
    
    var body: some View {
        VStack{
            Text(videoCardObject.date)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(videoCardObject.color))
        .cornerRadius(10)
    }
}

struct VideoCard_Previews: PreviewProvider {
    static var previews: some View {
        VideoCard(videoCardObject : Video(date: "14/02/2022", url: "hahahdehefeafgknfgk", color: .red))
    }
}


struct Video {
    var date : String
    var url : String
    var color : UIColor
}

