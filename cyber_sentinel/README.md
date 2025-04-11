# Cyber Sentinel

A modern Flutter application for cybersecurity monitoring and encryption. This app provides a user-friendly interface for monitoring system behavior, assessing security threats, and performing encryption operations.

## Features

### 1. Behavioral Monitoring
- Real-time monitoring of system activities
- Event logging with timestamps
- Anomaly detection simulation
- Toggle monitoring on/off

### 2. Threat Intelligence
- Dynamic threat score calculation
- Visual risk level indicators
- Real-time risk assessment
- Interactive threat level display

### 3. Encryption Engine
- RSA key pair generation (simulated)
- Message encryption and decryption
- Copy functionality for encrypted messages
- Key management interface

## Technical Details

### Dependencies
- Flutter SDK
- encrypt: ^5.0.1
- intl: ^0.18.1
- font_awesome_flutter: ^10.5.0
- flutter_secure_storage: ^8.0.0

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── screens/
    ├── home_screen.dart      # Main dashboard
    ├── behavioral_screen.dart # Behavioral monitoring
    ├── threat_screen.dart    # Threat intelligence
    └── encryption_screen.dart # Encryption engine
```

## Getting Started

1. Ensure you have Flutter installed on your system
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

## UI Features
- Material Design implementation
- Responsive layout
- Dark/light theme support
- Interactive animations
- Modern card-based design

## Future Enhancements
- IoT device monitoring module
- Advanced encryption algorithms
- Real-time threat detection
- Cloud backup integration
- Multi-device synchronization

## Contributing
Feel free to submit issues and enhancement requests.

## License
MIT License - feel free to use this project for learning and development.
