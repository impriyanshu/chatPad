
class APIpath{

  static String job(String uid, String jobs)  => '/connect/$uid/jobs/$jobs' ;
  static String joball(String jobs)  => '/allusers/$jobs' ;
  static String jobs(String name) => 'connect/$name/jobs' ;
  static String userna (String uid) => '/users/$uid';
  static String addRqst (String uid) => '/users/$uid';
  static String allJobs() => '/allusers';
  static String allGroup(String name) => '/allgroups/$name/users';
  static String allGroupTotal() => '/allgroups';
  static String ingroup(String name) => 'allgroups/$name/users' ;

}