//
//  LockScreen.swift
//  CustomPinScreen
//
//  Created by Natalia on 11/15/24.
//

import SwiftUI

struct LockScreen: View {
    
    @State var password = ""
    
    // You can change it when user clicks reset password...
    // Appstorage => UserDefaults....
    @AppStorage("lock_password") var key = "1234"
    
    @Binding var unlocked: Bool
    @State var wrongPassword = false

    @State private var image: UIImage = UIImage(named: "background")!
    
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        
        ZStack{
            
            BluredScreen(image: image)
                .opacity(0.9)
            
            VStack {
                Spacer()
                
                Image(systemName: "lock.fill")
                    .resizable()
                    .frame(width: 12, height: 18)
                    .padding(.top, 15)
                    .foregroundStyle(.white)
                
                Spacer(minLength: 0)
                
                Text("Enter Passcode")
                    .font(.title2)
                    .padding(.top, 20)
                    .foregroundStyle(.white)
                
                HStack(spacing: 22) {
                    
                    ForEach(0..<4, id: \.self) { index in
                        PasswordView(
                            index: index,
                            password: self.$password,
                            key: self.$key,
                            unlocked: self.$unlocked,
                            wrongPassword: self.$wrongPassword
                        )
                    }
                    
                }
                .padding(.top, 15)
                
                Spacer(minLength: 0)
                
                Text(self.wrongPassword ? "Incorrect Passcode" : "")
                    .foregroundColor(.white)
                
                Spacer(minLength: 0)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                    
                    ForEach(1...9, id: \.self) { value in
                        PasswordButton(
                            value: "\(value)",
                            password: self.$password,
                            key: self.$key,
                            unlocked: self.$unlocked,
                            wrongPassword: self.$wrongPassword
                        )
                    }
                    
                    PasswordButton(
                        value: "delete.fill",
                        password: self.$password,
                        key: self.$key,
                        unlocked: self.$unlocked,
                        wrongPassword: self.$wrongPassword
                    ).opacity(0)
                    
                    PasswordButton(
                        value: "0",
                        password: self.$password,
                        key: self.$key,
                        unlocked: self.$unlocked,
                        wrongPassword: self.$wrongPassword
                    )
                    
                }
                .padding(.top, 0)
                .padding(.bottom, 120)
                .padding(.leading, 50)
                .padding(.trailing, 50)
                
                Spacer(minLength: 0)
                
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }.ignoresSafeArea(.all)
}

struct PasswordView: View {
    
    var index: Int
    
    @Binding var password: String
    @Binding var key: String
    @Binding var unlocked: Bool
    @Binding var wrongPassword: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 12, height: 12)
            
            // checking wheter it is typed...
            
            if self.password.count > self.index {
                Circle()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
            }
            
        } //: ZSTACK
    }
    
}

struct PasswordButton: View {
    
    var value: String
    
    @State private var didTap: Bool = false
    
    @Binding var password: String
    @Binding var key: String
    @Binding var unlocked: Bool
    @Binding var wrongPassword: Bool
    
    var body: some View {
        
        Button (action: {
            //self.didTap = true
            self.setPassword()
        }, label: {
            
            VStack {
                
                if self.value.count > 1 {
                    // Image ...
                    ZStack {
                        Circle()
                            .background(Circle())
                            .frame(width: 75, height: 75)
                            .foregroundColor(didTap ? .white : .gray).opacity(0.3)
                        
                        Image(systemName: "delete.left")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                } else {
                    ZStack {
                        Circle()
                            .background(Circle())
                            .frame(width: 75, height: 75)
                            .foregroundColor(didTap ? .white : .gray).opacity(0.3)

                        Text(self.value)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    
                }
            } //: VSTGACK
            .padding(.top, 0)
            .padding(.bottom, 0)
            .padding(.leading, 0)
            .padding(.trailing, 0)
            
        })
    }
    
    func setPassword() {
        
        withAnimation {
            
            // checking if backspace pressed...
            if self.value.count > 1 {
                if self.password.count != 0 {
                    self.password.removeLast()
                }
            } else {
                if self.password.count != 4 {
                    self.password.append(self.value)
                    
                    // Delay Animation...
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            if self.password.count == 4 {
                                if self.password == self.key {
                                    self.unlocked = true
                                } else {
                                    self.wrongPassword = true
                                    //self.password.removeAll()
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
    }
}
}
