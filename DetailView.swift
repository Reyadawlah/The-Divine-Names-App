//
//  DetailView.swift
//  The Divine Names
//
//  Created by Reya Dawlah on 6/12/23.
//

import SwiftUI

struct DetailView: View {
    let num : Int
    @State private var returnView = false
    var body: some View {
        VStack{
            Image("\(num + 1)_back")
                .resizable()
                .scaledToFit()
                .tag(num)
                .padding()
        }
        .navigationBarTitle("Detail")
    }
}

/*struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(num: Scroll_Names.num)
    }
}*/
