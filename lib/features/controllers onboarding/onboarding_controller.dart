import 'package:clean_up/app_controller.dart';
import 'package:clean_up/features/screens/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController get instance => Get.find();
  final appController = Get.find<AppController>();

  /// Variable
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  /// update Current Index when page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump to the specific dot selected Page.
  void dotNavigationClick(index){
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  /// Update Current Index & jump to next page.
  void nextPage(){
    if(currentPageIndex.value == 2){
      appController.completeOnboarding();
    }else{
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  /// Update Current Index & jump to the last Page.
  void skipPage(){
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}