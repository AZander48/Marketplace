import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/sell_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/view_product_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/edit_product_screen.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/search_provider.dart';
import 'providers/location_provider.dart';
import 'services/location_service.dart';
import 'package:http/http.dart' as http;
import 'models/product.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final httpClient = http.Client();
  final locationService = LocationService(
    baseUrl: 'http://10.0.2.2:3000/api',
    client: httpClient,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        Provider<LocationService>(
          create: (_) => locationService,
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(locationService),
        ),
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.blue.shade200,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurfaceVariant: Colors.black87,
          onSurface: Colors.black87,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          elevation: 0,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
            alwaysUse24HourFormat: true,
            viewInsets: MediaQuery.of(context).viewInsets,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/sell': (context) => const SellScreen(),
        '/view': (context) => const ViewProductScreen(),
        '/add': (context) => const AddProductScreen(),
        '/edit': (context) => const EditProductScreen(productId: 0),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const SellScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() => _isLoading = true);
    
    try {
      _isLoggedIn = authProvider.isLoggedIn;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If not logged in, show login screen instead of the selected screen
    final currentScreen = _selectedIndex == 2 && !_isLoggedIn || _selectedIndex == 3 && !_isLoggedIn
        ? const LoginScreen()
        : _screens[_selectedIndex];

    return Scaffold(
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
} 