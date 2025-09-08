import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/animations/advanced_animations.dart';
import '../../../../core/security/security_manager.dart';

class FeatureShowcasePage extends StatefulWidget {
  const FeatureShowcasePage({super.key});

  @override
  State<FeatureShowcasePage> createState() => _FeatureShowcasePageState();
}

class _FeatureShowcasePageState extends State<FeatureShowcasePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isShaking = false;
  bool _isBouncing = false;
  bool _isPulsing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 TAEatz Advanced Features'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildFeatureGrid(),
                const SizedBox(height: 24),
                _buildAnimationShowcase(),
                const SizedBox(height: 24),
                _buildSecurityShowcase(),
                const SizedBox(height: 24),
                _buildPerformanceShowcase(),
                const SizedBox(height: 24),
                _buildAdvancedFeatures(),
                const SizedBox(height: 24),
                _buildFutureFeatures(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎉 Welcome to TAEatz 2.0',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Experience the future of food delivery with cutting-edge technology and advanced features.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard('50+', 'Features', Colors.white),
              const SizedBox(width: 16),
              _buildStatCard('99.9%', 'Uptime', Colors.white),
              const SizedBox(width: 16),
              _buildStatCard('4.9★', 'Rating', Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {'icon': '🍕', 'title': 'Smart Search', 'desc': 'AI-powered recommendations'},
      {'icon': '🚚', 'title': 'Real-time Tracking', 'desc': 'Live order updates'},
      {'icon': '💳', 'title': 'Crypto Payments', 'desc': 'Blockchain integration'},
      {'icon': '🎯', 'title': 'AR Menu', 'desc': 'Augmented reality dining'},
      {'icon': '🎤', 'title': 'Voice Orders', 'desc': 'Hands-free ordering'},
      {'icon': '🏠', 'title': 'Smart Home', 'desc': 'IoT integration'},
      {'icon': '🔒', 'title': 'Biometric Auth', 'desc': 'Advanced security'},
      {'icon': '📊', 'title': 'Analytics', 'desc': 'Performance monitoring'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🌟 Core Features',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return _buildFeatureCard(
              feature['icon']!,
              feature['title']!,
              feature['desc']!,
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎬 Animation Showcase',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AdvancedAnimations.morphingButton(
                onTap: () {
                  setState(() {
                    _isShaking = !_isShaking;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Shake Me!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdvancedAnimations.morphingButton(
                onTap: () {
                  setState(() {
                    _isBouncing = !_isBouncing;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Bounce Me!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AdvancedAnimations.shakeAnimation(
          shouldShake: _isShaking,
          child: AdvancedAnimations.bounceAnimation(
            shouldBounce: _isBouncing,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '🎉 Interactive Animations!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔒 Security Features',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Column(
            children: [
              const Icon(Icons.security, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Advanced Security',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Biometric authentication, data encryption, and secure storage protect your information.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final isAvailable = await SecurityManager.instance.isBiometricAvailable();
                  if (isAvailable) {
                    final success = await SecurityManager.instance.authenticateWithBiometrics(
                      reason: 'Authenticate to access security features',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? 'Authentication successful!' : 'Authentication failed'),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Biometric authentication not available'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.fingerprint),
                label: const Text('Test Biometric Auth'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📊 Performance Monitoring',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            children: [
              const Icon(Icons.speed, size: 48, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Real-time Performance',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Monitor app performance, memory usage, and response times in real-time.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Mock performance report
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Performance Report'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Memory Usage: 45.2 MB'),
                          Text('CPU Usage: 12.5%'),
                          Text('Frame Rate: 60.0 FPS'),
                          Text('Response Time: 150ms'),
                          Text('Error Count: 0'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.analytics),
                label: const Text('View Performance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🚀 Advanced Features',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildFeatureList([
          '🤖 Machine Learning: Smart recommendations and predictive analytics',
          '🎯 Augmented Reality: AR menu viewing and virtual restaurant tours',
          '🎤 Voice Interface: Hands-free ordering and voice search',
          '🏠 IoT Integration: Smart home and wearable device support',
          '⛓️ Blockchain: Cryptocurrency payments and NFT rewards',
          '📱 Cross-platform: Seamless experience across all devices',
          '🌐 Offline Mode: Full functionality without internet connection',
          '♿ Accessibility: Screen reader support and voice commands',
        ]),
      ],
    );
  }

  Widget _buildFutureFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔮 Future Features',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildFeatureList([
          '🧠 AI Chef: Personalized recipe recommendations',
          '🌍 Global Expansion: Multi-language and multi-currency support',
          '🚁 Drone Delivery: Autonomous delivery system',
          '🍽️ Virtual Dining: VR restaurant experiences',
          '📊 Advanced Analytics: Business intelligence dashboard',
          '🔗 Social Integration: Community features and sharing',
          '🎮 Gamification: Rewards and achievement system',
          '🌱 Sustainability: Carbon footprint tracking',
        ]),
      ],
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: features.map((feature) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature.split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature.substring(feature.indexOf(' ') + 1),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}
