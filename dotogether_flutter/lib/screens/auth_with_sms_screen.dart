import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

class AuthWithSmsScreen extends StatefulWidget {
  const AuthWithSmsScreen({super.key});

  @override
  State<AuthWithSmsScreen> createState() => _AuthWithSmsScreenState();
}

class _AuthWithSmsScreenState extends State<AuthWithSmsScreen> {
  final TextEditingController _phoneController = TextEditingController(
    text: "+358442023855",
  ); // Pre-filled from screenshot
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _navigateBackToWelcome() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeStep = appState.registrationStep;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(
          0xFF2196F3,
        ), // Vibrant Blue from screenshot
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Back',
          onPressed: _navigateBackToWelcome,
        ),
        title: const Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step 1 Widget Row
                _buildStepperRow(
                  stepNumber: 1,
                  title: 'Your phone number',
                  subtitle: 'Phone number with country code (+xxxx)',
                  isActive: activeStep >= 1,
                  isCompleted: activeStep > 1,
                  child: activeStep == 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                fontSize: 18,
                                letterSpacing: 0.5,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'example +123456789',
                                hintStyle: TextStyle(color: Colors.grey),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2196F3),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2196F3),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (!value.startsWith('+')) {
                                  return 'Invalid phone number. Must start with +';
                                }
                                return null;
                              },
                            ),
                            if (appState.phoneError.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                appState.phoneError,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 140,
                              height: 42,
                              child: ElevatedButton(
                                onPressed: appState.isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          appState.sendSmsCode(
                                            _phoneController.text,
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2196F3),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  elevation: 2,
                                ),
                                child: appState.isLoading && activeStep == 1
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Text(
                                        'CONTINUE',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        )
                      : null,
                ),

                // Connector 1-2
                _buildConnectorLine(isCompleted: activeStep > 1),

                // Step 2 Widget Row
                _buildStepperRow(
                  stepNumber: 2,
                  title: 'Requesting SMS verification code',
                  subtitle: activeStep == 2
                      ? 'in progress ...'
                      : (activeStep > 2
                            ? 'code sent successfully'
                            : 'pending phone number'),
                  isActive: activeStep >= 2,
                  isCompleted: activeStep > 2,
                  child: activeStep == 2
                      ? const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2196F3),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Requesting code from Firebase...',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),

                // Connector 2-3
                _buildConnectorLine(isCompleted: activeStep > 2),

                // Step 3 Widget Row
                _buildStepperRow(
                  stepNumber: 3,
                  title: 'Verifying phone number',
                  subtitle: activeStep == 3
                      ? 'Check SMS we sent you'
                      : 'pending SMS code request',
                  isActive: activeStep >= 3,
                  isCompleted: activeStep > 3,
                  child: activeStep == 3
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              '6-digit verification code',
                              style: TextStyle(
                                color: Color(0xFF2196F3),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextFormField(
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              style: const TextStyle(
                                fontSize: 20,
                                letterSpacing: 4.0,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                hintText: '123456',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 0,
                                ),
                                counterText: '',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2196F3),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2196F3),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            if (appState.smsCodeError.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                appState.smsCodeError,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                SizedBox(
                                  width: 140,
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: appState.isLoading
                                        ? null
                                        : () async {
                                            bool success = await appState
                                                .verifySmsCode(
                                                  _codeController.text,
                                                );
                                            if (success && context.mounted) {
                                              Navigator.of(
                                                context,
                                              ).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen(),
                                                ),
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2196F3),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: appState.isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            'VERIFY',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                TextButton(
                                  onPressed: appState.isLoading
                                      ? null
                                      : () => appState.resetStepper(),
                                  child: const Text(
                                    'GO BACK',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepperRow({
    required int stepNumber,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isCompleted,
    Widget? child,
  }) {
    Color circleColor = Colors.grey.shade400;
    Color titleColor = Colors.grey.shade600;
    Color subtitleColor = Colors.grey.shade500;

    if (isActive) {
      circleColor = Colors.grey.shade700;
      titleColor = Colors.black87;
      subtitleColor = Colors.grey.shade700;
    }
    if (isCompleted) {
      circleColor = const Color(0xFF4CAF50); // Completed green
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number Circle
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Text(
            stepNumber.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Step details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: subtitleColor, fontSize: 13),
              ),
              ?child,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectorLine({required bool isCompleted}) {
    return Container(
      width: 2,
      height: 48,
      margin: const EdgeInsets.only(left: 17, top: 4, bottom: 4),
      color: isCompleted ? const Color(0xFF4CAF50) : Colors.grey.shade300,
    );
  }
}
