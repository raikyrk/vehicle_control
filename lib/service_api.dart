import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class ApiService {
  static String get apiUrl => dotenv.env['API_URL']!;

  static Future<List<Map<String, dynamic>>> fetchConferentes() async {
    final response = await http.get(Uri.parse('$apiUrl/get_conferentes.php'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    throw Exception('Erro ao carregar conferentes');
  }

  static Future<bool> registerEntrada({
    required String conferenteId,
    required String placa,
    required String modelo,
    required String motorista,
    required String idMotorista,
  }) async {
    final registro = {
      'conferente_id': conferenteId,
      'placa': placa.toUpperCase(),
      'modelo': modelo,
      'motorista': motorista,
      'id_motorista': idMotorista,
      'data_registro': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'horario_chegada': DateFormat('HH:mm').format(DateTime.now()),
    };

    final response = await http.post(
      Uri.parse('$apiUrl/register_entrada.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(registro),
    );

    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Erro ao registrar entrada');
  }

  static Future<Map<String, dynamic>?> searchVehicle(String placa) async {
    final response = await http.get(
      Uri.parse('$apiUrl/search_vehicle.php?placa=$placa'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'dentro') {
        return data;
      }
      return null;
    }
    throw Exception('Erro ao buscar veículo');
  }

  static Future<bool> registerSaida(String placa) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register_saida.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'placa': placa.toUpperCase(),
        'horario_saida': DateFormat('HH:mm').format(DateTime.now()),
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Erro ao registrar saída');
  }
}