import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @Binding var show: Bool
    var body: some View{
        ZStack{
            ZStack(alignment: .topTrailing){
                GeometryReader{_ in
                    VStack {
                        Text("Log In")
                            .font(.title)
                        TextField("Email", text: $loginViewModel.email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius:4).stroke(loginViewModel.email != "" ? Color("Color") : loginViewModel.color, lineWidth: 2))
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
                            .background(RoundedRectangle(cornerRadius:4).stroke(loginViewModel.pass != "" ? Color("Color") : loginViewModel.color, lineWidth: 2))
                            .padding(.top, 25)
                            
                            HStack{
                                Spacer()
                                
                                Button(action:{
                                    loginViewModel.reset()
                                }) {
                                    Text("Forgot password")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.blue)
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
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top, 25)
                    }
                    .padding(.horizontal, 25)
                    
                }
                
                Button(action:{
                    self.show.toggle()
                }){
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                }
                .padding()
            }
            
            if loginViewModel.alert{
                ErrorView(alert: $loginViewModel.alert, error: $loginViewModel.error)
            }
        }
        
    }
}
