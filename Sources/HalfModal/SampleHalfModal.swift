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
        VStack {
            HalfModal(content: {
                Text("Detail")
            }, isPresented: $presented, detents: [.medium(), .large()], selectedDetentIdentifier: .large, cornerRadius: 50.0, showGrabber: true)
            
            Button("Tap") { presented = true }
        }
    }
}

struct SampleHalfModalView_Previews: PreviewProvider {
    static var previews: some View {
        SampleHalfModalView()
    }
}
