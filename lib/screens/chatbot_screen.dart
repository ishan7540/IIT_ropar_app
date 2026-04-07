import 'package:flutter/material.dart';
import 'package:aahar_app/theme.dart';
import 'package:aahar_app/models/chat_message.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Namaste! 🙏 I\'m Krishi AI, your farming assistant.\nनमस्ते! मैं कृषि AI हूँ, आपका खेती सहायक।\n\nAsk me about:\n• Fertilizer advice / उर्वरक सलाह\n• Crop guidance / फसल मार्गदर्शन\n• Weather tips / मौसम सुझाव\n• Government schemes / सरकारी योजनाएं',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
  bool _isTyping = false;

  final List<String> _suggestions = [
    'Best fertilizer for wheat? / गेहूं के लिए सबसे अच्छा उर्वरक?',
    'Government schemes / सरकारी योजनाएं',
    'When to irrigate? / कब सिंचाई करें?',
    'Soil pH improvement / मिट्टी पीएच सुधार',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    // TODO: Replace with actual Gemini API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: _getMockResponse(text),
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  String _getMockResponse(String query) {
    final q = query.toLowerCase();
    if (q.contains('fertilizer') || q.contains('उर्वरक')) {
      return 'Based on your soil data, I recommend:\n\n'
          '1. **Urea**: 87 kg/acre for Nitrogen\n'
          '2. **DAP**: 43 kg/acre for Phosphorus\n'
          '3. **MOP**: 33 kg/acre for Potassium\n\n'
          'Apply in 3 equal splits for best results.\n'
          'सर्वोत्तम परिणामों के लिए 3 बराबर भागों में डालें।';
    }
    if (q.contains('scheme') || q.contains('योजना')) {
      return '📋 Available Government Schemes:\n\n'
          '1. **PM-KISAN**: ₹6,000/year direct benefit\n'
          '2. **Soil Health Card**: Free soil testing\n'
          '3. **PMFBY**: Crop insurance at low premium\n'
          '4. **KCC**: Kisan Credit Card for easy loans\n\n'
          'Visit your nearest Krishi Vigyan Kendra for details.\n'
          'अधिक जानकारी के लिए निकटतम कृषि विज्ञान केंद्र जाएं।';
    }
    if (q.contains('irrigat') || q.contains('water') || q.contains('सिंचाई')) {
      return 'Based on current soil moisture (22%) and weather:\n\n'
          '💧 Irrigate tomorrow morning (6-8 AM)\n'
          '• Current moisture: 22% (below optimal 30%)\n'
          '• No rain expected for 3 days\n'
          '• Use drip irrigation to save 40% water\n\n'
          'कल सुबह 6-8 बजे सिंचाई करें। ड्रिप सिंचाई से 40% पानी बचाएं।';
    }
    return 'Thank you for your question! I\'m analyzing your farm data to give you the best advice.\n\n'
        'आपके प्रश्न के लिए धन्यवाद! मैं आपको सबसे अच्छी सलाह देने के लिए आपके खेत के डेटा का विश्लेषण कर रहा हूँ।\n\n'
        '💡 Tip: For more accurate answers, keep your soil data updated.\n'
        'सटीक उत्तर के लिए अपना मिट्टी डेटा अपडेट रखें।';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.smart_toy,
                  color: AppTheme.primaryContainer, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Krishi AI / कृषि AI',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  _isTyping ? 'Typing...' : 'Online',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.statusOptimal,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Suggestion chips
          if (_messages.length <= 2)
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestions.length,
                separatorBuilder: (_, a) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ActionChip(
                    label: Text(
                      _suggestions[index],
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.primaryContainer,
                          ),
                    ),
                    backgroundColor:
                        AppTheme.primaryContainer.withValues(alpha: 0.08),
                    side: BorderSide(
                        color: AppTheme.primaryContainer.withValues(alpha: 0.2)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () => _sendMessage(_suggestions[index]),
                  );
                },
              ),
            ),

          const SizedBox(height: 8),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                  color: Colors.black.withValues(alpha: 0.04),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Ask anything / कुछ भी पूछें...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.surfaceContainerHigh,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () => _sendMessage(_textController.text),
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.smart_toy,
                  color: AppTheme.primaryContainer, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser
                    ? AppTheme.primaryContainer
                    : AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft:
                      isUser ? const Radius.circular(20) : Radius.zero,
                  bottomRight:
                      isUser ? Radius.zero : const Radius.circular(20),
                ),
                boxShadow: isUser ? null : AppTheme.subtleShadow,
              ),
              child: Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isUser ? Colors.white : AppTheme.onSurface,
                      height: 1.5,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.smart_toy,
                color: AppTheme.primaryContainer, size: 18),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: AppTheme.subtleShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.onSurfaceVariant
                .withValues(alpha: 0.3 + (0.4 * value)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
