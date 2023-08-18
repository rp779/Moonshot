//
//  ScrollingGridStuff.swift
//  Moonshot
//
//  Created by Ross Parsons on 8/11/23.
//

import SwiftUI

struct ScrollingGridStuff: View {
    
    let layout = [
        GridItem(.adaptive(minimum: 80, maximum: 120)),
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: layout) {
                ForEach(0..<1000) {
                    Text("Item \($0)")
                }
            }
        }
    }
}

struct ScrollingGridStuff_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingGridStuff()
    }
}
