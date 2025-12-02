import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/so_model.dart';
import '../models/production_order_model.dart';
import '../models/approval_request_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      // Recreate all tables with new structure
      await db.execute('DROP TABLE IF EXISTS so_orders');
      await db.execute('DROP TABLE IF EXISTS production_orders');
      await db.execute('DROP TABLE IF EXISTS approval_requests');
      await db.execute('DROP TABLE IF EXISTS users');

      // Recreate tables with new structure
      await _createDB(db, newVersion);
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE users ( 
  id $idType, 
  username $textType,
  password $textType
  )
''');

    await db.execute('''
CREATE TABLE approval_requests ( 
  id $idType, 
  requestMessage $textType,
  requesterName $textType,
  requestDate $textType,
  requestTime $textType,
  soCount $intType,
  status $textType
  )
''');

    await db.execute('''
CREATE TABLE so_orders ( 
  id $idType, 
  requestId $intType,
  type $textType,
  orderDate $textType,
  brand $textType,
  sapSoNumber $textType,
  line $textType,
  sapPoNumber TEXT,
  materialCode $textType,
  orderQty $intType,
  batchCardNo $textType,
  pcs $intType,
  sf $doubleType,
  packDate $textType,
  source $textType
  )
''');

    await db.execute('''
CREATE TABLE production_orders ( 
  id $idType, 
  requestId $intType,
  type $textType,
  orderDate $textType,
  brand $textType,
  line $textType,
  sapPoNumber $textType,
  materialCode $textType,
  orderQty $intType,
  batchCardNo $textType,
  pcs $intType,
  sf $doubleType,
  packDate $textType,
  source $textType
  )
''');

    // Insert dummy data
    await db.insert('users', {'username': 'admin', 'password': 'password'});

    // Insert approval requests
    await db.insert('approval_requests', {
      'requestMessage':
          'Below order packed qty over 30%, can you please help to approve then IT team can help to fix in system? Thank you.',
      'requesterName': 'John Smith',
      'requestDate': '2025/12/01',
      'requestTime': '09:30 AM',
      'soCount': 3,
      'status': 'Pending',
    });

    await db.insert('approval_requests', {
      'requestMessage':
          'Urgent: Need approval for special pricing on these orders due to VIP customer request.',
      'requesterName': 'Sarah Johnson',
      'requestDate': '2025/12/01',
      'requestTime': '10:15 AM',
      'soCount': 2,
      'status': 'Pending',
    });

    await db.insert('approval_requests', {
      'requestMessage':
          'Material shortage alert - requesting approval to proceed with alternative material.',
      'requesterName': 'Michael Chen',
      'requestDate': '2025/11/30',
      'requestTime': '03:45 PM',
      'soCount': 4,
      'status': 'Approved',
    });

    await db.insert('approval_requests', {
      'requestMessage':
          'Delivery date change request - customer requested earlier delivery.',
      'requesterName': 'Emily Wilson',
      'requestDate': '2025/12/02',
      'requestTime': '08:20 AM',
      'soCount': 1,
      'status': 'Pending',
    });

    // Insert sample SO orders linked to requests
    // Request 1 - 3 SO orders
    await db.insert('so_orders', {
      'requestId': 1,
      'type': 'Z12M',
      'orderDate': '11/27',
      'brand': 'ADIDAS',
      'sapSoNumber': '2251250846',
      'line': '10',
      'sapPoNumber': '',
      'materialCode': '3FG-PR01-LT00-5515',
      'orderQty': 10,
      'batchCardNo': 'Z12M25317012',
      'pcs': 2,
      'sf': 15.70,
      'packDate': '2025/12/1',
      'source': 'IHL stock move to order',
    });

    await db.insert('so_orders', {
      'requestId': 1,
      'type': 'Z12H',
      'orderDate': '11/19',
      'brand': 'ADIDAS',
      'sapSoNumber': '2081250337',
      'line': '10',
      'sapPoNumber': '900332501796',
      'materialCode': '3FG-PR01-LT01-7141',
      'orderQty': 6,
      'batchCardNo': 'Z12O25305910-2',
      'pcs': 2,
      'sf': 14.40,
      'packDate': '2025/12/1',
      'source': 'Wet blue/蓝湿皮',
    });

    await db.insert('so_orders', {
      'requestId': 1,
      'type': 'Z12M',
      'orderDate': '11/27',
      'brand': 'ADIDAS',
      'sapSoNumber': '2251250846',
      'line': '30',
      'sapPoNumber': '',
      'materialCode': '3FG-PR01-LT01-5160',
      'orderQty': 20,
      'batchCardNo': 'Z12M25315512',
      'pcs': 3,
      'sf': 26.10,
      'packDate': '2025/12/1',
      'source': 'IHL STOCK QC /IHL品检IHL',
    });

    // Request 2 - 2 SO orders
    await db.insert('so_orders', {
      'requestId': 2,
      'type': 'Z12H',
      'orderDate': '11/28',
      'brand': 'NIKE',
      'sapSoNumber': '2251250850',
      'line': '20',
      'sapPoNumber': '900332501800',
      'materialCode': '3FG-PR01-LT02-8520',
      'orderQty': 15,
      'batchCardNo': 'Z12H25318015',
      'pcs': 4,
      'sf': 22.50,
      'packDate': '2025/12/2',
      'source': 'Direct from supplier',
    });

    await db.insert('so_orders', {
      'requestId': 2,
      'type': 'Z12M',
      'orderDate': '11/29',
      'brand': 'PUMA',
      'sapSoNumber': '2251250855',
      'line': '15',
      'sapPoNumber': '',
      'materialCode': '3FG-PR01-LT03-9635',
      'orderQty': 25,
      'batchCardNo': 'Z12M25319020',
      'pcs': 5,
      'sf': 35.80,
      'packDate': '2025/12/3',
      'source': 'Stock transfer',
    });

    // Request 3 - 4 SO orders (Approved)
    await db.insert('so_orders', {
      'requestId': 3,
      'type': 'Z12M',
      'orderDate': '12/01',
      'brand': 'ADIDAS',
      'sapSoNumber': '2251250865',
      'line': '25',
      'sapPoNumber': '',
      'materialCode': '3FG-PR01-LT05-5678',
      'orderQty': 30,
      'batchCardNo': 'Z12M25321030',
      'pcs': 6,
      'sf': 42.30,
      'packDate': '2025/12/5',
      'source': 'IHL STOCK QC /IHL品检IHL',
    });

    await db.insert('so_orders', {
      'requestId': 3,
      'type': 'Z12H',
      'orderDate': '12/01',
      'brand': 'REEBOK',
      'sapSoNumber': '2251250870',
      'line': '12',
      'sapPoNumber': '900332501810',
      'materialCode': '3FG-PR01-LT06-9012',
      'orderQty': 12,
      'batchCardNo': 'Z12H25321035',
      'pcs': 4,
      'sf': 18.60,
      'packDate': '2025/12/6',
      'source': 'Finished leather/成品革',
    });

    await db.insert('so_orders', {
      'requestId': 3,
      'type': 'Z12M',
      'orderDate': '12/02',
      'brand': 'PUMA',
      'sapSoNumber': '2251250875',
      'line': '8',
      'sapPoNumber': '',
      'materialCode': '3FG-PR01-LT07-3456',
      'orderQty': 22,
      'batchCardNo': 'Z12M25322040',
      'pcs': 5,
      'sf': 31.20,
      'packDate': '2025/12/7',
      'source': 'Stock transfer/库存调拨',
    });

    await db.insert('so_orders', {
      'requestId': 3,
      'type': 'Z12H',
      'orderDate': '12/02',
      'brand': 'NIKE',
      'sapSoNumber': '2251250880',
      'line': '18',
      'sapPoNumber': '900332501815',
      'materialCode': '3FG-PR01-LT08-7890',
      'orderQty': 8,
      'batchCardNo': 'Z12H25322045',
      'pcs': 2,
      'sf': 12.80,
      'packDate': '2025/12/8',
      'source': 'Wet blue/蓝湿皮',
    });

    // Request 4 - 1 SO order
    await db.insert('so_orders', {
      'requestId': 4,
      'type': 'Z12H',
      'orderDate': '11/30',
      'brand': 'NIKE',
      'sapSoNumber': '2251250860',
      'line': '5',
      'sapPoNumber': '900332501805',
      'materialCode': '3FG-PR01-LT04-1234',
      'orderQty': 18,
      'batchCardNo': 'Z12H25320025',
      'pcs': 3,
      'sf': 28.90,
      'packDate': '2025/12/4',
      'source': 'Crust leather/皮坯',
    });

    // Insert Production Order Approval Requests (each request has 1 PO item)
    await db.insert('approval_requests', {
      'requestMessage':
          'Production order needs urgent approval - material arrived early and ready for processing.',
      'requesterName': 'David Lee',
      'requestDate': '2025/12/01',
      'requestTime': '11:00 AM',
      'soCount': 1, // For PO requests, this represents PO count
      'status': 'Pending',
    });

    await db.insert('approval_requests', {
      'requestMessage':
          'Rush order for VIP customer - requesting approval to expedite production schedule.',
      'requesterName': 'Linda Martinez',
      'requestDate': '2025/12/02',
      'requestTime': '02:30 PM',
      'soCount': 1,
      'status': 'Pending',
    });

    await db.insert('approval_requests', {
      'requestMessage':
          'Quality inspection complete - all materials meet standards, requesting production approval.',
      'requesterName': 'Robert Kim',
      'requestDate': '2025/11/30',
      'requestTime': '04:15 PM',
      'soCount': 1,
      'status': 'Approved',
    });

    // Insert Production Orders linked to requests (Request IDs 5, 6, 7)
    await db.insert('production_orders', {
      'requestId': 5,
      'type': 'Z12M',
      'orderDate': '12/01',
      'brand': 'ADIDAS',
      'line': '15',
      'sapPoNumber': '900332501820',
      'materialCode': '3FG-PR01-LT09-4567',
      'orderQty': 50,
      'batchCardNo': 'Z12M25323050',
      'pcs': 10,
      'sf': 75.50,
      'packDate': '2025/12/10',
      'source': 'Direct from tannery/直接从制革厂',
    });

    await db.insert('production_orders', {
      'requestId': 6,
      'type': 'Z12H',
      'orderDate': '12/02',
      'brand': 'NIKE',
      'line': '22',
      'sapPoNumber': '900332501825',
      'materialCode': '3FG-PR01-LT10-8901',
      'orderQty': 35,
      'batchCardNo': 'Z12H25324060',
      'pcs': 7,
      'sf': 52.30,
      'packDate': '2025/12/12',
      'source': 'Stock replenishment/库存补充',
    });

    await db.insert('production_orders', {
      'requestId': 7,
      'type': 'Z12M',
      'orderDate': '11/30',
      'brand': 'PUMA',
      'line': '18',
      'sapPoNumber': '900332501830',
      'materialCode': '3FG-PR01-LT11-2345',
      'orderQty': 28,
      'batchCardNo': 'Z12M25322070',
      'pcs': 6,
      'sf': 41.80,
      'packDate': '2025/12/09',
      'source': 'Finished leather/成品革',
    });
  }

  Future<bool> login(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  // Approval Requests functions
  Future<List<ApprovalRequestModel>> getApprovalRequests() async {
    final db = await instance.database;
    final result = await db.query('approval_requests', orderBy: 'id DESC');
    return result.map((json) => ApprovalRequestModel.fromJson(json)).toList();
  }

  Future<List<ApprovalRequestModel>> getPendingRequests() async {
    final db = await instance.database;
    final result = await db.query(
      'approval_requests',
      where: 'status = ?',
      whereArgs: ['Pending'],
      orderBy: 'id DESC',
    );
    return result.map((json) => ApprovalRequestModel.fromJson(json)).toList();
  }

  Future<List<ApprovalRequestModel>> getApprovedRequests() async {
    final db = await instance.database;
    final result = await db.query(
      'approval_requests',
      where: 'status = ?',
      whereArgs: ['Approved'],
      orderBy: 'id DESC',
    );
    return result.map((json) => ApprovalRequestModel.fromJson(json)).toList();
  }

  Future<ApprovalRequestModel?> getApprovalRequest(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'approval_requests',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return ApprovalRequestModel.fromJson(result.first);
  }

  Future<List<SOModel>> getSOOrdersByRequestId(int requestId) async {
    final db = await instance.database;
    final result = await db.query(
      'so_orders',
      where: 'requestId = ?',
      whereArgs: [requestId],
    );
    return result.map((json) => SOModel.fromJson(json)).toList();
  }

  Future<int> approveRequest(int requestId) async {
    final db = await instance.database;

    // Update request status only
    return await db.update(
      'approval_requests',
      {'status': 'Approved'},
      where: 'id = ?',
      whereArgs: [requestId],
    );
  }

  Future<List<ProductionOrderModel>> getProductionOrdersByRequestId(
      int requestId) async {
    final db = await instance.database;
    final result = await db.query(
      'production_orders',
      where: 'requestId = ?',
      whereArgs: [requestId],
    );
    return result.map((json) => ProductionOrderModel.fromJson(json)).toList();
  }

  Future<List<SOModel>> getSOOrders() async {
    final db = await instance.database;
    final result = await db.query('so_orders');
    return result.map((json) => SOModel.fromJson(json)).toList();
  }

  Future<List<ProductionOrderModel>> getProductionOrders() async {
    final db = await instance.database;
    final result = await db.query('production_orders');
    return result.map((json) => ProductionOrderModel.fromJson(json)).toList();
  }
}
