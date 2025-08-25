import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/core/services/receipt_service.dart';

class CustomShareSheet extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onNativeShare;
  final Map<String, dynamic>? receiptData;

  const CustomShareSheet({
    super.key,
    this.onClose,
    this.onNativeShare,
    this.receiptData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildShareOptions(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'As a message',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textGray,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 20, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareOption(
                'Messenger',
                Icons.chat_bubble_outline,
                const Color(0xFF0084FF),
                () => _shareToApp(context, 'Messenger'),
              ),
              _buildShareOption(
                'WhatsApp',
                Icons.phone,
                const Color(0xFF25D366),
                () => _shareToApp(context, 'WhatsApp'),
              ),
              _buildShareOption(
                'Telegram',
                Icons.send,
                const Color(0xFF0088CC),
                () => _shareToApp(context, 'Telegram'),
              ),
              _buildShareOption(
                'WeChat',
                Icons.chat,
                const Color(0xFF07C160),
                () => _shareToApp(context, 'WeChat'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildNativeShareOption(context),
        ],
      ),
    );
  }

  Widget _buildShareOption(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(icon, color: Colors.white, size: 28)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNativeShareOption(BuildContext context) {
    return GestureDetector(
      onTap: () => _showNativeShare(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.share, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              'Share PDF Receipt',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareToApp(BuildContext context, String appName) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membagikan ke $appName...'),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // TODO: Implement actual sharing to specific apps using url_launcher
    // This would check if the app is installed and open it with the receipt
  }

  void _showNativeShare(BuildContext context) async {
    Navigator.pop(context);

    if (receiptData != null) {
      try {
        final denominations = [
          {'denom': '1.000', 'quantity': '87', 'total': '87.000'},
          {'denom': '2.000', 'quantity': '533', 'total': '1.066.000'},
          {'denom': '5.000', 'quantity': '96', 'total': '480.000'},
          {'denom': '10.000', 'quantity': '64', 'total': '640.000'},
          {'denom': '20.000', 'quantity': '53', 'total': '1.060.000'},
          {'denom': '50.000', 'quantity': '331', 'total': '16.550.000'},
          {'denom': '100.000', 'quantity': '367', 'total': '36.700.000'},
        ];

        await ReceiptService.shareReceiptSimple(
          reference: receiptData!['reference'] ?? 'KSN001250710211500176',
          total: receiptData!['total'] ?? 'Rp 56.583.000',
          date: receiptData!['date'] ?? '10/07/2025',
          time: receiptData!['time'] ?? '21:39:54',
          location:
              receiptData!['location'] ?? 'PT Warung Sejahtera Maju Makmur',
          name: receiptData!['name'] ?? 'Wahid',
          transactionType: receiptData!['transactionType'] ?? 'Setoran',
          denominations: denominations,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Receipt shared successfully!'),
              backgroundColor: AppColors.successGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to share receipt: ${e.toString()}'),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } else if (onNativeShare != null) {
      onNativeShare!();
    }
  }
}
