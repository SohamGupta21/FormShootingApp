//
//  ChartView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/18/22.
//

import SwiftUI
//import SwiftUICharts

struct ChartView: View {

    @State var selected = 0
    var colors = [Color.red, Color.yellow]
    var columns = Array(repeating: GridItem(.flexible(), spacing:20), count:2)
    @StateObject var statsViewModel : StatsViewModel = StatsViewModel()

    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        Image("menu")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                //Bar Chart
                
                VStack(alignment: .leading, spacing: 25) {
                    Text("Daily Workout in Hrs")
                        .font(.system(size:22))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 15) {
                        ForEach(statsViewModel.bigChartData){work in
                            
                            VStack{
                                VStack {
                                    
                                    Spacer(minLength: 0)
                                    
                                    if selected == work.id{
                                        Text(String(work.workout_In_Min))
                                            .foregroundColor(Colors().orangeColor)
                                            .padding(.bottom, 5)
                                    }
                                    
                                    RoundShape()
                                        .fill(LinearGradient(gradient: .init(colors: selected == work.id ? colors : [Color.white.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                        .frame(height:statsViewModel.getHeight(value: CGFloat(work.workout_In_Min)))
                                }
                                .frame(height : 220)
                                .onTapGesture {
                                    withAnimation(.easeOut) {
                                        selected = work.id
                                    }
                                }
                                
                                Text(work.day)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            
                        }
                    }
                    
                    
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(10)
                .padding()
                
                HStack {
                    Text("Statistics")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                
                }
                .padding()
                
                // stats Grid...
                LazyVGrid(columns: columns, spacing : 30) {
                    ForEach(statsViewModel.circle_Data){stat in
                        VStack(spacing: 22){
                            HStack{
                                Text(stat.title)
                                    .font(.system(size:22))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer(minLength: 0)
                            }
                            
                            ZStack {
                                Circle()
                                    .trim(from: 0, to: 1)
                                    .stroke(stat.color.opacity(0.05), lineWidth: 10)
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                
                                Circle()
                                    .trim(from: 0, to: (stat.currentData / stat.goal))
                                    .stroke(stat.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                
                                Text(statsViewModel.getPercent(current:stat.currentData, Goal: stat.goal) + " %")
                                    .font(.system(size:22))
                                    .fontWeight(.bold)
                                    .foregroundColor(stat.color)
                                    .rotationEffect(.init(degrees: 90))
                            }
                            .rotationEffect(.init(degrees: -90))
//
//                            Text(statsViewModel.getDec(val: stat.currentData) + " " + statsViewModel.getType(val: stat.title))
//                                .font(.system(size:22))
//                                .foregroundColor(.white)
//                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(15)
                        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                    }
                }
                .padding()
            }

        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct RoundShape : Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
