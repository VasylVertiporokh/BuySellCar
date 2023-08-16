//
//  SendEmailView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 14/08/2023.
//

import SwiftUI

struct SendEmailView: View {
    // MARK: - View model
    @StateObject var viewModel: SendEmailViewModel
    
    // MARK: - Body
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                container
            }
            Spacer()
            primaryButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            viewModel.onViewDidLoad()
        }
        .alert(item: $viewModel.alert, content: { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .cancel(Text(alert.buttonTitle), action: {
                    alert.action?()
                })
            )
        })
    }
}

// MARK: - Private extenison subviews
private extension SendEmailView {
    var container: some View {
        VStack(spacing: Constant.defaultSpacing) {
            headerButtonView
            senderDataView
        }
        .padding(.horizontal, Constant.borderWidth)
    }
    
    var headerButtonView: some View {
        HStack(alignment: .center) {
            Button(Constant.cancelButtonTitle) {
                viewModel.cancelSending()
            }
            
            Spacer()
            Text(Constant.titleLabel)
            
            Spacer()
            Button(Constant.primaryButtonTitle) {
                viewModel.sendEmail()
            }
            .font(FontFamily.Montserrat.semiBold.swiftUIFont(fixedSize: 16))
        }
        .font(FontFamily.Montserrat.regular.swiftUIFont(fixedSize: 16))
        .foregroundColor(Colors.buttonDarkGray.swiftUIColor)
        .padding([.top],  Constant.defaultSpacing)
    }
    
    var senderDataView: some View {
        VStack(alignment: .center, spacing: Constant.defaultSpacing) {
            emailMassageTextView
            tradeInView
            addRoundedTextField(placeholder: "Your name", text: $viewModel.name)
            addRoundedTextField(placeholder: "Your e-mail", text: $viewModel.email)
            addRoundedTextField(placeholder: "You phone number - optional", text: $viewModel.phoneNumber)
        }
    }
    
    var emailMassageTextView: some View {
        TextEditor(text: $viewModel.emailBody)
            .hideBackground()
            .padding(.horizontal, Constant.traidInHorisontalPadding)
            .font(FontFamily.Montserrat.regular.swiftUIFont(fixedSize: 14))
            .background(Color.white.cornerRadius(Constant.defaultCornerRadius))
            .frame(height: Constant.textEditorHeight)
            .overlay(
                RoundedRectangle(cornerRadius: Constant.defaultCornerRadius)
                    .stroke(Color.gray, lineWidth: Constant.borderWidth)
            )
    }
    
    var tradeInView: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: Constant.tradeInLabelStackViewSpacing) {
                tradeInLabelStackView
                Text("I am interested in trading in my car.")
                    .frame(width: Constant.tradeInViewLabelWidth)
                    .font(FontFamily.Montserrat.regular.swiftUIFont(fixedSize: 12))
            }
            Spacer()
            Toggle(String(), isOn: $viewModel.isTradeIn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Colors.buttonDarkGray.swiftUIColor))
        }
        .padding([.horizontal], Constant.traidInHorisontalPadding)
        .padding([.vertical], Constant.traidInVerticalPadding)
        .frame(maxWidth: .infinity)
        .background(Color.white.cornerRadius(Constant.defaultCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Constant.defaultCornerRadius)
                .stroke(Color.gray, lineWidth: Constant.borderWidth)
        )
    }
    
    var tradeInLabelStackView: some View {
        HStack(spacing: Constant.tradeInLabelStackViewSpacing) {
            Text("Trade-In")
                .font(FontFamily.Montserrat.semiBold.swiftUIFont(fixedSize: 12))
            Text("New")
                .padding([.horizontal], Constant.newLabelHorisontalPadding)
                .padding([.vertical], Constant.newLabelVerticalPadding)
                .font(FontFamily.Montserrat.regular.swiftUIFont(fixedSize: 12))
                .background(Colors.buttonYellow.swiftUIColor.cornerRadius(Constant.newLabelCornerRadius))
        }
    }
        
    var primaryButton: some View {
        Button {
            viewModel.sendEmail()
        } label: {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text(Constant.primaryButtonTitle)
                        .font(FontFamily.Montserrat.semiBold.swiftUIFont(fixedSize: 14))
                        .foregroundColor(Colors.buttonDarkGray.swiftUIColor)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constant.primaryButtonHeight)
            .background(Colors.buttonYellow.swiftUIColor)
            .cornerRadius(Constant.defaultCornerRadius)
        }
    }
    
    var textView: some View {
        Text(Constant.primaryButtonTitle)
            .font(FontFamily.Montserrat.semiBold.swiftUIFont(fixedSize: 14))
            .foregroundColor(Colors.buttonDarkGray.swiftUIColor)
    }
    
    func addRoundedTextField(placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .disabled(true)
            .padding(Constant.defaultCornerRadius)
            .foregroundColor(Color.black)
            .font(FontFamily.Montserrat.regular.swiftUIFont(fixedSize: 14))
            .frame(maxWidth: .infinity)
            .background(Color.white.cornerRadius(Constant.defaultCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Constant.defaultCornerRadius)
                    .stroke(Color.gray, lineWidth: Constant.borderWidth)
            )
    }
}

// MARK: - Constant
private enum Constant {
    static let defaultSpacing: CGFloat = 16
    static let defaultCornerRadius: CGFloat = 8
    static let newLabelCornerRadius: CGFloat = 4
    static let borderWidth: CGFloat = 1
    static let textEditorHeight: CGFloat = 150
    static let tradeInViewLabelWidth: CGFloat = 177
    static let primaryButtonHeight: CGFloat = 47
    static let newLabelHorisontalPadding: CGFloat = 12
    static let newLabelVerticalPadding: CGFloat = 4
    static let traidInHorisontalPadding: CGFloat = 8
    static let traidInVerticalPadding: CGFloat = 12
    static let tradeInLabelStackViewSpacing: CGFloat = 4
    static let titleLabel: String = "Contact seller"
    static let primaryButtonTitle: String = "Send"
    static let cancelButtonTitle: String = "Cancel"
}
