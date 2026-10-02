import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 1),
                        // Logo & Header Icon
                        Center(
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.fireRed.withOpacity(0.25),
                                  AppColors.orangeAccent.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: AppColors.fireRed.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '🔥',
                                style: TextStyle(fontSize: 44),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // App Title
                        Text(
                          AppStrings.onboardingTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 12),
                        // Subtitle
                        Text(
                          AppStrings.onboardingSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                        ),
                        const SizedBox(height: 48),

                        // Form Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AppStrings.nameLabel,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: controller.nameController,
                                validator: controller.validateName,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  hintText: AppStrings.nameHint,
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color: AppColors.orangeAccent,
                                  ),
                                ),
                                onFieldSubmitted: (_) => controller.submit(),
                              ),
                              const SizedBox(height: 20),
                              Obx(
                                () => CustomButton(
                                  text: AppStrings.continueButton,
                                  isLoading: controller.isLoading.value,
                                  onPressed: controller.submit,
                                  icon: Icons.arrow_forward_rounded,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Error message if any
                        Obx(() {
                          if (controller.errorMessage.value.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              controller.errorMessage.value,
                              style: const TextStyle(color: AppColors.fireRedLight, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }),

                        const Spacer(flex: 2),

                        // Disclaimer Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 18,
                                color: AppColors.orangeAccent,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  AppStrings.disclaimerShort,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
