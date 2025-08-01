//
//  ContentView.swift
//  ImglyBugs
//
//  Created by Hakim Gulam Ali on 01/08/25.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.router) var router
	let videoURL = URL(string: "https://cdn.img.ly/assets/demo/v2/ly.img.video/videos/pexels-drone-footage-of-a-surfer-barrelling-a-wave-12715991.mp4")!
	
    var body: some View {
        VStack {
			Button("Hello, world!"){
				router.navigateToVideoPreview(url: videoURL)
			}
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
