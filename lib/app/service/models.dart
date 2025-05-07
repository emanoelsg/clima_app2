class WeatherModel {
    WeatherModel({
        required this.coord,
        required this.weather,
        required this.base,
        required this.main,
        required this.visibility,
        required this.wind,
        required this.rain,
        required this.clouds,
        required this.dt,
        required this.sys,
        required this.timezone,
        required this.id,
        required this.name,
        required this.cod,
    });

    final Coord? coord;
    final List<Weather> weather;
    final String? base;
    final Main? main;
    final int? visibility;
    final Wind? wind;
    final Rain? rain;
    final Clouds? clouds;
    final int? dt;
    final Sys? sys;
    final int? timezone;
    final int? id;
    final String? name;
    final int? cod;

    factory WeatherModel.fromJson(Map<String, dynamic> json){ 
        return WeatherModel(
            coord: json["coord"] == null ? null : Coord.fromJson(json["coord"]),
            weather: json["weather"] == null ? [] : List<Weather>.from(json["weather"]!.map((x) => Weather.fromJson(x))),
            base: json["base"],
            main: json["main"] == null ? null : Main.fromJson(json["main"]),
            visibility: json["visibility"],
            wind: json["wind"] == null ? null : Wind.fromJson(json["wind"]),
            rain: json["rain"] == null ? null : Rain.fromJson(json["rain"]),
            clouds: json["clouds"] == null ? null : Clouds.fromJson(json["clouds"]),
            dt: json["dt"],
            sys: json["sys"] == null ? null : Sys.fromJson(json["sys"]),
            timezone: json["timezone"],
            id: json["id"],
            name: json["name"],
            cod: json["cod"],
        );
    }

    Map<String, dynamic> toJson() => {
        "coord": coord?.toJson(),
        "weather": weather.map((x) => x.toJson()).toList(),
        "base": base,
        "main": main?.toJson(),
        "visibility": visibility,
        "wind": wind?.toJson(),
        "rain": rain?.toJson(),
        "clouds": clouds?.toJson(),
        "dt": dt,
        "sys": sys?.toJson(),
        "timezone": timezone,
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

class Rain {
    Rain({
        required this.the1H,
    });

    final double? the1H;

    factory Rain.fromJson(Map<String, dynamic> json){ 
        return Rain(
            the1H: json["1h"],
        );
    }

    Map<String, dynamic> toJson() => {
        "1h": the1H,
    };

}

class Sys {
    Sys({
        required this.type,
        required this.id,
        required this.country,
        required this.sunrise,
        required this.sunset,
    });

    final int? type;
    final int? id;
    final String? country;
    final int? sunrise;
    final int? sunset;

    factory Sys.fromJson(Map<String, dynamic> json){ 
        return Sys(
            type: json["type"],
            id: json["id"],
            country: json["country"],
            sunrise: json["sunrise"],
            sunset: json["sunset"],
        );
    }

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
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

class Wind {
    Wind({
        required this.speed,
        required this.deg,
        required this.gust,
    });

    final double? speed;
    final int? deg;
    final double? gust;

    factory Wind.fromJson(Map<String, dynamic> json){ 
        return Wind(
            speed: json["speed"],
            deg: json["deg"],
            gust: json["gust"],
        );
    }

    Map<String, dynamic> toJson() => {
        "speed": speed,
        "deg": deg,
        "gust": gust,
    };

}
