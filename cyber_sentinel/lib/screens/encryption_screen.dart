import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';

class EncryptionScreen extends StatefulWidget {
  const EncryptionScreen({super.key});

  @override
  State<EncryptionScreen> createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? _encryptedMessage;
  String? _originalMessage;
  bool _isEncrypted = false;
  final _formKey = GlobalKey<FormState>();

  // Simulate RSA key pair
  final Map<String, String> _keyPair = {
    'public': 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7JHoJfg6yNzLMOWet8Z49a4KD',
    'private': 'MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALskegl+DrI3Msw5'
  };

  String _simulateEncryption(String message) {
    // Simple simulation of encryption
    final bytes = utf8.encode(message);
    final base64 = base64Encode(bytes);
    return base64;
  }

  String _simulateDecryption(String encrypted) {
    try {
      final bytes = base64Decode(encrypted);
      return utf8.decode(bytes);
    } catch (e) {
      return 'Decryption failed';
    }
  }

  void _encryptMessage() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _originalMessage = _messageController.text;
      _encryptedMessage = _simulateEncryption(_messageController.text);
      _isEncrypted = true;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message encrypted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _decryptMessage() {
    if (_encryptedMessage == null) return;

    setState(() {
      _messageController.text = _simulateDecryption(_encryptedMessage!);
      _isEncrypted = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message decrypted successfully!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _generateNewKeys() {
    // Simulate key generation
    final random = Random();
    final newPublicKey = base64Encode(List<int>.generate(32, (i) => random.nextInt(256)));
    final newPrivateKey = base64Encode(List<int>.generate(32, (i) => random.nextInt(256)));

    setState(() {
      _keyPair['public'] = newPublicKey;
      _keyPair['private'] = newPrivateKey;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Keys Generated'),
        content: const Text('A new RSA key pair has been generated successfully.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encryption Engine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateNewKeys,
            tooltip: 'Generate New Keys',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RSA Key Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    _buildKeyInfo('Public Key', _keyPair['public']!),
                    const SizedBox(height: 8),
                    _buildKeyInfo('Private Key', _keyPair['private']!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Message',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your message',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a message';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_encryptedMessage != null) ...[
                        Text(
                          'Encrypted Message:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _encryptedMessage!,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                    text: _encryptedMessage!,
                                  ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Copied to clipboard'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isEncrypted ? null : _encryptMessage,
                  icon: const Icon(Icons.lock),
                  label: const Text('Encrypt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isEncrypted ? _decryptMessage : null,
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Decrypt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyInfo(String title, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  key,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: key));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Key copied to clipboard'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
