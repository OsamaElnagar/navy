import 'package:get/get.dart';
import 'package:navy/features/splash/controller/splash_controller.dart';

import '../../controllers/localization_controller.dart';

class PriceConverter {
  static String getCurrency() {
    String currencySymbol =
        Get.find<SplashController>().configModel.content?.currencySymbol ?? "";
    return currencySymbol;
  }

  static String convertPrice(double? price,
      {double? discount, String? discountType, bool isShowLongPrice = false}) {
    if (discount != null && discountType != null) {
      if (discountType == 'amount') {
        price = price! - discount;
      } else if (discountType == 'percent') {
        price = price! - ((discount / 100) * price);
      }
    }
    bool isRightSide = Get.find<SplashController>()
                .configModel
                .content
                ?.currencySymbolPosition ==
            'right' &&
        Get.find<LocalizationController>().isLtr == true;
    return isShowLongPrice == true
        ? '${isRightSide ? '' : getCurrency()}'
            '${(price!).toStringAsFixed(int.parse(Get.find<SplashController>().configModel.content!.currencyDecimalPoint!)).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
            '${isRightSide ? getCurrency() : ''}'
        : longToShortPrice('${isRightSide ? '' : getCurrency()}'
            '${(price!).toStringAsFixed(int.parse(Get.find<SplashController>().configModel.content!.currencyDecimalPoint!)).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
            '${isRightSide ? getCurrency() : ''}');
  }

  static double convertWithDiscount(
      double price, double discount, String discountType) {
    if (discountType == 'amount' || discountType == 'mixed') {
      price = price - discount;
    } else if (discountType == 'percent') {
      price = price - ((discount / 100) * price);
    }
    return price;
  }

  static double calculation(
      double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if (type == 'amount') {
      calculatedAmount = discount * quantity;
    } else if (type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(
      String price, String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : getCurrency()} ${'off1'.tr}';
  }

  static String percentageOrAmount(String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : getCurrency()} ${'off1'.tr}';
  }

//   static Discount _getDiscount(List<ServiceDiscount>? serviceDiscountList, double? discountAmount, String? discountAmountType) {
//     ServiceDiscount? serviceDiscount = (serviceDiscountList != null && serviceDiscountList.isNotEmpty) ?serviceDiscountList.first : null;
//     if(serviceDiscount != null){
//       num? getDiscount = serviceDiscount.discount?.discountAmount;
//       if(getDiscount! > serviceDiscount.discount!.maxDiscountAmount! && serviceDiscount.discount!.discountType == 'percent') {
//         getDiscount = serviceDiscount.discount!.maxDiscountAmount!;
//       }
//       discountAmount = (discountAmount! + getDiscount);
//       discountAmountType = serviceDiscount.discount!.discountAmountType!;
//     }
//     return Discount(discountAmount: discountAmount, discountAmountType: discountAmountType);
//   }

//  static Discount discountCalculation(Service service, {bool addCampaign = false}) {
//     double? discountAmount = 0;
//     String? discountAmountType;

//     if(service.serviceDiscount != null && service.serviceDiscount!.isNotEmpty) {

//       Discount discount =  _getDiscount(service.serviceDiscount, discountAmount, discountAmountType);
//       discountAmount = discount.discountAmount;

//       discountAmountType = discount.discountAmountType;

//     }else if(service.campaignDiscount != null && service.campaignDiscount!.isNotEmpty && addCampaign) {

//       Discount discount =  _getDiscount(service.campaignDiscount, discountAmount, discountAmountType);
//       discountAmount = discount.discountAmount;
//       discountAmountType = discount.discountAmountType;
//     } else{
//       if(service.category?.categoryDiscount != null && service.category!.categoryDiscount!.isNotEmpty) {
//         Discount discount =  _getDiscount(service.category?.categoryDiscount, discountAmount, discountAmountType);
//         discountAmount = discount.discountAmount;
//         discountAmountType = discount.discountAmountType;

//       }else if(service.category?.campaignDiscount != null && service.category!.campaignDiscount!.isNotEmpty && addCampaign){

//         Discount discount =  _getDiscount(service.category?.campaignDiscount, discountAmount, discountAmountType);
//         discountAmount = discount.discountAmount;
//         discountAmountType = discount.discountAmountType;

//       }
//     }

//     return Discount(discountAmount: discountAmount, discountAmountType: discountAmountType);
//   }

//   static double getDiscountToAmount(Discount discount, double amount) {

//     double amount0 = 0;
//     if(discount.discountAmountType == 'percent') {
//      amount0 = (amount * discount.discountAmount!.toDouble()) / 100.0 ;

//      if(amount0 > discount.maxDiscountAmount!.toDouble()) {
//        amount0 = discount.maxDiscountAmount!.toDouble();
//      }
//     }else{
//       amount0 = discount.discountAmount!.toDouble();
//     }
//     return amount0;

//   }

  static String longToShortPrice(String price) {
    return price.length > 15
        ? "${price.substring(0, 12)}....${price.substring(price.length - 1, price.length)}"
        : price;
  }
}
