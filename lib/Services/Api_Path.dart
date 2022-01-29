class APIPATH {

  static String user(String uid) => 'users/$uid';
  static String users() => 'users';

  static String campus(String uniId) => 'campuses/$uniId';
  static String campuses(String uid) => 'campuses';

  static String host(String hostId) =>
      'hosts/$hostId';
  static String hosts(String uid) => 'hosts';

  static String course(String Courseid) => 'courses/$Courseid';
  static String courses(String uid) => 'courses';

  static String entry(String entryid) => 'entries/$entryid';
  static String entries(String uid) => 'entries';


  static String hostentry(String uid, String entryid) => 'users/$uid/hostentries/$entryid';
  static String hostentries(String uid) => 'users/$uid/hostentries';



}
