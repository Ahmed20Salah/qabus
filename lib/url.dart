class URLs {
  static final String serverURL = 'https://qatar.qabuss.com';
  static final String about = '/api/qab_page/ABT10023';
  static final String locate = '/api/qab_page/LCT10023';
  static final String terms = '/api/qab_page/TRM10023';
  static final String help = '/api/qab_page/NDH10023';
  static final String qatar = '/api/qab_qatar';
  static final String allCategories = '/api/qab_categories';
  static final String mainCategories = '/api/qab_maincategories';
  static final String businessFromCategory = '/api/qab_categories_business/';
  static final String businessByDistance = '/api/qab_categories_business/';
  static final String areas = '/api/location';
  static final String businessByArea = '/api/qab_categories_business_post/';
  static final String newsCategories = '/api/qab_news_categories';
  static final String news = '/api/qab_news';
  static final String newsSearch = '/api/qab_news_search/';
  static final String newsFromCategory = '/api/qab_news_categories/';
  static final String allOffers = '/api/qab_offers';
  static final String sortOffers = '/api/qab_offer_sort';
  static final String allEvents = '/api/qab_event';
  static final String searchEvents = '/api/qab_event_search';
  static final String login = '/api/login';
  static final String register = '/api/user';
  static final String forgotPassword = '/api/forgotpass';
  static final String updateProfile = '/api/updateprofile/';
  static final String resetPassword = '/api/passwordupdate/';
  static final String loggedInUserDashboard = '/api/qab_user_dashboard/';
  static final String homePage = '/api/qab_home_area';
  static final String topics = '/api/qab_select_category';
  static final String search = '/api/qab_home_search';
  static final String favorite = '/api/qab_qatar_save/';
  static final String addBusiness = '/api/post_qabuss_Addbusiness/';
  static final String editBusiness = '/api/post_qabuss_editbusiness/';
  static final String saveTopics = '/api/post_qabuss_recommend/';
  static String deleteBusiness(String businessId, String userId) {
    return '/api/post_qabuss_Deletebusiness/$userId/BusinessId/$businessId';
  }
  static String addReview(String businessId, String userId) {
    return '/review/$businessId/UserId/$userId';
  }
  static String getFavoriteURL(String userId, String businessId) {
    return '/api/qab_qatar_save_delete/$userId/business/$businessId';
  }
   static String getSingleBusinessURL(String businessId) {
     return '/api/qab_business/$businessId';
   }
}
