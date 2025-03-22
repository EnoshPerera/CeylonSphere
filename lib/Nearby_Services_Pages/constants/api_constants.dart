// API Keys and Constants
const String apiKey = 'AIzaSyCVfTD2d0MpsavYWK85sQgjF5GSw8QZSRA';

// Place Types
const Map<String, String> placeTypes = {
  'Restaurants': 'restaurant',
  'Hotels': 'lodging',
  'Shopping': 'shopping_mall',
  'Tourist Spots': 'tourist_attraction',
  'Grocery': 'supermarket',
  'Liquor Stores': 'liquor_store',
};

// Default Location (Center of Sri Lanka)
const defaultLocation = {
  'latitude': 7.8731,
  'longitude': 80.7718,
};

class ApiConstants {
  static const String placesBaseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
  static const String directionsBaseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
} 