class AdminDoctorVerificationController {
  final FirebaseAuth auth = FirebaseAuth.insance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  FirebaseAuthException? error;
  bool working = false;

  //--------------- GET ALL DOCTORS -------------------

  Future<Either<Exception, List<DoctorModel>>> getAllDoctors() async {}
}
