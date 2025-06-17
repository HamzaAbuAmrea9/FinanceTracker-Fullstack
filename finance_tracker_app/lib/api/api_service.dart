
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';


class ApiService {
  
  // For iOS simulator, you would use 'http://localhost:7014'
  static const String _baseUrl = 'https://192.168.1.8:7014/api';

  
  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // If login is successful, the response body is the JWT token
        return response.body;
      } else {
        
        print('Login failed: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      
      print('An error occurred during login: $e');
      return null;
    }
  }




Future<List<Transaction>> getTransactions(String token) async {
    final url = Uri.parse('$_baseUrl/transactions');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Transaction> transactions = body
            .map(
              (dynamic item) => Transaction.fromJson(item),
            )
            .toList();
        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }






  Future<List<Category>> getCategories(String token) async {
    final url = Uri.parse('$_baseUrl/transactions/categories');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  
  Future<void> createTransaction(String token, Map<String, dynamic> transactionData) async {
    final url = Uri.parse('$_baseUrl/transactions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transactionData),
    );

    if (response.statusCode != 201) { // 201 Created
      throw Exception('Failed to create transaction');
    }
  }



   Future<void> deleteTransaction(String token, int transactionId) async {
    
    final url = Uri.parse('$_baseUrl/transactions/$transactionId');
    
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // A successful DELETE returns a 204 No Content status
      if (response.statusCode != 204) {
        
        throw Exception('Failed to delete transaction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while deleting transaction: $e');
    }
  }
  
   Future<bool> register(String username, String password) async {
    final url = Uri.parse('$_baseUrl/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'username': username, 'password': password}),
      );
     
      return response.statusCode == 200;
    } catch (e) {
      print('An error occurred during registration: $e');
      return false;
    }
  }
  
}


