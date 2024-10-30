//
//  FloatingField.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import SwiftUI

struct FloatingField: View {
    @Binding var text: String
    var placeHolder: String
    var secureField: Bool = false
    var keyboardType: UIKeyboardType = .default
    var colors: (bgColor: Color, borderColor: Color, placeholderForeground: Color) = (.white, .white, .gray)
    var icon: String?
    var leftIcon: ImageResource?
    var errorMessage: String? = nil
    var isDisabled: Bool = false
    
    @State private var secure: Bool = true
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                HStack {
                    if let leftIcon = leftIcon {
                        Image(leftIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                            .foregroundColor(.black)
                            .padding(.trailing, 4)
                    }
                    
                    if $text.wrappedValue.isEmpty {
                        Text(placeHolder)
                            .foregroundColor(isDisabled ? colors.placeholderForeground.opacity(0.5) : colors.placeholderForeground)
                            .font(.poppinsRegular(size: 14))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(placeHolder)
                            .foregroundColor(colors.placeholderForeground)
                            .font(.poppinsRegular(size: 14))
                            .scaleEffect(0.75, anchor: .leading)
                            .offset(y: -12)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    
                    Spacer()
                }.padding(.horizontal, 16)
                
                HStack {
                    if let leftIcon = leftIcon {
                        Image(leftIcon)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.black)
                            .scaledToFit()
                            .frame(height: 28)
                            .padding(.trailing, 4)
                            .opacity(0)
                    }
                    
                    VStack {
                        Group {
                            if secureField && secure {
                                SecureField(text: $text) {
                                }
                            } else {
                                TextField(text: $text) {
                                }
                                .keyboardType(keyboardType)
                            }
                        }.foregroundColor(isDisabled ? colors.placeholderForeground.opacity(0.5) : .black)
                        .font(.poppinsRegular(size: 14))
                        .padding(.leading, 16)
                        .offset(y: $text.wrappedValue.isEmpty ? 0 : 4 )
                    }
                    .padding(.trailing, secureField ? 60 : 16)
                }
                
                HStack {
                    Spacer()
                    if secureField {
                        Button {
                            secure.toggle()
                        } label: {
                            Image(systemName: self.secure ? "eye" : "eye.slash")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.black)
                                .frame(width: 24, height: 16)
                                .padding(.trailing, 16)
                        }
                    } else if let icon = icon {
                        Button {
                            text.removeAll()
                        } label: {
                            Image(icon)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.black)
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 16)
                        }
                    }
                }
            }
            .frame(height: 54)
            .background(!isEditing ? colors.bgColor : isDisabled ? colors.bgColor.opacity(0.5) : .white)
            .cornerRadius(4, corners: .allCorners)
            .border((errorMessage ?? "").isEmpty ? (!isEditing ? colors.borderColor :  isDisabled ? colors.borderColor.opacity(0.5) : .black) : Color.red,
                    width: 1,
                    cornerRadius: 4)
            .onTapGesture {
                self.isEditing = true
            }
            .onChange(of: text) { _ in
                self.isEditing = true
            }
            .onSubmit {
                self.isEditing = false
            }
            
            if let errorMessage = errorMessage {
                HStack {
                    Text(errorMessage)
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(Color.red)
                    Spacer()
                }
                .padding(.top, 4)
            }
        }.disabled(isDisabled)
    }
}

struct SelectAccountTypeView: View {
    @Binding var gender: String
    var gendersList: [String]
    var colors: (bgColor: Color, borderColor: Color, placeholderForeground: Color) = (.white, .white, .gray)
    var errorMessage: String? = nil
    @State var isPickerShown: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                HStack {
                        Image(.icHome)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.black)
                            .scaledToFit()
                            .frame(height: 28)
                            .padding(.trailing, 4)
                    
                    if $gender.wrappedValue.isEmpty {
                        Text("Account type")
                            .foregroundColor(colors.placeholderForeground)
                            .font(.poppinsRegular(size: 14))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("Account type")
                            .foregroundColor(colors.placeholderForeground)
                            .font(.poppinsRegular(size: 14))
                            .scaleEffect(0.75, anchor: .leading)
                            .offset(y: -12)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    
                    Spacer()
                }.padding(.horizontal, 16)
                    .onTapGesture {
                        self.isPickerShown = true
                    }
                
                HStack {
                        Image(.icHome)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.black)
                            .scaledToFit()
                            .frame(height: 28)
                            .padding(.trailing, 4)
                            .opacity(0)
                    
                    TextField(text: $gender) {
                    }
                    .foregroundColor(.black)
                    .font(.poppinsRegular(size: 14))
                    .padding(.leading, 16)
                    .offset(y: $gender.wrappedValue.isEmpty ? 0 : 4 )
                    .padding(.trailing, 16)
                }
            }
            .frame(height: 54)
            .background(colors.bgColor)
            .cornerRadius(4, corners: .allCorners)
            .border((errorMessage ?? "").isEmpty ? colors.borderColor : Color.red,
                    width: 1,
                    cornerRadius: 4)
            
            if isPickerShown {
                Picker("Gender", selection: $gender) {
                    ForEach(gendersList, id: \.self) {
                        Text($0)
                            .foregroundColor(Color.black)
                            .font(.poppinsRegular(size: 18))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .onTapGesture {
                    isPickerShown = false
                }
            }
            
            if let errorMessage = errorMessage {
                HStack {
                    Text(errorMessage)
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(Color.red)
                    Spacer()
                }
                .padding(.top, 4)
            }
        }
    }
}

