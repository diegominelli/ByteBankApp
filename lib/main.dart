// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

void main() => runApp(const BytebankApp());

class BytebankApp extends StatelessWidget {
  const BytebankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: ListaTransferencias(),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  FormularioTransferencia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Criando Transferência'),
        ),
        body: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoNumeroConta,
              dica: '0000',
              rotulo: 'Numero da conta',
              icone: null,
            ),
            Editor(
              controlador: _controladorCampoValor,
              dica: '0.00',
              rotulo: 'valor',
              icone: Icons.monetization_on,
            ),
            ElevatedButton(
              // ignore: sort_child_properties_last
              child: const Text('Confirmar'),
              style: style,
              onPressed: () => _criaTransferencia(_controladorCampoValor,
                  _controladorCampoNumeroConta, context),
            ),
          ],
        ));
  }
}

void _criaTransferencia(_controladorCampoValor, _controladorCampoNumeroConta,
    BuildContext context) {
  final int? numeroConta = int.tryParse(_controladorCampoNumeroConta.text);
  final double? valor = double.tryParse(_controladorCampoValor.text);
  if (numeroConta != null && valor != null) {
    final transferenciaCriada = Transferencia(valor, numeroConta);
    debugPrint('Criando transferencia');
    debugPrint('$transferenciaCriada');
    Navigator.pop(context, transferenciaCriada);
  }
}

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData? icone;

  const Editor({
    Key? key,
    required this.controlador,
    required this.rotulo,
    required this.dica,
    required this.icone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: const TextStyle(fontSize: 24.0),
        // ignore: prefer_const_constructors
        decoration: InputDecoration(
          // ignore: unnecessary_null_comparison
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListaTransferencias extends StatelessWidget {
  const ListaTransferencias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
      ),
      body: Column(children: <Widget>[
        ItemTransferencia(Transferencia(100.0, 1000)),
        ItemTransferencia(Transferencia(200.0, 1001)),
        ItemTransferencia(Transferencia(300.0, 1100)),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida) {
            debugPrint('chegou no then do print');
            debugPrint('$transferenciaRecebida');
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  // ignore: use_key_in_widget_constructors
  const ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: const Icon(Icons.monetization_on),
      title: Text(_transferencia.valor.toString()),
      subtitle: Text(_transferencia.numeroConta.toString()),
    ));
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}
