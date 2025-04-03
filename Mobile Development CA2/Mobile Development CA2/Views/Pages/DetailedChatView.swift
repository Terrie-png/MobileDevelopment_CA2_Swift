//
//  DetailedChatView.swift
//  Mobile Development CA2
//
//  Created by Student on 27/03/2025.
//

import SwiftUI

struct ChatDetailView: View {
    let user: User
    @State private var messages: [Message] = []
    @State private var newMessageText = ""
    @State private var scrollProxy: ScrollViewProxy? = nil
    @Binding var isVisible : Bool 
    
    // Sample message data model
    struct Message: Identifiable {
        let id = UUID()
        let text: String
        let isCurrentUser: Bool
        let timestamp: Date
    
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            // Header with user info
            VStack(spacing: 8) {
                if user.profileImage.hasPrefix("system:") {
                    Image(systemName: String(user.profileImage.dropFirst(7)))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                } else {
                    Image(user.profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
                
                Text(user.name)
                    .font(.headline)
                
                Text("Online")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            .padding()
           
            

            
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .onAppear {
                    scrollProxy = proxy
                    loadMessages()
                    
                }
                .onChange(of: messages.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
            }
            
            // Message input
            HStack {
                TextField("Type a message...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .padding(10)
                        .background(newMessageText.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .disabled(newMessageText.isEmpty)
                .padding(.trailing)
            }
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(user.name)
                        .font(.headline)
                    Text("Active now")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear{isVisible = false}
    }
    
    // Message bubble view
    struct MessageBubble: View {
        let message: Message
        
        var body: some View {
            HStack {
                if message.isCurrentUser {
                    Spacer()
                }
                
                VStack(alignment: message.isCurrentUser ? .trailing : .leading, spacing: 4) {
                    Text(message.text)
                        .padding(10)
                        .background(message.isCurrentUser ? Color.blue : Color(.systemGray5))
                        .foregroundColor(message.isCurrentUser ? .white : .primary)
                        .cornerRadius(12)
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                if !message.isCurrentUser {
                    Spacer()
                }
            }
        }
    }
    
    // Load sample messages
    private func loadMessages() {
        let sampleMessages = [
            Message(text: "Hey there!", isCurrentUser: false, timestamp: Date().addingTimeInterval(-3600)),
            Message(text: "How are you doing?", isCurrentUser: false, timestamp: Date().addingTimeInterval(-3500)),
            Message(text: "I'm good, thanks! How about you?", isCurrentUser: true, timestamp: Date().addingTimeInterval(-3400)),
            Message(text: "Working on that project we discussed", isCurrentUser: false, timestamp: Date().addingTimeInterval(-3300))
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            messages = sampleMessages
        }
    }
    
    // Send new message
    private func sendMessage() {
        guard !newMessageText.isEmpty else { return }
        
        let newMessage = Message(
            text: newMessageText,
            isCurrentUser: true,
            timestamp: Date()
        )
        
        withAnimation {
            messages.append(newMessage)
        }
        
        newMessageText = ""
        
        // Simulate reply after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let reply = Message(
                text: "Thanks for your message!",
                isCurrentUser: false,
                timestamp: Date()
            )
            withAnimation {
                messages.append(reply)
            }
        }
    }
    
    // Scroll to bottom of messages
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessage = messages.last else { return }
        withAnimation {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}


