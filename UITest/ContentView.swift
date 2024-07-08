//
//  ContentView.swift
//  UITest
//
//  Created by Kevin Chen on 7/7/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var responseText = "Press the button to fetch data."
    @State private var messages: [ChatMessage] = []
    @State private var userInput = ""
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages.indices, id:\.self) { index in
                            HStack {
                                if messages[index].role == "user" {
                                    Spacer()
                                    Text(messages[index].content).padding().background(Color.blue.opacity(0.2)).cornerRadius(8).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                                } else {
                                    Text(messages[index].content).padding().background(Color.gray.opacity(0.2)).cornerRadius(8).frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                }
                            }.id(index)
                        }
                    }.onChange(of: messages) {_ in scrollToBottom(proxy: proxy)}
                }.onAppear{scrollViewProxy = proxy}
                
                TextField("Enter your message", text: $userInput).padding().background(Color.gray.opacity(0.08)).cornerRadius(8)
                
                Button("Send Message") {
                    fetchData()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastIndex = messages.indices.last {
            withAnimation{proxy.scrollTo(lastIndex, anchor: .bottom)}
        }
    }

    func fetchData() {
        guard !userInput.isEmpty else {
            responseText = "please enter a message."
            return
        }
        
        let userMessage = ChatMessage(role: "user", content: userInput)
        messages.append(userMessage)
        userInput=""
//        let messages = [ChatMessage(role:"user", content: userInput)]
        
        let request = ChatRequest(messages: messages, model: "llama3-8b-8192", temperature: nil, max_tokens: nil, top_p: nil, stream: nil)

        NetworkManager.shared.fetchChatResponse(for: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let responseMessage = response.choices.first?.message {
                        messages.append(responseMessage)
                    }
                case .failure(let error):
                    let errorMessage = ChatMessage(role: "assistant", content: "Error: \(error.localizedDescription)")
                    messages.append(errorMessage)

                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
