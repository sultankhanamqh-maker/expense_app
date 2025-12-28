import 'dart:io';

import 'package:expense1/data/model/expense_model.dart';
import 'package:expense1/data/model/user_model.dart';
import 'package:expense1/domain/constants/app_constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static DbHelper instance = DbHelper._();

  Database? mdb;

  Future<Database> initDb() async {
    mdb ??= await openDb();
    return mdb!;
  }

  Future<Database> openDb() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, AppConstant.dbName);

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "create table ${AppConstant.userTable} ( ${AppConstant.userColumnId} integer primary key autoincrement , ${AppConstant.userColumnName} text , ${AppConstant.userColumnEmail} text , ${AppConstant.userColumnMobile} text, ${AppConstant.userColumnPassword} text )",
        );

        db.execute(
          "create table ${AppConstant.expenseTable} ( ${AppConstant.expenColumnId} integer primary key autoincrement , ${AppConstant.userColumnId} integer , ${AppConstant.expenColumnTitle} text , ${AppConstant.expenColumndesc} text , ${AppConstant.expenColumnAmt} real , ${AppConstant.expenColumnBal} real , ${AppConstant.expenColumnCatId} integer , ${AppConstant.expenColumnExpType} integer , ${AppConstant.expenColumnCreatedAt} text )",
        );
      },
    );
  }

  /// 1-> error
  /// 2-> user already exist
  /// 3-> user successfully added
  Future<int> registerUser({required UserModel newUser}) async {
    var db = await initDb();
    if (await checkIfUserAlreadyExist(email: newUser.email)) {
      return 2;
    } else {
      int rowsEffected = await db.insert(
        AppConstant.userTable,
        newUser.toMap(),
      );
      return rowsEffected > 0 ? 3 : 1;
    }
  }

  Future<List<UserModel>> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uId = prefs.getInt(AppConstant.app_login_prefs) ?? 0;
    var db = await initDb();
    List<UserModel> allUser =[];

    var user = await db.query(
      AppConstant.userTable,
      where: "${AppConstant.userColumnId} = ?",
      whereArgs: [uId],
    );
    for(Map<String , dynamic> eachUser in user){
      allUser.add(UserModel.fromMap(eachUser));
    }
    return allUser;
  }

  Future<bool> checkIfUserAlreadyExist({required String email}) async {
    var db = await initDb();
    var check = await db.query(
      AppConstant.userTable,
      where: " ${AppConstant.userColumnEmail} = ? ",
      whereArgs: [email],
    );
    return check.isNotEmpty;
  }

  Future<int> loginUser({required String email, required String pass}) async {
    var db = await initDb();
    if (await checkIfUserAlreadyExist(email: email)) {
      var user = await db.query(
        AppConstant.userTable,
        where:
            " ${AppConstant.userColumnEmail} = ? and ${AppConstant.userColumnPassword} = ?",
        whereArgs: [email, pass],
      );
      if (user.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt(
          AppConstant.app_login_prefs,
          user[0][AppConstant.userColumnId] as int,
        );
        return 3;

        /// for success
      } else {
        return 1;

        /// password incorrect
      }
    } else {
      return 2;

      /// email incorrect
    }
  }

  Future<bool> addExpense({required ExpenseModel expenseModel}) async {
    var db = await initDb();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uid = prefs.getInt(AppConstant.app_login_prefs) ?? 0;

    expenseModel.userId = uid;

    int rowsEffectd = await db.insert(
      AppConstant.expenseTable,
      expenseModel.toMap(),
    );
    return rowsEffectd > 0;
  }

  Future<List<ExpenseModel>> getExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uid = prefs.getInt(AppConstant.app_login_prefs) ?? 0;
    var db = await initDb();

    List<ExpenseModel> allExp = [];

    List<Map<String, dynamic>> dbExp = await db.query(
      AppConstant.expenseTable,
      where: '${AppConstant.userColumnId} = ?',
      whereArgs: [uid],
    );

    for (Map<String, dynamic> eachExp in dbExp) {
      allExp.add(ExpenseModel.fromMap(eachExp));
    }

    return allExp;
  }

    Future<double> currBalance()async{
    var db = await initDb();
    var bal = await db.query(AppConstant.expenseTable,columns: [AppConstant.expenColumnBal],orderBy: "${AppConstant.expenColumnId} desc",limit: 1);
    if(bal.isNotEmpty){
      return bal.first['${AppConstant.expenColumnBal}'] as double;
    }
    else {
      return 0.0;
    }
  }
}
