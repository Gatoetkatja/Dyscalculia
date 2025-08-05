import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? _user;
  Map<String, dynamic>? _backendUser;
  bool _loading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
  );

  Future<void> _handleSignIn() async {
    setState(() {
      _loading = true;
    });

    try {
      final account = await _googleSignIn.signIn();
      final auth = await account?.authentication;
      final idToken = auth?.idToken;

      print(idToken);

      setState(() {
        _user = account;
      });

      // API call to backend
      final response = await post(
        Uri.parse('http://31.97.49.105/prediksi'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "age": 10,
          "srt": 380,
          "dot_rt": 2500,
          "dot_acc": 0.85,
          "stroop_rt": 1000,
          "stroop_acc": 0.78,
          "add_rt": 3000,
          "add_acc": 0.82,
          "mult_rt": 4000,
          "mult_acc": 0.65,
          "subs_rt": 3400,
          "subs_acc": 0.75
        })
      );
      print(response.body);

    } catch (err) {
      print(err);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4DD0E1), // Light teal
              Color(0xFF26C6DA), // Medium teal
              Color(0xFF00BCD4), // Darker teal
            ],
          ),
        ),
        child: SafeArea(
          child: _user == null ? _buildLoginScreen() : _buildUserScreen(),
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Column(
      children: [
        // Top section with title and subtitle
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Dysec',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tes Kemampuan Matematika',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'untuk Deteksi Dini Diskalkulia',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),

        // Bottom section with login card
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Selamat Datang!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Masuk dengan akun Google Anda\nuntuk memulai tes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Google Sign In Button
                      _loading 
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4285F4)),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _handleSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4285F4),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.g_mobiledata,
                                      color: Color(0xFF4285F4),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Masuk dengan Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      
                      const SizedBox(height: 24),
                      
                      // Security info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.security,
                            color: Colors.green[600],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Data Anda aman dan terlindungi',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Footer text
                const Text(
                  'Dengan masuk, Anda menyetujui',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle terms of service
                      },
                      child: const Text(
                        'Syarat Layanan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Text(
                      '  dan  ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle privacy policy
                      },
                      child: const Text(
                        'Kebijakan Privasi',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserScreen() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: _user!.photoUrl != null 
                    ? NetworkImage(_user!.photoUrl!) 
                    : null,
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: _user!.photoUrl == null 
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
                ),
                const SizedBox(height: 24),
                Text(
                  "Halo, ${_user!.displayName ?? 'User'}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _user!.email ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_backendUser != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    "Backend ID: ${_backendUser!['id']}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _googleSignIn.signOut();
                      setState(() {
                        _user = null;
                        _backendUser = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Keluar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}