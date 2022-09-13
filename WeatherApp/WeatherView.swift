//
//  ContentView.swift
//  WeatherApp
//
//  Created by Jordan H on 9/2/22.
//

import SwiftUI

struct Day {
    let id = UUID()
    let name: String
    var temp: Int
    var image: String
}

struct City {
    let id = UUID()
    let city: String
    let state: String?
    let country: String?
}

struct WeatherView: View {
    @State private var isNight = false
    @State private var isLoading = false
    let cities = [City(city: "Philadelphia", state: nil, country: nil),
                  City(city: "Naples", state: "FL", country: nil),
                  City(city: "Naples", state: nil, country: nil),
                  City(city: "London", state: nil, country: "UK"),
                  City(city: "New York", state: nil, country: nil),
                  City(city: "Iqaluit", state: nil, country: nil),
                  City(city: "Portland", state: nil, country: nil)]
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(isNight: $isNight)
                VStack {
                    TabView {
                        ForEach(cities, id: \.id) { city in
                            CityWeather(isNight: $isNight, city: city.city, state: city.state)
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page)
                    Spacer()
                    NavigationLink(destination: NewView(color: .blue), label: {
                        WeatherButton(text: "Next Screen",
                                      textColor: .blue,
                                      backgroundColor: .white)
                    })
                    Spacer()
                    Button {
                        startLoading()
                        isNight.toggle()
                    } label: {
                        WeatherButton(text: "Change Time",
                                      textColor: .blue,
                                      backgroundColor: .white)
                    }
                }
                if isLoading {
                    LoadingView(backgroundColor: Color(.systemBackground),
                                loadColor: .red,
                                opacity: 0.7)
                }
            }
        }
        .accentColor(Color(.label))
    }
    
    func startLoading() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

struct NewView: View {
    var color: Color
    
    var body: some View {
        VStack {
            CircleNumberView(color: color, number: 24)
                .padding()
            NavigationLink(destination: Text("Other Screen"), label: {
                Text("Next Screen 2")
            })
        }
    }
}

struct CircleNumberView: View {
    var color: Color
    var number: Int
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(color)
            Text("\(number)")
                .foregroundColor(.white)
                .font(.system(size: 70, weight: .bold))
        }
    }
}

struct DayView: View {
    var day: String
    var image: String
    var temp: Int
    
    var body: some View {
        VStack(spacing: 2) {
            Text(day)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            Image(systemName: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temp)°")
                .font(.system(size: 28, weight: .medium, design: .default))
                .foregroundColor(.white)
        }
    }
}

struct BackgroundView: View {
    @Binding var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? .gray : Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {
    var city: String
    
    var body: some View {
        Text(city)
            .font(.system(size: 32, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            //.background(.red)
            .padding()
    }
}

struct MainView: View {
    var image: String
    var temp: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            Text("\(temp)°")
                .font(.system(size: 70, weight: .medium, design: .default))
                .foregroundColor(.white)
        }
        .padding(.bottom, 50)
    }
}

struct LoadingView: View {
    var backgroundColor: Color
    var loadColor: Color
    var opacity: Double
    
    var body: some View {
        ZStack {
            Color(UIColor(backgroundColor)) //.systemBackground
                .ignoresSafeArea()
                .opacity(opacity)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: loadColor))
                .scaleEffect(4)
        }
    }
}

/*
 https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/[location]/[date1]/[date2]?key=LJAW8PCX8UU6S4BTWHFX6CWSK
 
 https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Philadelphia,PA/next5days?unitGroup=us&key=LJAW8PCX8UU6S4BTWHFX6CWSK
 
 */

struct CityWeather: View {
    
    struct WeatherData: Decodable {
        let resolvedAddress: String
        let days: [WeatherDays]
    }
    
    struct WeatherDays: Decodable {
        let datetime: String
        let conditions: String
        let tempmax: Double
        let tempmin: Double
        let temp: Double
    }
    
    @Binding var isNight: Bool
    @State var city: String
    @State var state: String?
    @State var country: String?
    @State var weather: WeatherData?

    let days = [
        Day(name: "TUE", temp: 62, image: "cloud.sun.fill"),
        Day(name: "WED", temp: 63, image: "sun.max.fill"),
        Day(name: "THU", temp: 64, image: "wind"),
        Day(name: "FRI", temp: 65, image: "cloud.rain.fill"),
        Day(name: "SAT", temp: 66, image: "snow")]
    let weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    var conditionsDay = ["Rain": "cloud.rain.fill",
                         "Overcast": "cloud.fill",
                         "Partially cloudy": "cloud.sun.fill",
                         "Clear": "sun.max.fill",
                         "Snow": "snow"]
    var conditionsNight = ["Rain": "cloud.rain.fill",
                           "Overcast": "cloud.fill",
                           "Partially cloudy": "cloud.moon.fill",
                           "Clear": "moon.fill",
                           "Snow": "snow"]

    var body: some View {
        VStack {
            CityTextView(city: city + (state == nil && country == nil ? "" : (", " + (country == nil ? state! : (state == nil ? country! : (country! == "United States" ? state! : country!))))))
                .navigationTitle("Test Title")
                .navigationBarHidden(true)
            if weather == nil {
                MainView(image: days[0].image, temp: days[0].temp)
            } else {
                let day = weather!.days[0]
                let cond = day.conditions.components(separatedBy: ", ")[0]
                MainView(image: (isNight ? conditionsNight[cond] : conditionsDay[cond])!, temp: Int(round(day.temp)))
            }
            HStack(spacing: 20) {
                if weather == nil {
                    ForEach(days, id: \.id) { day in
                        DayView(day: day.name, image: day.image, temp: day.temp)
                    }
                } else {
                    ForEach((1...5), id: \.self) {
                        let day = weather!.days[$0]
                        let i = Calendar.current.component(.weekday, from: Date(day.datetime))
                        let cond = day.conditions.components(separatedBy: ", ")[0]
                        DayView(day: weekdays[i - 1], image: (isNight ? conditionsNight[cond] : conditionsDay[cond])!, temp: Int(round(day.temp)))
                    }
                }
            }
        }
        .onAppear {
            getWeather()
        }
    }
    
    func getWeather() {
        let session = URLSession.shared
        let locStr = city + (state == nil ? "" : "," + state!) + (country == nil ? "" : "," + country!)
        let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/" + locStr.replacingOccurrences(of: " ", with: "%20") + "/next5days?unitGroup=us&key=LJAW8PCX8UU6S4BTWHFX6CWSK")!
        
        let weatherTask = session.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else { return }
            
            weather = try! JSONDecoder().decode(WeatherData.self, from: data)
            
            let loc = weather!.resolvedAddress.components(separatedBy: ", ")
            city = loc[0]
            if loc.count == 2 {
                country = loc[1]
            } else if loc.count >= 3 {
                state = loc[1]
                country = loc[2]
            }
        }
        weatherTask.resume()
    }
}

extension Date {
    init(_ dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval: 0, since: date)
    }
}
