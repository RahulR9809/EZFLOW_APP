import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We respect your privacy and are committed to protecting your personal information. This policy outlines how we collect, use, and safeguard your data.',
            ),
            SizedBox(height: 16),
            Text(
              'Information We Collect:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Account Information: Name, email address, and contact details.',
            ),
            Text(
              '- Inventory Data: Product descriptions, quantities, prices, etc.',
            ),
            Text(
              '- Device Information: Device identifiers, IP address, and operating system details.',
            ),
            SizedBox(height: 16),
            Text(
              'How We Use Your Information:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Provide and improve our inventory management services.',
            ),
            Text(
              '- Communicate with you about your account and updates.',
            ),
            Text(
              '- Analyze user interactions to enhance our services.',
            ),
            SizedBox(height: 16),
            Text(
              'Data Sharing:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Share data with service providers to assist in providing our services.',
            ),
            Text(
              '- Disclose information when required by law.',
            ),
            SizedBox(height: 16),
            Text(
              'Your Choices:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Review and update account information within the app.',
            ),
            Text(
              '- Opt-out of promotional communications.',
            ),
            SizedBox(height: 16),
            Text(
              'Security:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We employ measures to protect your information from unauthorized access or disclosure.',
            ),
            SizedBox(height: 16),
            Text(
              'Changes to This Policy:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We may update this policy and will notify you of any changes.',
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you have questions or concerns, please contact us.',
            ),
          ],
        ),
      ),
    );
  }
}



class TermsOfUse extends StatelessWidget {
  const TermsOfUse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const Text(
            'Terms of Use',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'These Terms of Use govern your use of ELZFLOW, By accessing or using the App, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use the App.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('1. Use of the App'),
          _buildList([
            'The App is intended solely for use by shop owners for managing their inventory.',
            'You must be of legal age in your jurisdiction to use the App. By using the App, you represent that you are of legal age.',
            'You agree to use the App in accordance with these Terms and all applicable laws and regulations.',
          ]),
          _buildSectionTitle('2. Account Registration'),
          _buildList([
            'You may need to register for an account to access certain features of the App.',
            'You agree to provide accurate and complete information when creating an account.',
            'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
          ]),
          _buildSectionTitle('3. Intellectual Property'),
          _buildList([
            'The App and its content, including but not limited to text, graphics, logos, and images, are the property of [Your Company Name] and are protected by copyright and other intellectual property laws.',
            'You may not modify, reproduce, distribute, or create derivative works based on the App or its content without our prior written consent.',
          ]),
          _buildSectionTitle('4. User Content'),
          _buildList([
            'You may be able to submit content to the App, such as product descriptions and inventory data ("User Content").',
            'You retain ownership of any User Content you submit, but by submitting User Content, you grant us a non-exclusive, royalty-free, perpetual, irrevocable, and fully sublicensable right to use, reproduce, modify, adapt, publish, translate, distribute, and display such User Content in connection with the App.',
          ]),
          _buildSectionTitle('5. Limitation of Liability'),
          _buildList([
            'To the fullest extent permitted by law, we disclaim all warranties, express or implied, regarding the App and its content.',
            'We will not be liable for any direct, indirect, incidental, consequential, or special damages arising out of or in any way related to your use of the App.',
          ]),
          _buildSectionTitle('6. Termination'),
          _buildList([
            'We reserve the right to terminate or suspend your access to the App at any time, with or without cause and without prior notice.',
            'Upon termination, your right to use the App will cease immediately.',
          ]),
          _buildSectionTitle('7. Changes to These Terms'),
          _buildList([
            'We may revise these Terms at any time by updating this page. By continuing to use the App after we post any changes, you accept the revised Terms.',
          ]),
          _buildSectionTitle('8. Governing Law'),
          _buildList([
            'These Terms are governed by the laws of [Your Jurisdiction], without regard to its conflict of law provisions.',
          ]),
          _buildSectionTitle('9. Contact Us'),
          _buildList([
            'If you have any questions or concerns about these Terms, please contact us at [Your Contact Information].',
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('• $item'),
              ))
          .toList(),
    );
  }
}


class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Our App'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Our App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Our inventory management app is designed specifically for shop owners to efficiently manage their inventory. With intuitive features and user-friendly interface, it streamlines the process of tracking products, managing stock levels, and generating reports.',
            ),
            SizedBox(height: 16),
            Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Easy product cataloging and organization.',
            ),
            Text(
              '- Real-time tracking of inventory levels.',
            ),
            Text(
              '- Automated notifications for low stock items.',
            ),
            Text(
              '- Sales analytics and reporting tools.',
            ),
            SizedBox(height: 16),
            Text(
              'Our mission is to empower shop owners with the tools they need to effectively manage their inventory, streamline operations, and optimize business performance.',
            ),
            SizedBox(height: 16),
            Text(
              'For any inquiries or feedback, please contact us. Thank you for choosing our app!',
            ),
          ],
        ),
      ),
    );
  }
}