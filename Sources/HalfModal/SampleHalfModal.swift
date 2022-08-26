//
//  SwiftUIView.swift
//  
//
//  Created by Vong Nyuksoon on 17/04/2022.
//
import SwiftUI

struct SampleHalfModalView: View {
    @State private var presented = false
    
    private func onDismissed() {
        print("Dismissed")
    }
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Button("Tap") { presented = true }
                }
            }
            .sheet(
                isPresented: $presented,
                detent: .medium,
                onDismiss: onDismissed,
                content: {
                    Text("Detail")
                }
            )
//            HalfModalView14(
//                content: { Text("Content") },
//                isPresented: $presented, detent: .large) {
//                print("Dismissed")
//            }
            
        }
        //        if #available(iOS 15.0, *) {
        //            NavigationView {
        //                VStack {
        //                    Button("Tap") { presented = true }
        //                }
        //
        //                .navigationTitle("asd")
        //            }
        //            .sheet(
        //                isPresented: $presented,
        //                detents: [.medium(),.large()],
        //                cornerRadius: 50.0,
        //                showGrabber: false, content: {
        //                    Text("Detail")
        //                })
        //        } else {
        //
        ////            // Fallback on earlier versions
        ////            NavigationView {
        ////                VStack {
        ////                    Button("Tap 14") { presented = true }
        ////                }
        ////
        ////                .navigationTitle("asd")
        ////            }
        ////            .sheet(isPresented: $presented, detent: .medium) {
        ////
        ////            }
        //        }
    }
}

struct SampleHalfModalView_Previews: PreviewProvider {
    static var previews: some View {
        SampleHalfModalView()
    }
}
