import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';



class UPIQRGenerator extends StatefulWidget {
  @override
  _UPIQRGeneratorState createState() => _UPIQRGeneratorState();
}

class _UPIQRGeneratorState extends State<UPIQRGenerator> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController upiIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String? qrData;

  void generateQR() {
    if (_formKey.currentState!.validate()) {
      String upiId = upiIdController.text.trim();
      String name = nameController.text.trim();
      String amount = amountController.text.trim();

      // UPI URI format
      String data =
          "upi://pay?pa=$upiId&pn=$name&am=$amount&cu=INR";

      setState(() {
        qrData = data;
      });
    }
  }

  @override
  void dispose() {
    upiIdController.dispose();
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI Quick QR Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: upiIdController,
                  decoration: InputDecoration(
                    labelText: 'UPI ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter UPI ID';
                    }
                    if (!value.contains('@')) {
                      return 'Invalid UPI ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Payee Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter name' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    final double? val = double.tryParse(value);
                    if (val == null || val <= 0) {
                      return 'Enter valid amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: generateQR,
                  child: Text('Generate QR Code'),
                ),
                SizedBox(height: 24),
                if (qrData != null) ...[
                  Text(
                    'Scan this QR in PhonePe, Paytm, GPay etc.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  QrImageView(
                    data: qrData!,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
