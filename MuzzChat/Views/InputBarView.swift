//
//  InputBarView.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import SwiftUI

struct InputBarView: View {
    @Binding var text: String
    let onSend: () -> Void
    
    @State private var textHeight: CGFloat = 36
    @FocusState private var isFocused: Bool
    
    private let minHeight: CGFloat = 36
    private let maxHeight: CGFloat = 120
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 12) {
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text("Message Alisha")
                            .foregroundColor(Color(.systemGray3))
                            .font(.system(size: 16))
                            .padding(.leading, 16)
                    }
                    
                    TextEditor(text: $text)
                        .font(.system(size: 16))
                        .frame(height: max(minHeight, min(textHeight, maxHeight)))
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .padding(.horizontal, 8)
                        .focused($isFocused)
                        .onChange(of: text) { _ in
                            updateTextHeight()
                        }
                }
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
                
                Button(action: {
                    onSend()
                    textHeight = minHeight
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                                       Color.gray.opacity(0.3) :
                                       Color(red: 0.95, green: 0.35, blue: 0.45))
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }
    
    // MARK: - Helper Methods
    private func updateTextHeight() {
        let size = CGSize(width: UIScreen.main.bounds.width - 100, height: .infinity)
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16)]
        let estimatedSize = NSString(string: text).boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        
        textHeight = max(minHeight, min(estimatedSize.height + 16, maxHeight))
    }
}

// MARK: - Preview
struct InputBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            InputBarView(text: .constant(""), onSend: {})
        }
    }
}
