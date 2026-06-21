MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Easymairie',

  theme: ThemeData(
    fontFamily: 'Roboto',
    primaryColor: const Color(0xFF1E3A8A),
    scaffoldBackgroundColor: const Color(0xFFF9FAFB),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E3A8A),
      elevation: 0,
      centerTitle: true,
    ),
  ),

  home: const HomeScreen(),
);