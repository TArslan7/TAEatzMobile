import '../../../../core/errors/exceptions.dart';
import '../models/menu_model.dart';

abstract class MenuRemoteDataSource {
  Future<MenuModel> getMenuByRestaurantId(String restaurantId);
  Future<List<MenuItemModel>> getMenuItemsByCategory({
    required String restaurantId,
    required String categoryId,
  });
  Future<MenuItemModel> getMenuItemById({
    required String restaurantId,
    required String itemId,
  });
  Future<List<MenuItemModel>> searchMenuItems({
    required String restaurantId,
    required String query,
  });
  Future<List<MenuItemModel>> getPopularItems(String restaurantId);
  Future<List<MenuItemModel>> getRecommendedItems(String restaurantId);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  // Temporarily using mock data for testing
  
  @override
  Future<MenuModel> getMenuByRestaurantId(String restaurantId) async {
    try {
      // Mock data for now - in real app this would come from API
      await Future.delayed(const Duration(seconds: 1));
      
      return MenuModel(
        id: 'menu_$restaurantId',
        restaurantId: restaurantId,
        name: 'Main Menu',
        description: 'Delicious dishes from our kitchen',
        categories: _getMockCategories(restaurantId),
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MenuItemModel>> getMenuItemsByCategory({
    required String restaurantId,
    required String categoryId,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final menu = await getMenuByRestaurantId(restaurantId);
      final category = menu.categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => menu.categories.first,
      );
      
      return category.items;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MenuItemModel> getMenuItemById({
    required String restaurantId,
    required String itemId,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final menu = await getMenuByRestaurantId(restaurantId);
      for (final category in menu.categories) {
        for (final item in category.items) {
          if (item.id == itemId) {
            return item;
          }
        }
      }
      
      throw NotFoundException(message: 'Menu item not found');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MenuItemModel>> searchMenuItems({
    required String restaurantId,
    required String query,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final menu = await getMenuByRestaurantId(restaurantId);
      final allItems = <MenuItemModel>[];
      
      for (final category in menu.categories) {
        allItems.addAll(category.items);
      }
      
      return allItems.where((item) =>
        item.name.toLowerCase().contains(query.toLowerCase()) ||
        item.description.toLowerCase().contains(query.toLowerCase()) ||
        item.dietaryInfo.any((info) => 
          info.toLowerCase().contains(query.toLowerCase())
        )
      ).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MenuItemModel>> getPopularItems(String restaurantId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      
      final menu = await getMenuByRestaurantId(restaurantId);
      final allItems = <MenuItemModel>[];
      
      for (final category in menu.categories) {
        allItems.addAll(category.items);
      }
      
      return allItems.where((item) => item.isPopular).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MenuItemModel>> getRecommendedItems(String restaurantId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 700));
      
      // Mock recommendation logic - in real app this would be AI-based
      final menu = await getMenuByRestaurantId(restaurantId);
      final allItems = <MenuItemModel>[];
      
      for (final category in menu.categories) {
        allItems.addAll(category.items);
      }
      
      // Return items that are popular or have high ratings
      return allItems.where((item) => 
        item.isPopular || 
        item.calories < 500 || 
        item.isVegetarian
      ).take(5).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  List<MenuCategoryModel> _getMockCategories(String restaurantId) {
    if (restaurantId == '1') {
      // Pizza Palace categories
      return [
        MenuCategoryModel(
          id: 'cat_1',
          name: 'Pizzas',
          description: 'Authentic Italian pizzas',
          sortOrder: 1,
          items: _getPizzaItems(),
          isActive: true,
        ),
        MenuCategoryModel(
          id: 'cat_2',
          name: 'Appetizers',
          description: 'Start your meal right',
          sortOrder: 2,
          items: _getAppetizerItems(),
          isActive: true,
        ),
        MenuCategoryModel(
          id: 'cat_3',
          name: 'Desserts',
          description: 'Sweet endings',
          sortOrder: 3,
          items: _getDessertItems(),
          isActive: true,
        ),
      ];
    } else if (restaurantId == '2') {
      // Sushi Master categories
      return [
        MenuCategoryModel(
          id: 'cat_4',
          name: 'Sushi Rolls',
          description: 'Fresh sushi rolls',
          sortOrder: 1,
          items: _getSushiItems(),
          isActive: true,
        ),
        MenuCategoryModel(
          id: 'cat_5',
          name: 'Sashimi',
          description: 'Fresh raw fish',
          sortOrder: 2,
          items: _getSashimiItems(),
          isActive: true,
        ),
      ];
    } else {
      // Burger King categories
      return [
        MenuCategoryModel(
          id: 'cat_6',
          name: 'Burgers',
          description: 'Flame-grilled burgers',
          sortOrder: 1,
          items: _getBurgerItems(),
          isActive: true,
        ),
        MenuCategoryModel(
          id: 'cat_7',
          name: 'Sides',
          description: 'Perfect sides',
          sortOrder: 2,
          items: _getSideItems(),
          isActive: true,
        ),
      ];
    }
  }

  List<MenuItemModel> _getPizzaItems() {
    return [
      MenuItemModel(
        id: 'item_1',
        name: 'Margherita Pizza',
        description: 'Classic tomato, mozzarella, and basil',
        price: 12.99,
        imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400',
        imageUrls: ['https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400'],
        allergens: ['gluten', 'dairy'],
        dietaryInfo: ['vegetarian'],
        calories: 320,
        preparationTime: 15,
        isAvailable: true,
        isPopular: true,
        isSpicy: false,
        isVegetarian: true,
        isVegan: false,
        isHalal: false,
        options: _getPizzaOptions(),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      MenuItemModel(
        id: 'item_2',
        name: 'Pepperoni Pizza',
        description: 'Spicy pepperoni with mozzarella',
        price: 15.99,
        imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
        imageUrls: ['https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400'],
        allergens: ['gluten', 'dairy', 'pork'],
        dietaryInfo: [],
        calories: 450,
        preparationTime: 18,
        isAvailable: true,
        isPopular: true,
        isSpicy: true,
        isVegetarian: false,
        isVegan: false,
        isHalal: false,
        options: _getPizzaOptions(),
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<MenuItemModel> _getAppetizerItems() {
    return [
      MenuItemModel(
        id: 'item_3',
        name: 'Garlic Bread',
        description: 'Crispy bread with garlic butter',
        price: 4.99,
        imageUrl: 'https://images.unsplash.com/photo-1572441713132-51c75654db73?w=400',
        imageUrls: ['https://images.unsplash.com/photo-1572441713132-51c75654db73?w=400'],
        allergens: ['gluten', 'dairy'],
        dietaryInfo: ['vegetarian'],
        calories: 180,
        preparationTime: 8,
        isAvailable: true,
        isPopular: false,
        isSpicy: false,
        isVegetarian: true,
        isVegan: false,
        isHalal: false,
        options: [],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<MenuItemModel> _getDessertItems() {
    return [
      MenuItemModel(
        id: 'item_4',
        name: 'Tiramisu',
        description: 'Classic Italian dessert',
        price: 6.99,
        imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400',
        imageUrls: ['https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400'],
        allergens: ['dairy', 'eggs'],
        dietaryInfo: ['vegetarian'],
        calories: 280,
        preparationTime: 5,
        isAvailable: true,
        isPopular: true,
        isSpicy: false,
        isVegetarian: true,
        isVegan: false,
        isHalal: false,
        options: [],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<MenuItemModel> _getSushiItems() {
    return [
      MenuItemModel(
        id: 'item_5',
        name: 'California Roll',
        description: 'Crab, avocado, and cucumber',
        price: 8.99,
        imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        imageUrls: ['https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400'],
        allergens: ['fish', 'soy'],
        dietaryInfo: [],
        calories: 200,
        preparationTime: 10,
        isAvailable: true,
        isPopular: true,
        isSpicy: false,
        isVegetarian: false,
        isVegan: false,
        isHalal: false,
        options: [],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<MenuItemModel> _getSashimiItems() {
    return [
      MenuItemModel(
        id: 'item_6',
        name: 'Salmon Sashimi',
        description: 'Fresh salmon slices',
        price: 12.99,
        imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        imageUrls: ['https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400'],
        allergens: ['fish'],
        dietaryInfo: [],
        calories: 150,
        preparationTime: 5,
        isAvailable: true,
        isPopular: false,
        isSpicy: false,
        isVegetarian: false,
        isVegan: false,
        isHalal: false,
        options: [],
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<MenuItemModel> _getBurgerItems() {
    return [
      MenuItemModel(
        id: 'item_7',
        name: 'Whopper',
        description: 'Flame-grilled beef burger',
        price: 7.99,
        imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        imageUrls: ['https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400'],
        allergens: ['gluten', 'dairy', 'beef'],
        dietaryInfo: [],
        calories: 600,
        preparationTime: 12,
        isAvailable: true,
        isPopular: true,
        isSpicy: false,
        isVegetarian: false,
        isVegan: false,
        isHalal: false,
        options: _getBurgerOptions(),
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<MenuItemModel> _getSideItems() {
    return [
      MenuItemModel(
        id: 'item_8',
        name: 'French Fries',
        description: 'Crispy golden fries',
        price: 3.99,
        imageUrl: 'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=400',
        imageUrls: ['https://images.unsplash.com/photo-1576107232684-1279f390859f?w=400'],
        allergens: [],
        dietaryInfo: ['vegetarian', 'vegan'],
        calories: 250,
        preparationTime: 8,
        isAvailable: true,
        isPopular: true,
        isSpicy: false,
        isVegetarian: true,
        isVegan: true,
        isHalal: true,
        options: [],
        createdAt: DateTime.now().subtract(const Duration(days: 35)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<MenuItemOptionModel> _getPizzaOptions() {
    return [
      MenuItemOptionModel(
        id: 'opt_1',
        name: 'Size',
        type: 'single',
        isRequired: true,
        minSelections: 1,
        maxSelections: 1,
        values: [
          MenuItemOptionValueModel(
            id: 'val_1',
            name: 'Small (10")',
            price: 0.0,
            isDefault: true,
            isAvailable: true,
          ),
          MenuItemOptionValueModel(
            id: 'val_2',
            name: 'Medium (12")',
            price: 3.0,
            isDefault: false,
            isAvailable: true,
          ),
          MenuItemOptionValueModel(
            id: 'val_3',
            name: 'Large (14")',
            price: 6.0,
            isDefault: false,
            isAvailable: true,
          ),
        ],
      ),
    ];
  }

  List<MenuItemOptionModel> _getBurgerOptions() {
    return [
      MenuItemOptionModel(
        id: 'opt_2',
        name: 'Extras',
        type: 'multiple',
        isRequired: false,
        minSelections: 0,
        maxSelections: 3,
        values: [
          MenuItemOptionValueModel(
            id: 'val_4',
            name: 'Extra Cheese',
            price: 1.0,
            isDefault: false,
            isAvailable: true,
          ),
          MenuItemOptionValueModel(
            id: 'val_5',
            name: 'Bacon',
            price: 2.0,
            isDefault: false,
            isAvailable: true,
          ),
          MenuItemOptionValueModel(
            id: 'val_6',
            name: 'Extra Patty',
            price: 3.0,
            isDefault: false,
            isAvailable: true,
          ),
        ],
      ),
    ];
  }
}
