class APIPATH {

  static String user(String uid) => 'users/$uid';
  static String users() => 'users';

  static String job(String uid, String jobid) => 'users/$uid/jobs/$jobid';
  static String jobs(String uid) => 'users/$uid/jobs';

  static String campus(String uid, String uniId) => 'users/$uid/campuses/$uniId';
  static String campuses(String uid) => 'users/$uid/campuses';

  static String host(String uid, String hostId) =>
      'users/$uid/hosts/$hostId';
  static String hosts(String uid) => 'users/$uid/hosts';

  static String course(String uid, String Courseid) => 'users/$uid/courses/$Courseid';
  static String courses(String uid) => 'users/$uid/courses';

  static String entry(String uid, String entryid) => 'users/$uid/entries/$entryid';
  static String entries(String uid) => 'users/$uid/entries';


  static String hostentry(String uid, String entryid) => 'users/$uid/hostentries/$entryid';
  static String hostentries(String uid) => 'users/$uid/hostentries';


  static String whishlist(String uid, String whishlistid) => 'users/$uid/wishlists/$whishlistid';
  static String whishlists(String uid) => 'users/$uid/wishlists';

}
