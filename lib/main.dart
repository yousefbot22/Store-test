import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
//                        MAIN
// ============================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(StoreApp(prefs: prefs));
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoreState(prefs),
      child: Consumer<StoreState>(
        builder: (_, state, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'طلباتي',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.dark ? ThemeMode.dark : ThemeMode.light,
          home: const RootScreen(),
        ),
      ),
    );
  }
}

// ============================================================
//                        THEME
// ============================================================
class AppColors {
  static const orange = Color(0xFFFF6B00);
  static const ink = Color(0xFF1A1A1A);
  static const soft = Color(0xFFF6F7F9);
  static const green = Color(0xFF16A34A);
}

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF8F9FB),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      brightness: Brightness.dark,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: light.filledButtonTheme,
  );
}

// ============================================================
//                        MODELS
// ============================================================
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.color,
    required this.description,
    required this.emoji,
    this.rating = 4.8,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final Color color;
  final String description;
  final String emoji;
  final double rating;
  final bool isFeatured;
}

class CartItem {
  CartItem({required this.product, this.quantity = 1});
  final Product product;
  int quantity;
  double get subtotal => product.price * quantity;
}

// ============================================================
//                        DATA
// ============================================================
const categories = <String>[
  'الكل', 'برجر', 'مشروبات', 'حلويات', 'إفطار', 'مقبلات',
];

const products = <Product>[
  Product(
    id: 'p1', name: 'برجر لحم مزدوج', category: 'برجر', price: 45,
    color: Color(0xFFFFD7A8), emoji: '🍔',
    description: 'قطعتين لحم مشوي مع جبن شيدر وصوص خاص.',
    rating: 4.9, isFeatured: true,
  ),
  Product(
    id: 'p2', name: 'بيتزا مارغريتا', category: 'مقبلات', price: 55,
    color: Color(0xFFFFB6C1), emoji: '🍕',
    description: 'عجينة إيطالية طازجة مع صوص طماطم وموزاريلا.',
    rating: 4.7, isFeatured: true,
  ),
  Product(
    id: 'p3', name: 'كوفي لاتيه', category: 'مشروبات', price: 18,
    color: Color(0xFFD9C2FF), emoji: '☕',
    description: 'إسبريسو مع حليب مبخّر ورغوة ناعمة.',
    rating: 4.8,
  ),
  Product(
    id: 'p4', name: 'كنافة بالجبن', category: 'حلويات', price: 32,
    color: Color(0xFFFFE4A8), emoji: '🍮',
    description: 'كنافة طازجة بالجبن مع شربات خفيف.',
    rating: 4.9, isFeatured: true,
  ),
  Product(
    id: 'p5', name: 'ساندويتش فلافل', category: 'إفطار', price: 12,
    color: Color(0xFFD2E5B5), emoji: '🌯',
    description: 'فلافل مقرمشة مع خضار وطحينة.',
    rating: 4.6,
  ),
  Product(
    id: 'p6', name: 'عصير برتقال', category: 'مشروبات', price: 15,
    color: Color(0xFFFFC285), emoji: '🍊',
    description: 'برتقال طبيعي 100% بدون سكر مضاف.',
    rating: 4.7,
  ),
  Product(
    id: 'p7', name: 'بيتزا مشكل', category: 'مقبلات', price: 65,
    color: Color(0xFFFFA5A5), emoji: '🍕',
    description: 'بيتزا بالمشكل مع دجاج ولحم وفلفل.',
    rating: 4.8,
  ),
  Product(
    id: 'p8', name: 'شاي بالنعناع', category: 'مشروبات', price: 8,
    color: Color(0xFFB8E6B8), emoji: '🍵',
    description: 'شاي مغربي منعش بالنعناع الطازج.',
    rating: 4.5,
  ),
  Product(
    id: 'p9', name: 'تشيز كيك', category: 'حلويات', price: 28,
    color: Color(0xFFFFE0B2), emoji: '🍰',
    description: 'تشيز كيك كريمي على بسكويت مقرمش.',
    rating: 4.9,
  ),
  Product(
    id: 'p10', name: 'برجر دجاج مقرمش', category: 'برجر', price: 38,
    color: Color(0xFFFFCC80), emoji: '🍗',
    description: 'صدر دجاج مقرمش مع صوص حار ومخلل.',
    rating: 4.7,
  ),
];

// ============================================================
//                        STATE
// ============================================================
class OrderRecord {
  OrderRecord({
    required this.id, required this.items,
    required this.total, required this.date,
  });

  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;

  Map<String, dynamic> toJson() => {
        'id': id, 'total': total, 'date': date.toIso8601String(),
        'items': items
            .map((e) => {'productId': e.product.id, 'qty': e.quantity})
            .toList(),
      };

  static OrderRecord fromJson(Map<String, dynamic> j) {
    final items = (j['items'] as List).map((e) => CartItem(
          product: products.firstWhere((p) => p.id == e['productId']),
          quantity: e['qty'] as int,
        )).toList();
    return OrderRecord(
      id: j['id'],
      items: items,
      total: (j['total'] as num).toDouble(),
      date: DateTime.parse(j['date']),
    );
  }
}

class StoreState extends ChangeNotifier {
  StoreState(this._prefs) { _load(); }
  final SharedPreferences _prefs;

  bool _dark = false;
  bool get dark => _dark;
  void toggleTheme() {
    _dark = !_dark;
    _prefs.setBool('dark', _dark);
    notifyListeners();
  }

  String _query = '';
  String _category = 'الكل';
  String get query => _query;
  String get category => _category;

  void setQuery(String v) { _query = v; notifyListeners(); }
  void setCategory(String c) { _category = c; notifyListeners(); }

  List<Product> get filteredProducts {
    final q = _query.trim().toLowerCase();
    return products.where((p) {
      final matchCat = _category == 'الكل' || p.category == _category;
      final matchQ = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
      return matchCat && matchQ;
    }).toList();
  }

  List<Product> get featured => products.where((p) => p.isFeatured).toList();

  final List<CartItem> _cart = [];
  List<CartItem> get cart => List.unmodifiable(_cart);
  int get cartCount => _cart.fold(0, (s, e) => s + e.quantity);
  double get cartTotal => _cart.fold(0, (s, e) => s + e.subtotal);

  void addToCart(Product p, {int qty = 1}) {
    final i = _cart.indexWhere((e) => e.product.id == p.id);
    if (i >= 0) {
      _cart[i].quantity += qty;
    } else {
      _cart.add(CartItem(product: p, quantity: qty));
    }
    _persistCart();
    notifyListeners();
  }

  void increment(String id) {
    final i = _cart.indexWhere((e) => e.product.id == id);
    if (i >= 0) { _cart[i].quantity++; _persistCart(); notifyListeners(); }
  }

  void decrement(String id) {
    final i = _cart.indexWhere((e) => e.product.id == id);
    if (i < 0) return;
    if (_cart[i].quantity <= 1) {
      _cart.removeAt(i);
    } else {
      _cart[i].quantity--;
    }
    _persistCart();
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cart.removeWhere((e) => e.product.id == id);
    _persistCart();
    notifyListeners();
  }

  void clearCart() { _cart.clear(); _persistCart(); notifyListeners(); }

  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;
  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    _prefs.setStringList('favorites', _favorites.toList());
    notifyListeners();
  }

  final List<OrderRecord> _orders = [];
  List<OrderRecord> get orders => List.unmodifiable(_orders);

  void placeOrder() {
    if (_cart.isEmpty) return;
    final order = OrderRecord(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(_cart),
      total: cartTotal,
      date: DateTime.now(),
    );
    _orders.insert(0, order);
    _persistOrders();
    clearCart();
  }

  void _load() {
    _dark = _prefs.getBool('dark') ?? false;
    _favorites.addAll(_prefs.getStringList('favorites') ?? []);
    final cartJson = _prefs.getString('cart');
    if (cartJson != null) {
      final data = jsonDecode(cartJson) as List;
      for (final e in data) {
        final p = products.firstWhere((x) => x.id == e['id']);
        _cart.add(CartItem(product: p, quantity: e['qty'] as int));
      }
    }
    final ordersJson = _prefs.getString('orders');
    if (ordersJson != null) {
      final list = jsonDecode(ordersJson) as List;
      _orders.addAll(
        list.map((e) => OrderRecord.fromJson(Map<String, dynamic>.from(e))),
      );
    }
    notifyListeners();
  }

  void _persistCart() {
    final data = _cart.map((e) => {'id': e.product.id, 'qty': e.quantity}).toList();
    _prefs.setString('cart', jsonEncode(data));
  }

  void _persistOrders() {
    _prefs.setString('orders', jsonEncode(_orders.map((e) => e.toJson()).toList()));
  }
}

// ============================================================
//                        ROOT SCREEN
// ============================================================
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _tab = 0;

  final _pages = const [
    HomeScreen(),
    FavoritesScreen(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final count = context.watch<StoreState>().cartCount;

    return Scaffold(
      body: IndexedStack(index: _tab, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (v) => setState(() => _tab = v),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: count > 0,
              label: Text('$count'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: count > 0,
              label: Text('$count'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'السلة',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'طلباتي',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}

// ============================================================
//                        PRODUCT CARD
// ============================================================
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});
  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreState>();
    final isFav = state.isFavorite(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: product.color,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(product.emoji,
                          style: const TextStyle(fontSize: 60)),
                    ),
                  ),
                  Positioned(
                    top: 6, right: 6,
                    child: Material(
                      color: Colors.white.withOpacity(.9),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => state.toggleFavorite(product.id),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.black54,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 3),
                          Text(product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white, fontSize: 11,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(height: 3),
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${product.price.toStringAsFixed(0)} ج.م',
                          style: const TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.w900,
                          )),
                      Material(
                        color: AppColors.ink,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            state.addToCart(product);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                content: Text('تمت إضافة ${product.name}'),
                                duration: const Duration(seconds: 1),
                              ));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.add,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
//                        HOME SCREEN
// ============================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreState>();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('أهلًا بك 👋',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          )),
                      const Text('اطلب دلوقتي',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: state.toggleTheme,
                    icon: const Icon(Icons.brightness_6_outlined),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: TextField(
                onChanged: state.setQuery,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'ابحث عن منتج أو قسم',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.orange, Color(0xFFFF9A4D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('خصم 30% على أول طلب 🎉',
                              style: TextStyle(
                                color: Colors.white, fontSize: 18,
                                fontWeight: FontWeight.w900,
                              )),
                          const SizedBox(height: 6),
                          const Text('استخدم كود WELCOME',
                              style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 12),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.orange,
                            ),
                            onPressed: () {},
                            child: const Text('اطلب الآن'),
                          ),
                        ],
                      ),
                    ),
                    const Text('🎁', style: TextStyle(fontSize: 60)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 56,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final c = categories[i];
                  final selected = state.category == c;
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: selected,
                      onSelected: (_) => state.setCategory(c),
                    ),
                  );
                },
              ),
            ),
          ),
          if (state.query.isEmpty && state.category == 'الكل') ...[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(18, 18, 18, 8),
                child: Text('الأكثر طلبًا 🔥',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w900)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 230,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.featured.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final p = state.featured[i];
                    return SizedBox(
                      width: 170,
                      child: ProductCard(
                        product: p,
                        onTap: () => _showDetails(context, p),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
              child: Row(
                children: [
                  const Text('كل المنتجات',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900)),
                  const Spacer(),
                  Text('${state.filteredProducts.length} منتج',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      )),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .72,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final p = state.filteredProducts[i];
                  return ProductCard(
                    product: p,
                    onTap: () => _showDetails(context, p),
                  );
                },
                childCount: state.filteredProducts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, Product p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => ProductDetails(product: p),
    );
  }
}

// ============================================================
//                    PRODUCT DETAILS SHEET
// ============================================================
class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreState>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 180, width: double.infinity,
            decoration: BoxDecoration(
              color: product.color,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(product.emoji,
                  style: const TextStyle(fontSize: 90)),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(product.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w900)),
              ),
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(product.rating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(product.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.6,
              )),
          const SizedBox(height: 20),
          Row(
            children: [
              Text('${product.price.toStringAsFixed(0)} ج.م',
                  style: const TextStyle(
                    fontSize: 22,
                    color: AppColors.orange,
                    fontWeight: FontWeight.w900,
                  )),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {
                  state.addToCart(product);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('أضف للسلة'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
//                    FAVORITES SCREEN
// ============================================================
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreState>();
    final items = products.where((p) => state.isFavorite(p.id)).toList();

    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.favorite_border,
        title: 'مفيش مفضلة لسه',
        subtitle: 'اضغط على القلب في أي منتج لحفظه هنا',
      );
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 20, 18, 12),
              child: Text('المفضلة',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w900)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .72,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => ProductCard(product: items[i]),
                childCount: items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//                    CART SCREEN
// ============================================================
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreState>();

    if (state.cart.isEmpty) {
      return const EmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'السلة فارغة',
        subtitle: 'ابدأ بإضافة منتجات من الصفحة الرئيسية',
      );
    }

    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 20, 18, 12),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text('سلة التسوق',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w900)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: state.cart.length,
              itemBuilder: (_, i) {
                final item = state.cart[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: item.product.color,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(item.product.emoji,
                              style: const TextStyle(fontSize: 30)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${item.product.price.toStringAsFixed(0)} ج.م',
                                style: const TextStyle(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.w900,
                                )),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                state.decrement(item.product.id),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('${item.quantity}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () =>
                                state.increment(item.product.id),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('الإجمالي',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('${state.cartTotal.toStringAsFixed(0)} ج.م',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.orange,
                          fontWeight: FontWeight.w900,
                        )),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _checkout(context, state),
                    child: const Text('إتمام الطلب'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _checkout(BuildContext context, StoreState state) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الطلب'),
        content: Text(
          'إجمالي الطلب ${state.cartTotal.toStringAsFixed(0)} ج.م. هل تريد تأكيد الطلب؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              state.placeOrder();
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إنشاء الطلب بنجاح ✅')),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//                    ORDERS SCREEN
// ============================================================
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreState>();

    if (state.orders.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'مفيش طلبات لسه',
        subtitle: 'طلباتك هتظهر هنا بعد ما تأكد أول طلب',
      );
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('طلباتي',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          ...state.orders.map((order) {
            final date = order.date;
            final dateStr =
                '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.green.withOpacity(.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('تم التسليم ✅',
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      const Spacer(),
                      Text(dateStr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(order.id,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 10),
                  ...order.items.map((it) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Text('${it.product.emoji} ',
                                style: const TextStyle(fontSize: 16)),
                            Expanded(child: Text(it.product.name)),
                            Text('×${it.quantity}',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Text('الإجمالي:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text('${order.total.toStringAsFixed(0)} ج.م',
                          style: const TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================
//                    PROFILE SCREEN
// ============================================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreState>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('حسابي',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.orange, Color(0xFFFF9A4D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person_outline,
                      size: 34, color: AppColors.orange),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('زائر المتجر',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          )),
                      SizedBox(height: 4),
                      Text('سجل دخولك لمتابعة طلباتك',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                _tile(Icons.receipt_long_outlined, 'طلباتي',
                    '${state.orders.length} طلب'),
                const Divider(height: 1),
                _tile(Icons.favorite_border, 'المفضلة',
                    '${state.favorites.length} منتج'),
                const Divider(height: 1),
                _tile(Icons.location_on_outlined, 'عناويني', 'أضف عنوانك'),
                const Divider(height: 1),
                _tile(Icons.local_shipping_outlined, 'تتبع الطلبات', ''),
                const Divider(height: 1),
                _tile(Icons.support_agent_outlined, 'مركز المساعدة', ''),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: SwitchListTile(
              secondary: const Icon(Icons.brightness_6_outlined),
              title: const Text('الوضع الليلي'),
              value: state.dark,
              onChanged: (_) => state.toggleTheme(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String trailing) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing.isNotEmpty)
              Text(trailing,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_left, color: Colors.grey),
          ],
        ),
      );
}

// ============================================================
//                    EMPTY STATE
// ============================================================
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
            ],
          ),
        ),
      );
}