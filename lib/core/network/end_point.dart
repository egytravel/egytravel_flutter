class EndPoint {
  static const baseUrl = 'https://egy-travel-89eca3b6683d.herokuapp.com';

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const login = '/api/auth/login';
  static const register = '/api/auth/register';
  static const resetPassword = '/api/auth/reset-password';
  static const forgotPassword = '/api/auth/forgot-password';
  static const verifyOtp = '/api/auth/verify-email';

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
  static String communityPostComments(String id) => '/api/community/posts/$id/comments/';
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
  static const trips = '/api/trips';
  static String tripById(String id) => '/api/trips/$id';

  // ── Flights ───────────────────────────────────────────────────────────────
  static const flightSearch = '/api/flights/search';
  static const flightLocations = '/api/flights/locations';

  // ── Hotels ────────────────────────────────────────────────────────────────
  static const hotelSearch = '/api/hotels/search';

  // ── Bookings ──────────────────────────────────────────────────────────────
  static const bookings = '/api/bookings';
  static const bookingHotel = '/api/bookings/hotel';
  static const bookingFlight = '/api/bookings/flight';

  // ── Favorites ─────────────────────────────────────────────────────────────
  static const favorites = '/api/favorites';
  static String favoriteById(String id) => '/api/favorites/$id';
}