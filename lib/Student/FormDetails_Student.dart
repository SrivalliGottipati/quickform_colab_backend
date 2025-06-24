import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class FormDetailsScreen extends StatelessWidget {
  final Map<String, String> form;

  const FormDetailsScreen({Key? key, required this.form}) : super(key: key);

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Link copied to clipboard"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }

  Future<void> _openLink(BuildContext context, String url) async {
    if (url.trim().isEmpty) {
      _showError(context, "Link is empty");
      return;
    }

    if (!url.contains("://")) {
      url = "https://$url";
    }

    final Uri uri = Uri.parse(url);

    try {
      // 1. Try external application first
      bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

      // 2. Fallback to in-app web view if external fails
      if (!launched) {
        launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }

      // 3. Final fallback (platform default)
      if (!launched) {
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }

      if (!launched) {
        _showError(context, "No app found to open this link.");
      }
    } catch (e) {
      _showError(context, "Failed to open link: $e");
    }
  }




  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = form['title'] ?? '';
    final String description = form['description'] ?? '';
    final String deadline = form['deadline'] ?? '';
    final String link = form['link'] ?? '';
    final String group = form['group'] ?? 'General';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Color.fromARGB(255, 86, 198, 242),
            Color.fromARGB(255, 128, 198, 242),
            Color.fromARGB(255, 139, 227, 244),
            Color.fromARGB(255, 210, 227, 244),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Form Details", style: GoogleFonts.montserrat(color: Colors.black)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField("Title", title),
                _buildField("Group", group),
                _buildField("Description", description),
                _buildField("Deadline", deadline, valueColor: Colors.redAccent),

                const SizedBox(height: 24),
                Text(
                  "Form Link",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blueAccent.shade100),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _openLink(context, link),
                          child: Text(
                            link,
                            style: GoogleFonts.montserrat(
                              color: Colors.blue.shade800,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, size: 20),
                        onPressed: () => _copyToClipboard(context, link),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _openLink(context, link),
                    icon: Icon(Icons.open_in_new),
                    label: Text(
                      "Open Link",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(142, 224, 243, 1),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueGrey.shade100),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
