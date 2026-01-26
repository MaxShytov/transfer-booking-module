import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/booking_flow_provider.dart';
import '../../widgets/atoms/booking_progress_indicator.dart';
import '../../widgets/atoms/gradient_button.dart';

/// Screen for passenger details (Step 4 of booking wizard) - Cupertino style.
class PassengerDetailsScreen extends ConsumerStatefulWidget {
  const PassengerDetailsScreen({super.key});

  @override
  ConsumerState<PassengerDetailsScreen> createState() =>
      _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState
    extends ConsumerState<PassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _phoneController;
  TextEditingController? _emailController;
  TextEditingController? _flightNumberController;
  TextEditingController? _returnFlightNumberController;
  TextEditingController? _specialRequestsController;
  bool _initialized = false;

  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _emailError;

  void _initControllersIfNeeded() {
    if (_initialized) return;
    _initialized = true;

    final bookingState = ref.read(bookingFlowProvider);
    final authState = ref.read(authStateProvider);

    final passenger = bookingState.passengerDetails;
    final user = authState.user;

    _firstNameController = TextEditingController(
      text: passenger?.firstName ?? user?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: passenger?.lastName ?? user?.lastName ?? '',
    );
    _phoneController = TextEditingController(
      text: passenger?.phone ?? user?.phone ?? '',
    );
    _emailController = TextEditingController(
      text: passenger?.email ?? user?.email ?? '',
    );
    _flightNumberController = TextEditingController(
      text: passenger?.flightNumber ?? '',
    );
    _returnFlightNumberController = TextEditingController(
      text: passenger?.returnFlightNumber ?? '',
    );
    _specialRequestsController = TextEditingController(
      text: passenger?.specialRequests ?? '',
    );
  }

  @override
  void dispose() {
    _firstNameController?.dispose();
    _lastNameController?.dispose();
    _phoneController?.dispose();
    _emailController?.dispose();
    _flightNumberController?.dispose();
    _returnFlightNumberController?.dispose();
    _specialRequestsController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initControllersIfNeeded();
    final bookingState = ref.watch(bookingFlowProvider);
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.passengerDetails),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            ref.read(bookingFlowProvider.notifier).previousStep();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/booking/extras');
            }
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: BookingProgressIndicator(
                currentStep: bookingState.currentStep.index,
                totalSteps: 5,
                stepLabels: [
                  l10n.stepRoute,
                  l10n.stepVehicle,
                  l10n.stepExtras,
                  l10n.stepDetails,
                  l10n.stepReview,
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.contactInformation,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.label,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _CupertinoFormField(
                        label: l10n.firstName,
                        controller: _firstNameController!,
                        icon: Icons.person_outline,
                        textCapitalization: TextCapitalization.words,
                        errorText: _firstNameError,
                        onChanged: (_) {
                          if (_firstNameError != null) {
                            setState(() => _firstNameError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _CupertinoFormField(
                        label: l10n.lastName,
                        controller: _lastNameController!,
                        icon: Icons.person_outline,
                        textCapitalization: TextCapitalization.words,
                        errorText: _lastNameError,
                        onChanged: (_) {
                          if (_lastNameError != null) {
                            setState(() => _lastNameError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _CupertinoFormField(
                        label: l10n.phoneNumber,
                        controller: _phoneController!,
                        icon: Icons.phone_outlined,
                        placeholder: l10n.phoneNumberHint,
                        keyboardType: TextInputType.phone,
                        errorText: _phoneError,
                        onChanged: (_) {
                          if (_phoneError != null) {
                            setState(() => _phoneError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _CupertinoFormField(
                        label: l10n.email,
                        controller: _emailController!,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        errorText: _emailError,
                        onChanged: (_) {
                          if (_emailError != null) {
                            setState(() => _emailError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 32),
                      Text(
                        l10n.tripDetailsOptional,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.label,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _CupertinoFormField(
                        label: bookingState.isRoundTrip
                            ? l10n.outboundFlightNumber
                            : l10n.flightNumber,
                        controller: _flightNumberController!,
                        icon: Icons.flight,
                        placeholder: l10n.flightNumberHint,
                        textCapitalization: TextCapitalization.characters,
                        helperText: l10n.flightMonitoringInfo,
                      ),
                      if (bookingState.isRoundTrip) ...[
                        const SizedBox(height: 16),
                        _CupertinoFormField(
                          label: l10n.returnFlightNumber,
                          controller: _returnFlightNumberController!,
                          icon: Icons.flight,
                          placeholder: l10n.flightNumberHint,
                          textCapitalization: TextCapitalization.characters,
                          helperText: l10n.flightMonitoringInfo,
                        ),
                      ],
                      const SizedBox(height: 16),
                      _CupertinoFormField(
                        label: l10n.specialRequests,
                        controller: _specialRequestsController!,
                        icon: Icons.description_outlined,
                        placeholder: l10n.specialRequestsHint,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                ),
              ),
              child: GradientButton(
                text: l10n.continueToReview,
                onPressed: () => _submitForm(l10n),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm(AppLocalizations l10n) {
    bool isValid = true;

    if (_firstNameController!.text.trim().isEmpty) {
      setState(() => _firstNameError = l10n.validationFirstNameRequired);
      isValid = false;
    }
    if (_lastNameController!.text.trim().isEmpty) {
      setState(() => _lastNameError = l10n.validationLastNameRequired);
      isValid = false;
    }
    if (_phoneController!.text.trim().isEmpty) {
      setState(() => _phoneError = l10n.validationPhoneRequired);
      isValid = false;
    } else if (_phoneController!.text.trim().length < 8) {
      setState(() => _phoneError = l10n.validationPhoneInvalid);
      isValid = false;
    }
    if (_emailController!.text.trim().isEmpty) {
      setState(() => _emailError = l10n.validationEmailRequired);
      isValid = false;
    } else if (!_emailController!.text.contains('@') ||
        !_emailController!.text.contains('.')) {
      setState(() => _emailError = l10n.validationEmailInvalid);
      isValid = false;
    }

    if (isValid) {
      final details = PassengerDetails(
        firstName: _firstNameController!.text.trim(),
        lastName: _lastNameController!.text.trim(),
        phone: _phoneController!.text.trim(),
        email: _emailController!.text.trim(),
        flightNumber: _flightNumberController!.text.trim().isNotEmpty
            ? _flightNumberController!.text.trim()
            : null,
        returnFlightNumber: _returnFlightNumberController!.text.trim().isNotEmpty
            ? _returnFlightNumberController!.text.trim()
            : null,
        specialRequests: _specialRequestsController!.text.trim().isNotEmpty
            ? _specialRequestsController!.text.trim()
            : null,
      );

      ref.read(bookingFlowProvider.notifier).setPassengerDetails(details);
      ref.read(bookingFlowProvider.notifier).nextStep();
      ref.read(bookingFlowProvider.notifier).calculatePrice();

      context.push('/booking/review');
    }
  }
}

class _CupertinoFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final void Function(String)? onChanged;

  const _CupertinoFormField({
    required this.label,
    required this.controller,
    required this.icon,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
            borderRadius: BorderRadius.circular(10),
            border: errorText != null
                ? Border.all(color: CupertinoColors.systemRed, width: 1)
                : null,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(
                  icon,
                  size: 20,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
              Expanded(
                child: CupertinoTextField(
                  controller: controller,
                  placeholder: placeholder,
                  keyboardType: keyboardType,
                  textCapitalization: textCapitalization,
                  maxLines: maxLines,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: const BoxDecoration(),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                fontSize: 12,
                color: CupertinoColors.systemRed,
              ),
            ),
          ),
        if (helperText != null && errorText == null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(
              helperText!,
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ),
      ],
    );
  }
}
