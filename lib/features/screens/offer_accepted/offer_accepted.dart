import 'dart:async';
import 'package:clean_up/features/screens/offer_screen/offer_screen.dart';
import 'package:clean_up/features/screens/online_screen/online_screen.dart';
import 'package:clean_up/navigation_menu.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';
import 'Widgets/cancel_offer_button.dart';
import 'Widgets/client_contact_card.dart';
import 'Widgets/distance_cost_card.dart';
import 'Widgets/offer_map_configuration.dart';
import 'Widgets/confirm_cleaning_done_text.dart';

class OfferAccepted extends StatefulWidget {
  const OfferAccepted({super.key});

  @override
  State<OfferAccepted> createState() => _OfferAcceptedState();
}

class _OfferAcceptedState extends State<OfferAccepted> {
  String buttonState = "On My Way";
  bool showTimer = false;
  Duration cleaningDuration = Duration.zero;
  Timer? _timer;
  bool showConfirmationButtons = false;
  String? tempMessage;

  // Map-related variables
  final LatLng cleanerLocation =
      const LatLng(37.42796133580664, -122.085749655962);
  final LatLng clientLocation =
      const LatLng(37.43066233580664, -122.086749655962);

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = cleaningDuration.inSeconds + addSeconds;
      cleaningDuration = Duration(seconds: seconds);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Timer start function
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    setState(() {});
  }

  // Timer stop function
  void _stopTimer() {
    _timer?.cancel();
    setState(() {});
  }

  void showTempMessage(String message, {int duration = 3}) {
    setState(() {
      tempMessage = message;
    });
    Timer(Duration(seconds: duration), () {
      setState(() {
        tempMessage = null;
      });
    });
  }

  void _resetTimer() {
    setState(() {
      cleaningDuration = const Duration(seconds: 0);
    });
  }

  void _toggleButton() {
    setState(() {
      if (buttonState == "On My Way") {
        buttonState = "I Am Here";
        showTempMessage("Your offer has been accepted.");
      } else if (buttonState == "I Am Here") {
        buttonState = "Start Cleaning";
        showTempMessage(
            "Press `I Am Here` button to let customer know you have arrived at the location.");
        showTimer = true;
      } else if (buttonState == "Start Cleaning") {
        buttonState = "Done Cleaning";
        showTimer = true;
        showTempMessage("Cleaning started!");
        _startTimer();
      } else if (buttonState == "Done Cleaning") {
        showTimer = false;
        showConfirmationButtons = true;
      }
    });
  }

  void _confirmCleaning(bool isDone) {
    setState(() {
      if (isDone) {
        // to Do
        buttonState = "On My Way";
        showConfirmationButtons = false;
        _resetTimer();
      } else {
        buttonState = "Done Cleaning";
        showConfirmationButtons = false;
        showTimer = true;
      }
    });
  }

  Widget _formatDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(cleaningDuration.inHours.remainder(60));
    final minutes = twoDigits(cleaningDuration.inMinutes.remainder(60));
    final seconds = twoDigits(cleaningDuration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'HOURS'),
        const SizedBox(
          width: 8,
        ),
        buildTimeCard(time: minutes, header: 'MINUTES'),
        const SizedBox(
          width: 8,
        ),
        buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }

  buildTimeCard({required String time, required String header}) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Material(
          elevation: 5,
          color: RColors.white,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: RColors.black,
                  fontSize: 72),
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(header)
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        // OpenStreetMap
        if (buttonState == "On My Way" || buttonState == "I Am Here")
          OfferMapConfiguration(
              cleanerLocation: cleanerLocation, clientLocation: clientLocation),

        if (showTimer) Center(child: _formatDuration()),
        if (showConfirmationButtons) const ConfirmCleaningDoneText(),
        // Foreground
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (buttonState == "On My Way" || buttonState == "I Am Here")
              const CancelOfferButton()
            else
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Column(
              children: [
                const DistanceCostCard(),
                const ClientContactCard(),
                if (showConfirmationButtons)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [yesButton(), noButton()],
                  ),
                if (!showConfirmationButtons) allButtonOfferAccepted()
              ],
            ),
          ],
        )
      ],
    ));
  }

  Container allButtonOfferAccepted() {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
        child: ElevatedButton(
            onPressed: _toggleButton,
            style: ButtonStyle(
                side: const WidgetStatePropertyAll(BorderSide.none),
                backgroundColor:
                    WidgetStatePropertyAll(buttonState == "On My Way"
                        ? RColors.secondary
                        : buttonState == "Start Cleaning"
                            ? RColors.secondary
                            : RColors.primary)),
            child: Text(
              buttonState,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )));
  }

  Container noButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
      child: ElevatedButton(
          onPressed: () {
            _confirmCleaning(false);
          },
          style: const ButtonStyle(
              side: WidgetStatePropertyAll(BorderSide.none),
              backgroundColor: WidgetStatePropertyAll(RColors.secondary)),
          child: const Text(
            "No",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Container yesButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
      child: ElevatedButton(
          onPressed: () {
            _confirmCleaning(true);
            _stopTimer();

            Get.off(() => const NavigationMenu());
          },
          style: const ButtonStyle(
              side: WidgetStatePropertyAll(BorderSide.none),
              backgroundColor: WidgetStatePropertyAll(RColors.primary)),
          child: const Text(
            "Yes",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
