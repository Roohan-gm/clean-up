import 'package:clean_up/features/screens/signup/widget/signup_form.dart';
import 'package:clean_up/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/sizes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(RSizes.defaultSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  RTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: RSizes.spaceBtwSection,),
                
                /// Form
                const RSignupForm()
              ],
            ),
          ),
        ));
  }
}

