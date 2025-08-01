// app/models/weather_model/weather_model.dart
class WeatherModel {
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

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      coord: json['coord'] != null ? Coord.fromJson(json['coord']) : null,
      weather:
          (json['weather'] as List<dynamic>?)
              ?.map((e) => Weather.fromJson(e))
              .toList() ??
          [],
      base: json['base'] as String?,
      main: json['main'] != null ? Main.fromJson(json['main']) : null,
      visibility: json['visibility'] as int?,
      wind: json['wind'] != null ? Wind.fromJson(json['wind']) : null,
      rain: json['rain'] != null ? Rain.fromJson(json['rain']) : null,
      clouds: json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null,
      dt: json['dt'] as int?,
      sys: json['sys'] != null ? Sys.fromJson(json['sys']) : null,
      timezone: json['timezone'] as int?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      cod: json['cod'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'coord': coord?.toJson(),
    'weather': weather.map((e) => e.toJson()).toList(),
    'base': base,
    'main': main?.toJson(),
    'visibility': visibility,
    'wind': wind?.toJson(),
    'rain': rain?.toJson(),
    'clouds': clouds?.toJson(),
    'dt': dt,
    'sys': sys?.toJson(),
    'timezone': timezone,
    'id': id,
    'name': name,
    'cod': cod,
  };
}

class Clouds {
  Clouds({required this.all});

  final int? all;

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(all: json["all"]);
  }

  Map<String, dynamic> toJson() => {"all": all};
}

class Coord {
  Coord({required this.lon, required this.lat});

  final double? lon;
  final double? lat;

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(lon: json["lon"], lat: json["lat"]);
  }

  Map<String, dynamic> toJson() => {"lon": lon, "lat": lat};
}

class Main {
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? grndLevel;

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

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: (json['temp'] as num?)?.toDouble(),
      feelsLike: (json['feels_like'] as num?)?.toDouble(),
      tempMin: (json['temp_min'] as num?)?.toDouble(),
      tempMax: (json['temp_max'] as num?)?.toDouble(),
      pressure: json['pressure'] as int?,
      humidity: json['humidity'] as int?,
      seaLevel: json['sea_level'] as int?,
      grndLevel: json['grnd_level'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'temp': temp,
    'feels_like': feelsLike,
    'temp_min': tempMin,
    'temp_max': tempMax,
    'pressure': pressure,
    'humidity': humidity,
    'sea_level': seaLevel,
    'grnd_level': grndLevel,
  };
}

class Rain {
  Rain({required this.the1H});

  final double? the1H;

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(the1H: json["1h"]);
  }

  Map<String, dynamic> toJson() => {"1h": the1H};
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

  factory Sys.fromJson(Map<String, dynamic> json) {
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

  factory Weather.fromJson(Map<String, dynamic> json) {
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
  Wind({required this.speed, required this.deg, required this.gust});

  final double? speed;
  final int? deg;
  final double? gust;
  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: (json["speed"] as num?)?.toDouble(),
      deg: json["deg"] as int?,
      gust: (json["gust"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {"speed": speed, "deg": deg, "gust": gust};
}
