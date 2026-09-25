void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC9jeLa4fifRH24dewecrUfv-tVoErIonc",
      appId: "1:891475422514:web:cb7dee5c5edf2e45e37b2b",
      messagingSenderId: "891475422514",
      projectId: "wraps-on-wheels",
      storageBucket: "wraps-on-wheels.firebasestorage.app",
    ),
  );

  runApp(const MyApp()); // (या जो भी आपकी ऐप क्लास का नाम हो)
}
