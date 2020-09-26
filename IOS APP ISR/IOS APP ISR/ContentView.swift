//
//  ContentView.swift
//  IOS APP ISR
//
//  Created by Alex Vazquez on 26/09/20.
//

import SwiftUI


struct ContentView: View {
    @State private var checkAmount = ""
    @State private var newisr = ""
        var body: some View {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount).keyboardType(.numberPad)
                }
                Section{
                    
                    Text("$\(checkAmount)")
                }
                Section{
                    
                    Button(action: {
                            let result = callHttp(isr: checkAmount)
                            newisr = result
                        
                    }, label: {
                        Text("Make request")
                    })
                }
                Section{
                    Text("\(newisr)")
                }
                }
            }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


func callHttp(isr: String) -> String{
    var r = ""
    var done = false
    var service = "https://isr-urhxsjsspa-uc.a.run.app/ISR/"
    service = service + isr
    let url = URL(string: service)
    guard let requestUrl = url else { fatalError() }
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        if let error = error {
                print("Error took place \(error)")
                return
            }
        
        if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
        
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
            let result = dataString.split(separator: ":")
            let idx = result[1].split(separator: "}")
            print(idx[0])
            r = String(idx[0].replacingOccurrences(of: "\"", with: " "))
            done = true

                
        }
    }
    task.resume()
    repeat {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    } while !done
    return r
}
