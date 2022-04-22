//
//  SwiftUIView.swift
//  
//
//  Created by Vong Nyuksoon on 17/04/2022.
//
import SwiftUI

struct SampleHalfModalView: View {
    @State private var presented = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Tap") { presented = true }
            }
            
            .navigationTitle("asd")
        }
        .sheet(
            isPresented: $presented,
            detents: [.medium(),.large()],
            cornerRadius: 50.0,
            showGrabber: false, content: {
                Text("Detail")
            })
    }
}

struct SampleHalfModalView_Previews: PreviewProvider {
    static var previews: some View {
        SampleHalfModalView()
    }
}
