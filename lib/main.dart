import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/sell_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'screens/view_product_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/product_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/category_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/garage_screen.dart';
import 'screens/add_garage_item_screen.dart';
import 'screens/parts_screen.dart';
import 'screens/seller_profile_screen.dart';
import 'screens/message_screen.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/search_provider.dart';
import 'providers/location_provider.dart';
import 'services/location_service.dart';
import 'models/user.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services in a separate isolate
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
            textScaler: const TextScaler.linear(1.0),
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
        '/sell': (context) => const SellScreen(),
        '/view': (context) => const ViewProductScreen(),
        '/add': (context) => const AddProductScreen(),
        '/product': (context) => const ProductScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/edit': (context) => const EditProductScreen(),
        '/category': (context) => const CategoryScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/register': (context) => const RegisterScreen(),
        '/garage': (context) => const GarageScreen(),
        '/add-garage-item': (context) => const AddGarageItemScreen(),
        '/parts': (context) => const PartsScreen(),
        '/seller-profile': (context) => const SellerProfileScreen(),
        '/messages': (context) => const MessageScreen(),
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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Use Future.delayed to allow the UI to render first
    await Future.delayed(Duration.zero);
    
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
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

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          // If trying to access Sell or Profile while not logged in, show login
          if ((index == 2 || index == 3) && !_isLoggedIn) {
            Navigator.pushNamed(
              context,
              '/login',
              arguments: index,
            ).then((result) {
              if (result == true && mounted) {
                setState(() {
                  _isLoggedIn = true;
                  _selectedIndex = index;
                });
              }
            });
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
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