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
                        Text("Make normal request")
                    })
                }
                Section{
                    
                    Button(action: {
                            let result = callHttpApi(isr: checkAmount)
                            newisr = result
                        
                    }, label: {
                        Text("Make request with api Key")
                    })
                }
                Section{
                    
                    Button(action: {
                            let result = callHttpJwt(isr: checkAmount)
                            newisr = result
                        
                    }, label: {
                        Text("Make request with jwt")
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
    var answer = false
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
                if response.statusCode == 200 {
                    answer = true
                }
            }
        
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
            r = "ERROR"
            if answer {
                let result = dataString.split(separator: ":")
                let idx = result[1].split(separator: "}")
                print(idx[0])
                r = String(idx[0].replacingOccurrences(of: "\"", with: " "))
            }
            done = true

                
        }
    }
    task.resume()
    repeat {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    } while !done
    return r
}

func callHttpApi(isr: String) -> String{
    var r = ""
    var done = false
    var answer = false
    let apiKey = "?key=AIzaSyDswtrLx139yeFuE2qH09cx2_i7e20z6UE"
    var service = "https://isr-test-12d15d55.uc.gateway.dev/ISR/"
    service = service + isr + apiKey
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
                if response.statusCode == 200 {
                    answer = true
                }
            }
        
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
            r = "ERROR"
            if answer {
                let result = dataString.split(separator: ":")
                let idx = result[1].split(separator: "}")
                print(idx[0])
                r = String(idx[0].replacingOccurrences(of: "\"", with: " "))
            }
            done = true

                
        }
    }
    task.resume()
    repeat {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    } while !done
    return r
}

struct AccessToken: Decodable {
    let acces_token: String
}

func callHttpJwt(isr: String) -> String{
    var doneToken = false
    var token: AccessToken = AccessToken.init(acces_token: "")
    let tokenUrl = "https://jwt-acces-token-generator-urhxsjsspa-uc.a.run.app/token"
    let urlToken = URL(string: tokenUrl)
    guard let requestUrlToken = urlToken else { fatalError() }
    var requestToken = URLRequest(url: requestUrlToken)
    requestToken.httpMethod = "GET"
    let taskToken = URLSession.shared.dataTask(with: requestToken) { (data, response, error) in
        
        if let error = error {
                print("Error took place \(error)")
                return
            }
        
        if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
        
        if let data = data {
            print("Response data string:\n \(data)")
            token = try! JSONDecoder().decode(AccessToken.self, from: data)
            print(token)
            print(token.acces_token)
            doneToken = true
            
                
        }
    }
    taskToken.resume()
    repeat {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    } while !doneToken
    var r = ""
    var done = false
    var answer = false
    var service = "https://isr-urhxsjsspa-uc.a.run.app/ISR/"
    service = service + isr
    let url = URL(string: service)
    guard let requestUrl = url else { fatalError() }
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "GET"
    request.addValue(token.acces_token, forHTTPHeaderField: "Authorization")
    print("Request")
    print(request)
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        if let error = error {
                print("Error took place \(error)")
                return
            }
        
        if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
                if response.statusCode == 200 {
                    answer = true
                }
            }
        
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
            r = "ERROR"
            if answer {
                let result = dataString.split(separator: ":")
                let idx = result[1].split(separator: "}")
                print(idx[0])
                r = String(idx[0].replacingOccurrences(of: "\"", with: " "))
            }
            done = true

                
        }
    }
    task.resume()
    repeat {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    } while !done
    return r
}
