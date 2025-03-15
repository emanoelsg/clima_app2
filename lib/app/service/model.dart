class WeatherModel {
    WeatherModel({
        required this.coord,
        required this.weather,
        required this.main,
        required this.clouds,
        required this.dt,
        required this.sys,
        required this.id,
        required this.name,
        required this.cod,
    });

    final Coord? coord;
    final List<Weather> weather;
    final Main? main;
    final Clouds? clouds;
    final int? dt;
    final Sys? sys;
    final int? id;
    final String? name;
    final String? cod;

    factory WeatherModel.fromJson(Map<String, dynamic> json){ 
        return WeatherModel(
            coord: json["coord"] == null ? null : Coord.fromJson(json["coord"]),
            weather: json["weather"] == null ? [] : List<Weather>.from(json["weather"]!.map((x) => Weather.fromJson(x))),
            main: json["main"] == null ? null : Main.fromJson(json["main"]),
            clouds: json["clouds"] == null ? null : Clouds.fromJson(json["clouds"]),
            dt: json["dt"],
            sys: json["sys"] == null ? null : Sys.fromJson(json["sys"]),
            id: json["id"],
            name: json["name"],
            cod: json["cod"],
        );
    }

    Map<String, dynamic> toJson() => {
        "coord": coord?.toJson(),
        "weather": weather.map((x) => x.toJson()).toList(),
        "main": main?.toJson(),
        "clouds": clouds?.toJson(),
        "dt": dt,
        "sys": sys?.toJson(),
        "id": id,
        "name": name,
        "cod": cod,
    };

}

class Clouds {
    Clouds({
        required this.all,
    });

    final int? all;

    factory Clouds.fromJson(Map<String, dynamic> json){ 
        return Clouds(
            all: json["all"],
        );
    }

    Map<String, dynamic> toJson() => {
        "all": all,
    };

}

class Coord {
    Coord({
        required this.lon,
        required this.lat,
    });

    final double? lon;
    final double? lat;

    factory Coord.fromJson(Map<String, dynamic> json){ 
        return Coord(
            lon: json["lon"],
            lat: json["lat"],
        );
    }

    Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
    };

}

class Main {
    Main({
        required this.temp,
        required this.feelsLike,
        required this.tempMin,
        required this.tempMax,
        required this.pressure,
        required this.humidity,
        required this.seaLevel,
        required this.grndLevel,
    });

    final double? temp;
    final double? feelsLike;
    final double? tempMin;
    final double? tempMax;
    final int? pressure;
    final int? humidity;
    final int? seaLevel;
    final int? grndLevel;

    factory Main.fromJson(Map<String, dynamic> json){ 
        return Main(
            temp: json["temp"],
            feelsLike: json["feels_like"],
            tempMin: json["temp_min"],
            tempMax: json["temp_max"],
            pressure: json["pressure"],
            humidity: json["humidity"],
            seaLevel: json["sea_level"],
            grndLevel: json["grnd_level"],
        );
    }

    Map<String, dynamic> toJson() => {
        "temp": temp,
        "feels_like": feelsLike,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "pressure": pressure,
        "humidity": humidity,
        "sea_level": seaLevel,
        "grnd_level": grndLevel,
    };

}

class Sys {
    Sys({
        required this.country,
        required this.sunrise,
        required this.sunset,
    });

    final String? country;
    final int? sunrise;
    final int? sunset;

    factory Sys.fromJson(Map<String, dynamic> json){ 
        return Sys(
            country: json["country"],
            sunrise: json["sunrise"],
            sunset: json["sunset"],
        );
    }

    Map<String, dynamic> toJson() => {
        "country": country,
        "sunrise": sunrise,
        "sunset": sunset,
    };

}

class Weather {
    Weather({
        required this.id,
        required this.main,
        required this.description,
        required this.icon,
    });

    final int? id;
    final String? main;
    final String? description;
    final String? icon;

    factory Weather.fromJson(Map<String, dynamic> json){ 
        return Weather(
            id: json["id"],
            main: json["main"],
            description: json["description"],
            icon: json["icon"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "main": main,
        "description": description,
        "icon": icon,
    };

}
