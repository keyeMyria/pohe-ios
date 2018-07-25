//
//  Weather.swift
//  pohe-ios
//

struct Weather: Codable {
    var main: Main
    var weather: [Content]
}

struct Content: Codable {
    let icon: String
}

struct Main: Codable {
    let temp: Float
    let temp_min: Float
    let temp_max: Float
}

class WeatherModel {
    /// shared
    static let shared = WeatherModel()

    /// 天気アイコン
    enum WeatherIcon: String {
        /// 快晴（日中）
        case clearSkyDay = "01d"
        /// 晴れ（日中）
        case fewCloudsDay = "02d"
        /// くもり（日中）
        case scatteredCloudsDay = "03d"
        /// くもり（日中）
        case brokenCloudsDay = "04d"
        /// 小雨（日中）
        case showerRainDay = "09d"
        /// 雨（日中）
        case rainDay = "10d"
        /// 雷雨（日中）
        case thunderstormDay = "11d"
        /// 雪（日中）
        case snowDay = "13d"
        /// 霧（日中）
        case mistDay = "50d"
        /// 快晴（夜間）
        case clearSkyNight = "01n"
        /// 晴れ（夜間）
        case fewCloudsNight = "02n"
        /// くもり（夜間）
        case scatteredCloudsNight = "03n"
        /// くもり（夜間）
        case brokenCloudsNight = "04n"
        /// 小雨（夜間）
        case showerRainNight = "09n"
        /// 雨（夜間）
        case rainNight = "10n"
        /// 雷雨（夜間）
        case thunderstormNight = "11n"
        /// 雪（夜間）
        case snowNight = "13n"
        /// 霧（夜間）
        case mistNight = "50n"
        
        var image: String? {
            switch self {
            case .clearSkyDay: return "☀️"
            case .fewCloudsDay: return "🌤"
            case .scatteredCloudsDay: return "⛅️"
            case .brokenCloudsDay: return "☁️"
            case .showerRainDay: return "🌧"
            case .rainDay: return "☔️"
            case .thunderstormDay: return "⛈"
            case .snowDay: return "❄️"
            case .mistDay: return "🌁"
            case .clearSkyNight: return "🌃"
            case .fewCloudsNight: return "☁️"
            case .scatteredCloudsNight: return "☁️"
            case .brokenCloudsNight: return "☁️"
            case .showerRainNight: return "🌧"
            case .rainNight: return "☔️"
            case .thunderstormNight: return "⛈"
            case .snowNight: return "❄️"
            case .mistNight: return "🌁"
            }
        }
        
    }
    
    func iconImage(id: String) -> String? {
        guard let weatherIcon = WeatherIcon(rawValue: id) else { return "" }
        return weatherIcon.image
    }
    
}
