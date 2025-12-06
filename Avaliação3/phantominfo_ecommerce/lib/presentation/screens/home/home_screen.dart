// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // Banners Locais
  final List<Map<String, String>> bannerData = const [
    {'path': 'assets/banners/Foto banner1.png', 'title': 'OFERTAS EXCLUSIVAS'},
    {'path': 'assets/banners/Foto banner2.png', 'title': 'NOVOS PRODUTOS'},
    {'path': 'assets/banners/Foto banner3.png', 'title': 'FRETE GRÁTIS'},
  ];
  
  // Ícones de Destaque Rápido - Genérico
  final List<Map<String, dynamic>> quickHighlights = const [
    {'title': 'Eletrônicos', 'icon': Icons.lightbulb_outline},
    {'title': 'Roupas', 'icon': Icons.checkroom_outlined},
    {'title': 'Joias', 'icon': Icons.diamond_outlined},
    {'title': 'Diversos', 'icon': Icons.category_outlined},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).loadProducts();
    });
  }
  
  // Widget para construir a seção de banners (Horizontal)
  Widget _buildBanners(double screenWidth) {
    final double bannerHeight = screenWidth > 600 ? 200 : 150;
    final double bannerWidth = screenWidth * 0.75; 

    return SizedBox(
      height: bannerHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: bannerData.length > 3 ? 3 : bannerData.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final banner = bannerData[index];
          return Container(
            width: bannerWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    banner['path']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primaryColor.withOpacity(0.5),
                      child: Center(
                        child: Text(
                          banner['title']!, 
                          textAlign: TextAlign.center, 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        )
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Text(
                      banner['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth > 600 ? 18 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget para simular as seções de destaque rápido
  Widget _buildQuickHighlights(double screenWidth) {
    final double iconSize = screenWidth > 600 ? 36 : 28;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            'Explore Nossas Categorias',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            scrollDirection: Axis.horizontal,
            itemCount: quickHighlights.length,
            itemBuilder: (context, index) {
              final highlight = quickHighlights[index];
              return Container(
                width: screenWidth > 600 ? 140 : 120,
                margin: const EdgeInsets.all(4),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(highlight['icon'] as IconData, color: AppColors.primaryColor, size: iconSize),
                        const SizedBox(height: 4),
                        Text(highlight['title'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    final int crossAxisCount = screenWidth > 600 ? 3 : 2;
    final double childAspectRatio = screenWidth > 600 ? 1.05 : 0.95;

    final homeViewModel = Provider.of<HomeViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phantominfo Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
              if (mounted) {
                 Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seção Estática: Banners e Destaques Rápidos
          // Adicionamos um SingleChildScrollView para permitir a rolagem vertical
          // caso o topo da tela seja maior que o espaço disponível (telas muito pequenas)
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            // Usamos Column dentro para empilhar os elementos
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBanners(screenWidth),
                _buildQuickHighlights(screenWidth),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Text(
                    'Destaques e Lançamentos',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de Produtos (Deve sempre estar em Expanded para ocupar o restante da tela)
          Expanded(
            child: homeViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : homeViewModel.errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            homeViewModel.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.errorColor, fontSize: 16),
                          ),
                        ),
                      )
                    : (homeViewModel.products.isEmpty && !homeViewModel.isLoading)
                      ? const Center(child: Text('Nenhum produto encontrado.'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount, 
                            childAspectRatio: childAspectRatio,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: homeViewModel.products.length,
                          itemBuilder: (context, index) {
                            final product = homeViewModel.products[index];
                            return Card(
                              elevation: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Área da Imagem
                                  Expanded(
                                    flex: 3, 
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                  // Área de Título e Preço
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth > 600 ? 13 : 12),
                                          ),
                                          const Spacer(),
                                          Text(
                                            'R\$ ${product.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: AppColors.accentColor,
                                              fontSize: screenWidth > 600 ? 16 : 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Botão Adicionar
                                  ElevatedButton(
                                    onPressed: () {
                                      cartViewModel.addItem(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Produto adicionado ao carrinho!'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: AppColors.backgroundColor,
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      minimumSize: Size.zero,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                      ),
                                    ),
                                    child: const Text('Comprar', style: TextStyle(fontSize: 13)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
          ),
        ],
      ),
    );
  }
}