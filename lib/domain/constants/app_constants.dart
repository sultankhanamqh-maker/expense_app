import 'package:expense1/data/model/cat_model.dart';

class AppConstant {

  /// database name
  static const String dbName = "expenseDb.db";

  /// UserTable
  /// User tabel name
  static const String userTable = "user_table";

  /// columns
  static const String userColumnId = "user_id";
  static const String userColumnName = "user_name";
  static const String userColumnMobile = "user_mobile";
  static const String userColumnEmail = "user_Email";
  static const String userColumnPassword = "user_password";

  /// Expense Table
  /// Expense table name
  static const String expenseTable = "expens_table";
  /// columns
  static const String expenColumnId = "expense_id";
  static const String expenColumnTitle = "expense_title";
  static const String expenColumndesc = "expense_desc";
  static const String expenColumnAmt= "expense_amt";
  static const String expenColumnBal= "expense_bal";
  static const String expenColumnExpType = "expense_exp_type";
  static const String expenColumnCatId = "expense_cat_id";
  static const String expenColumnCreatedAt = "expense_created_at";


  /// sharedPrefereces
  static const String app_login_prefs = "app_login_prefs";


  /// images path
  static const String imgCoffee = "assets/icons/coffee.png";
  static const String imgFastFood = "assets/icons/fast-food.png";
  static const String imgGiftBox = "assets/icons/gift-box.png";
  static const String imgHawalianShirt = "assets/icons/hawaiian-shirt.png";
  static const String imgHotPot = "assets/icons/hot-pot.png";
  static const String imgIcAppLogo = "assets/icons/ic_app_logo.png";
  static const String imgIcAppLogoOutline = "assets/icons/ic_app_logo_outline.png";
  static const String imgIcAppLogoSolid = "assets/icons/ic_app_logo_solid.png";
  static const String imgMakeUpPouch = "assets/icons/makeup-pouch.png";
  static const String imgMobileTransfer = "assets/icons/mobile-transfer.png";
  static const String imgMusic = "assets/icons/music.png";
  static const String imgPopcorn = "assets/icons/popcorn.png";
  static const String imgRestaurant = "assets/icons/restaurant.png";
  static const String imgShopping = "assets/icons/shopping-bag.png";
  static const String imgSmartPhone = "assets/icons/smartphone.png";
  static const String imgSnack = "assets/icons/snack.png";
  static const String imgTools = "assets/icons/tools.png";
  static const String imgTravel = "assets/icons/travel.png";
  static const String imgVegetables = "assets/icons/vegetables.png";
  static const String imgVehicles = "assets/icons/vehicles.png";
  static const String imgWatch = "assets/icons/watch.png";


  /// category data
  static final List<CatModel> allCat = [
    CatModel(id: 1,title: "coffee", imgPath: imgCoffee),
    CatModel(id: 2, title: "Fast Food", imgPath: imgFastFood),
    CatModel(id: 3,title: "Gift Box", imgPath: imgGiftBox),
    CatModel(id: 4, title: "Shirt", imgPath: imgHawalianShirt),
    CatModel(id: 5,title: "Hot Pot", imgPath: imgHotPot),
    CatModel(id: 6, title: "Wallet", imgPath: imgIcAppLogo),
    CatModel(id: 7,title: "Make Up", imgPath: imgMakeUpPouch),
    CatModel(id: 8, title: "Mobile Transfer", imgPath: imgMobileTransfer),
    CatModel(id: 9,title: "Music", imgPath: imgMusic),
    CatModel(id: 10, title: "Pop Corn", imgPath: imgPopcorn),
    CatModel(id: 11,title: "Restaurant", imgPath: imgRestaurant),
    CatModel(id: 12, title: "Shopping", imgPath: imgShopping),
    CatModel(id: 13,title: "Smart Phone", imgPath: imgSmartPhone),
    CatModel(id: 14, title: "Snacks", imgPath: imgSnack),
    CatModel(id: 15, title: "Tools", imgPath: imgTools),
    CatModel(id: 16, title: "Travel", imgPath: imgTravel),
    CatModel(id: 17, title: "Vegetable", imgPath: imgVegetables),
    CatModel(id: 18, title: "Vehicles", imgPath: imgVehicles),
    CatModel(id: 19, title: "Watch", imgPath: imgWatch),
    CatModel(id: 16, title: "Others", imgPath: imgIcAppLogoSolid)
  ];

}