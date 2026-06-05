class EndPoint {
  static const baseUrl = 'https://egy-travel-89eca3b6683d.herokuapp.com';

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const login = '/api/auth/login';
  static const register = '/api/auth/register';
  static const resetPassword = '/api/auth/reset-password';
  static const forgotPassword = '/api/auth/forgot-password';
  static const verifyOtp = '/api/auth/verify-email';
  static const resendOtp = '/api/auth/resend-otp';

  // ── Home / Explore / Booking / AI ────────────────────────────────────────
  static const home = '/api/home/';
  static const explore = '/api/explore/';
  static const booking = '/api/booking/';
  static const tripPlanner = '/api/tripPlanner/';
  static const community = '/api/community';
  static const events = '/api/events';

  // ── Community ─────────────────────────────────────────────────────────────
  static const communityFeed = '/api/community/feed';
  static const communityPosts = '/api/community/posts';
  static String communityPostById(String id) => '/api/community/posts/$id';
  static String communityPostLikes(String id) => '/api/community/posts/$id/like';
  static String communityPostComments(String id) => '/api/community/posts/$id/comments';
  static String communityCommentById(String id) => '/api/community/comments/$id';
  static String communityUserPosts(String id) => '/api/community/users/$id/posts';

  // ── User Profile ──────────────────────────────────────────────────────────
  static const profile = '/api/users/profile';
  static const changePassword = '/api/users/change-password';
  static const deleteAccount = '/api/users/delete-account';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const notifications = '/api/users/notifications';

  // ── Travel History ────────────────────────────────────────────────────────
  static const travelHistory = '/api/users/travel-history';

  // ── Trips ─────────────────────────────────────────────────────────────────
  // 1. Create Trip          → POST   /api/trips
  // 2. Get All My Trips     → GET    /api/trips
  // 3. Get Trip Details     → GET    /api/trips/:id
  // 4. Update Trip          → PUT    /api/trips/:id
  // 12. Delete Trip         → DELETE /api/trips/:id
  static const trips = '/api/trips';
  static String tripById(String id) => '/api/trips/$id';

  // 5. Search Places for Trip → GET /api/home/search?q=<query>
  static String searchPlaces(String query) =>
      '/api/home/search?q=${Uri.encodeQueryComponent(query)}';

  // 6. Add Extra Day to Trip  → POST   /api/trips/:id/days
  // 7. Get All Days           → GET    /api/trips/:id/days
  static String tripDays(String id) => '/api/trips/$id/days';

  // 8. Get Single Day         → GET    /api/trips/:tripId/days/:dayId
  // 9. Update Day             → PUT    /api/trips/:tripId/days/:dayId
  // 10. Delete Day            → DELETE /api/trips/:tripId/days/:dayId
  static String tripDayById(String tripId, String dayId) =>
      '/api/trips/$tripId/days/$dayId';

  // 13. Get Trip Map Markers  → GET  /api/trips/:id/map
  static String tripMapMarkers(String id) => '/api/trips/$id/map';

  // 11. Attach Hotel Booking to Trip → POST /api/bookings/hotel
  static const tripAttachHotel = '/api/bookings/hotel';

  // 14. Add Place to Day (map pin) → POST /api/trips/:tripId/days/:dayId/places
  static String tripDayPlaces(String tripId, String dayId) =>
      '/api/trips/$tripId/days/$dayId/places';

  // 15. Remove Place from Day → DELETE /api/trips/:tripId/days/:dayId/places/:index
  static String tripDayPlaceByIndex(String tripId, String dayId, int index) =>
      '/api/trips/$tripId/days/$dayId/places/$index';

  // ── Flights ───────────────────────────────────────────────────────────────
  static const exploreFlightsApi = '/api/explore/flights';
  static const flightSearch = '/api/flights/search'; // Keep old one if needed, or replace
  static const flightLocations = '/api/flights/locations';

  // ── Hotels ────────────────────────────────────────────────────────────────
  static const hotelSearch = '/api/hotels/search';
  static const exploreHotels = '/api/explore/hotels';

  // ── Bookings ──────────────────────────────────────────────────────────────
  static const bookings = '/api/bookings';
  static const bookingHotel = '/api/bookings/hotel';
  static const bookingFlight = '/api/bookings/flight';

  // ── AI Trip Planner ──────────────────────────────────────────────────────────
  static const aiBaseUrl = 'https://fronic-egydocker.hf.space';
  static const aiPlan = '/plan';
  static const aiChat = '/chat';
  static const saveAiTrip = '/api/ai/save-trip';

  // ── Favorites ─────────────────────────────────────────────────────────────
  static const favorites = '/api/favorites';
  static String favoriteById(String id) => '/api/favorites/$id';
}