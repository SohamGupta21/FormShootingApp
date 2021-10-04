import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @Binding var show: Bool
    var colors = Colors()
    var body: some View{
        ZStack{
            ZStack(alignment: .topTrailing){
                //            Photo by <a href="https://unsplash.com/@solarfri?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Mira Kireeva</a> on <a href="https://unsplash.com/s/photos/basketball?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
                GeometryReader { geo in
                    Image("man-layup")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width)
                        .edgesIgnoringSafeArea(.all)
                }
                GeometryReader{geometry in
                    VStack {
                        ZStack{
//                            RoundedRectangle(cornerRadius: 50)
//                                .fill(colors.whiteColor)
//                                .frame(width:200, height:50)
                            Text("Log In")
                                .font(.title)
                                .foregroundColor(colors.whiteColor)
                                .cornerRadius(50)
                        }
                        
                        TextField("Email", text: $loginViewModel.email)
                            .autocapitalization(.none)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
                            )
                            .padding(.top, 25)
                            HStack{
                                VStack{
                                    if loginViewModel.visible{
                                        TextField("Password", text:$loginViewModel.pass)
                                            .autocapitalization(.none)
                                    } else {
                                        SecureField("Password", text: $loginViewModel.pass)
                                            .autocapitalization(.none)
                                    }
                                    
                                }
                                Button(action: {
                                    loginViewModel.visible.toggle()
                                }) {
                                    Image(systemName: loginViewModel.visible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(loginViewModel.color)
                                }

                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
                            )
                            .padding(.top, 25)
                            
                            HStack{
                                Spacer()
                                
                                Button(action:{
                                    loginViewModel.reset()
                                }) {
                                    Text("Forgot password")
                                        .fontWeight(.bold)
                                        .foregroundColor(colors.whiteColor)
                                }
                            }
                            .padding(.top, 20)
                            
                            Button(action: {
                                loginViewModel.verify()
                            }) {
                                Text("Log in")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                            }
                            .background(colors.orangeColor)
                            .cornerRadius(50)
                            .padding(.top, 25)
                    }
                    .padding(.horizontal)
                    .frame(height:geometry.size.height/1.5)
                }
                Button(action:{
                    self.show.toggle()
                }){
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundColor(colors.whiteColor)
                }
                .padding()
                
             
            }
            
            if loginViewModel.alert{
                ErrorView(alert: $loginViewModel.alert, error: $loginViewModel.error)
            }
        }
    }
}

struct LoginView_Previews : PreviewProvider {
    static var previews: some View {
        LoginView(show: .constant(false))
    }
}

