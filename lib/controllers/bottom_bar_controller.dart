import 'package:get/get.dart';

class BottomBarController extends GetxController{
  var selectedIndex = 0.obs();
  updateIndex(int index) {
    selectedIndex = index;
  }
}