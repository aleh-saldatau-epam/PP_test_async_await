//
//  ContentView.swift
//  Shared
//
//  Created by Oleg Soldatoff on 19.06.21.
//

import SwiftUI

struct ContentView: View {
    let helloWorldString: String = "Hello, %s!"
    let pattern: String = "%s"
    @State var testState: String = "Hello, %s!"
    @State var textFiledName: String = "world"
    var body: some View {
        VStack {
            Text(testState)
                .padding()
            Text("Enter name:")
            TextField("Enter name:", text: $textFiledName)
                .multilineTextAlignment(.center)
                .padding()
            Button("test async ") {
                async {
                    testState = await testMe(name: textFiledName, strToReplace: helloWorldString, pattern: pattern)
                }
            }
            .padding()
        }
        .onAppear {
            async {
                testState = await testMe(name: textFiledName, strToReplace: helloWorldString, pattern: pattern)
            }
        }
    }

    func testMe(name: String, strToReplace: String, pattern: String) async -> String {
        return await withCheckedContinuation({ continuation in
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    let result = strToReplace.replacingOccurrences(of: pattern, with: name)
                    continuation.resume(returning: result)
                }
            }
        })
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}