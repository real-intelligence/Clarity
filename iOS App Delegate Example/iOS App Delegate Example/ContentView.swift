//
//  ContentView.swift
//  iOS App Delegate Example
//
// Copyright (c) 2021 Lawrence Heyfron (http://realint.org/)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SwiftUI
import Clarity_iOS


struct MyViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        print(310, functionName: #function)
        print(311)
        let colour1 = Color.red
        let colour2 = Color.yellow
        let myWorldColors = [colour1,colour2]
        
        content
            .padding()
            .background(colour1)
            .foregroundColor(colour2)
            .font(.largeTitle)
            .cornerRadius(25)
        
        print(312, values: myWorldColors)
        myGuardDemonstration()
    }
    
    
    func myGuardDemonstration()-> some View {
        // Assign ignored return where there is an explicit return of a View
        _ = print(315, functionName: #function)
        
        let myEmptyView: Any? = nil
        
        guard myEmptyView != nil else {
            _ = print(316)
            
            return  EmptyView()
        }
        _ = print(317)
        return EmptyView()
    }
}



struct ContentView: View {
    var body: some View {
        print(300, functionName: #function)
        print(301)
        print(302)
        HStack{
            print(303)
            Text("Hello").font(.title).fontWeight(.light).bold().foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Text("world").modifier(MyViewModifier())
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
