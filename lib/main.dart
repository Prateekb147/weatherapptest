import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weatherapp/services/city_suggestions.dart';
import 'services/api_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen ({super.key});
  @override
  WeatherScreenState createState() => WeatherScreenState();
}

  class WeatherScreenState extends State<WeatherScreen> {
    final ApiServices api = ApiServices();
    Map<String, dynamic> ? weatherData;
    final TextEditingController cityController = TextEditingController();

    void fetchWeather() async {
      final data = await api.getWeather(cityController.text);
      setState(() {
        weatherData = data;
      });
    }

    String getWeatherImage(String condition) {
      condition = condition.toLowerCase();

      if (condition.contains("clear")) return "lib/assets/weather/clear.jpg";
      if (condition.contains("cloud")) return "lib/assets/weather/clouds.jpg";
      if (condition.contains("rain")) return "lib/assets/weather/rain.jpg";
      if (condition.contains("snow")) return "lib/assets/weather/snow.jpg";
      if (condition.contains("mist") || condition.contains("haze")) return "lib/assets/weather/haze.jpg";
      if (condition.contains("thunderstorm")) return "lib/assets/weather/thunderstorms.jpg";    
      
      return "lib/assets/weather/clear.jpg";
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 38,
            color: Colors.black
          ),),
          centerTitle: true),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.9,
              child: Image.asset(
                weatherData == null
                  ? "lib/assets/weather/clear.jpg"
                  : getWeatherImage(weatherData!["weather"][0]["main"]),

                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children:[
              TypeAheadField<String>(
                controller: cityController,
                suggestionsCallback: (pattern) async {
                  return await CitySuggestionService.fetchCities(pattern);
                },

                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Center (
                      child: Text(
                        suggestion,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center
                    )),
                  );
                },

                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: "Enter City",
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder()
                    ),
                    textAlign: TextAlign.center,
                  );
                },

                onSelected: (value) {
                  cityController.text = value;
                  fetchWeather();
                }),

              SizedBox(height: 10),

              ElevatedButton(
                onPressed: fetchWeather,
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black87,
                ),
                child: Text("Get Weather",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
                )),
              ),

              SizedBox(height:20),

              weatherData == null
              ? Text("Enter A City Above")
              : Column(
                children: [
                  Text(weatherData!["name"],
                  style: TextStyle(fontSize: 28),
                  ),
                  Text(
                    "${weatherData!["main"]["temp"]}°C",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weatherData!["weather"][0]["description"],
                    style: TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ]
              )
            ],
          ),
        ),
       ]
    ));
  }
}

