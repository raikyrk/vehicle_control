import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'service_api.dart';

class EntradaForm extends StatefulWidget {
  const EntradaForm({super.key});

  @override
  _EntradaFormState createState() => _EntradaFormState();
}

class _EntradaFormState extends State<EntradaForm> {
  List<Map<String, dynamic>> conferentes = [];
  String? selectedConferente;
  final TextEditingController placaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController motoristaController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  bool showSuccess = false;

  @override
  void initState() {
    super.initState();
    _fetchConferentes();
  }

  Future<void> _fetchConferentes() async {
    try {
      final data = await ApiService.fetchConferentes();
      setState(() {
        conferentes = data;
        if (conferentes.isNotEmpty) {
          selectedConferente = conferentes[0]['nome'];
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  Future<void> _registerEntrada() async {
    if (selectedConferente == null ||
        placaController.text.isEmpty ||
        modeloController.text.isEmpty ||
        motoristaController.text.isEmpty ||
        idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    try {
      final conferente = conferentes.firstWhere((c) => c['nome'] == selectedConferente);
      await ApiService.registerEntrada(
        conferenteId: conferente['id'].toString(),
        placa: placaController.text,
        modelo: modeloController.text,
        motorista: motoristaController.text,
        idMotorista: idController.text,
      );
      setState(() {
        showSuccess = true;
        placaController.clear();
        modeloController.clear();
        motoristaController.clear();
        idController.clear();
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() => showSuccess = false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              border: const Border(
                left: BorderSide(color: Color(0xFF3B82F6), width: 4),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(FeatherIcons.info, color: Color(0xFF2563EB), size: 20),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Preencha todos os campos para registrar a entrada do veículo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E40AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DropdownButtonFormField<String>(
            value: selectedConferente,
            decoration: InputDecoration(
              labelText: 'Conferente (Porteiro) *',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B0B0B),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: conferentes.map((conferente) {
              return DropdownMenuItem<String>(
                value: conferente['nome'],
                child: Text(conferente['nome']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedConferente = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: placaController,
                  decoration: InputDecoration(
                    labelText: 'Placa *',
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B0B0B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  textAlign: TextAlign.center,
                  maxLength: 8,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: modeloController,
                  decoration: InputDecoration(
                    labelText: 'Modelo *',
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B0B0B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: motoristaController,
            decoration: InputDecoration(
              labelText: 'Motorista *',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B0B0B),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: idController,
            decoration: InputDecoration(
              labelText: 'Identidade (ID) *',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B0B0B),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _registerEntrada,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.black26,
              elevation: 4,
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF6A00), Color(0xFFFF8B3D)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FeatherIcons.checkCircle, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Registrar Entrada',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showSuccess)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                border: const Border(
                  left: BorderSide(color: Color(0xFF16A34A), width: 4),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(FeatherIcons.checkCircle, color: Color(0xFF16A34A), size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Entrada registrada com sucesso!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    placaController.dispose();
    modeloController.dispose();
    motoristaController.dispose();
    idController.dispose();
    super.dispose();
  }
}

class SaidaForm extends StatefulWidget {
  const SaidaForm({super.key});

  @override
  _SaidaFormState createState() => _SaidaFormState();
}

class _SaidaFormState extends State<SaidaForm> {
  final TextEditingController placaController = TextEditingController();
  bool showSuccess = false;
  bool showVehicleInfo = false;
  Map<String, dynamic>? vehicleInfo;

  Future<void> _searchVehicle() async {
    final placa = placaController.text.toUpperCase();
    if (placa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite a placa do veículo')),
      );
      return;
    }

    try {
      final data = await ApiService.searchVehicle(placa);
      setState(() {
        vehicleInfo = data;
        showVehicleInfo = data != null;
      });
      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veículo não encontrado ou já saiu')),
        );
      }
    } catch (e) {
      setState(() => showVehicleInfo = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  Future<void> _registerSaida() async {
    final placa = placaController.text.toUpperCase();
    if (placa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite a placa do veículo')),
      );
      return;
    }

    try {
      await ApiService.registerSaida(placa);
      setState(() {
        showSuccess = true;
        showVehicleInfo = false;
        placaController.clear();
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() => showSuccess = false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              border: const Border(
                left: BorderSide(color: Color(0xFFFF6A00), width: 4),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(FeatherIcons.info, color: Color(0xFFFF6A00), size: 20),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Digite a placa do veículo que está saindo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7C2D12),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextFormField(
            controller: placaController,
            decoration: InputDecoration(
              labelText: 'Placa do Veículo *',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B0B0B),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: const Icon(FeatherIcons.search, color: Color(0xFF6B7280)),
            ),
            textCapitalization: TextCapitalization.characters,
            textAlign: TextAlign.center,
            maxLength: 8,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _searchVehicle,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.black26,
              elevation: 4,
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FeatherIcons.search, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Buscar Veículo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showVehicleInfo && vehicleInfo != null)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                border: Border.all(color: const Color(0xFFFBBF24), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(FeatherIcons.info, color: Color(0xFFFBBF24), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Informações do Veículo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B0B0B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Motorista: ${vehicleInfo!['motorista']}',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                  ),
                  Text(
                    'Modelo: ${vehicleInfo!['modelo']}',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                  ),
                  Text(
                    'Entrada: ${vehicleInfo!['horario_chegada']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF16A34A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _registerSaida,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.black26,
              elevation: 4,
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF16A34A), Color(0xFF15803D)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FeatherIcons.checkCircle, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Registrar Saída',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showSuccess)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                border: const Border(
                  left: BorderSide(color: Color(0xFF16A34A), width: 4),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(FeatherIcons.checkCircle, color: Color(0xFF16A34A), size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Saída registrada com sucesso!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    placaController.dispose();
    super.dispose();
  }
}