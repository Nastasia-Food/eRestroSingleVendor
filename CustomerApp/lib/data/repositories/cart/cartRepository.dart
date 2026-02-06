import 'package:erestroSingleVender/cubit/auth/authCubit.dart';
import 'package:erestroSingleVender/cubit/cart/getCartCubit.dart';
import 'package:erestroSingleVender/data/model/cartModel.dart';
import 'package:erestroSingleVender/data/model/offlineCartModel.dart';
import 'package:erestroSingleVender/data/repositories/cart/cartRemoteDataSource.dart';
import 'package:erestroSingleVender/utils/apiMessageAndCodeException.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/SqliteData.dart';
import '../../model/sectionsModel.dart';

class CartRepository {
  static final CartRepository _cartRepository = CartRepository._internal();
  late CartRemoteDataSource _cartRemoteDataSource;

  factory CartRepository() {
    _cartRepository._cartRemoteDataSource = CartRemoteDataSource();
    return _cartRepository;
  }
  CartRepository._internal();

  //to manageCart
  Future<Map<String, dynamic>> manageCartData(
      {/* String? userId,  */String? productVariantId, String? isSavedForLater, String? qty, String? addOnId, String? addOnQty, String? branchId, String? cartId, String? from}) async {
    try {
      final result = await _cartRemoteDataSource.manageCart(
          /* userId: userId, */
          productVariantId: productVariantId,
          isSavedForLater: isSavedForLater,
          qty: qty,
          addOnId: addOnId,
          addOnQty: addOnQty,
          branchId: branchId,
          cartId: cartId,
          from: from);
      return Map.from(result); //
    } on ApiMessageAndCodeException catch (e) {
      ApiMessageAndCodeException apiMessageAndCodeException = e;
      throw ApiMessageAndCodeException(
          errorMessage: apiMessageAndCodeException.errorMessage.toString(), errorStatusCode: apiMessageAndCodeException.errorStatusCode.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  //to placeOrder
  Future<Map<String, dynamic>> placeOrderData(
      {/* String? userId, */
      String? mobile,
      String? productVariantId,
      String? quantity,
      String? total,
      String? deliveryCharge,
      String? taxAmount,
      String? taxPercentage,
      String? finalTotal,
      String? latitude,
      String? longitude,
      String? promoCode,
      String? paymentMethod,
      String? addressId,
      String? isWalletUsed,
      String? walletBalanceUsed,
      String? activeStatus,
      String? orderNote,
      String? deliveryTip}) async {
    final result = await _cartRemoteDataSource.placeOrder(
        /* userId: userId, */
        mobile: mobile,
        productVariantId: productVariantId,
        quantity: quantity,
        total: total,
        deliveryCharge: deliveryCharge,
        taxAmount: taxAmount,
        taxPercentage: taxPercentage,
        finalTotal: finalTotal,
        latitude: latitude,
        longitude: longitude,
        promoCode: promoCode,
        paymentMethod: paymentMethod,
        addressId: addressId,
        isWalletUsed: isWalletUsed,
        walletBalanceUsed: walletBalanceUsed,
        activeStatus: activeStatus,
        orderNote: orderNote,
        deliveryTip: deliveryTip);
    return Map.from(result); //
  }

  //to removeFromCart
  Future<Map<String, dynamic>> removeFromCart({/* String? userId,  *//* String? productVariantId, */ String? cartId, String? branchId}) async {
    final result = await _cartRemoteDataSource.removeCart(/* userId: userId,  *//* productVariantId: productVariantId, */ cartId: cartId, branchId: branchId);
    return Map.from(result); //
  }

  //to clearCart
  Future<Map<String, dynamic>> clearCart({/* String? userId,  */String? branchId}) async {
    final result = await _cartRemoteDataSource.clearCart(/* userId: userId,  */branchId: branchId);
    return Map.from(result); //
  }

  //to getCart
  Future<CartModel> getCartData(/* String? userId,  */String? branchId, String? from) async {
    try {
      CartModel result = await _cartRemoteDataSource.getCart(/* userId: userId,  */branchId: branchId, from: from);
      return result;
    } on ApiMessageAndCodeException catch (e) {
      ApiMessageAndCodeException apiMessageAndCodeException = e;
      throw ApiMessageAndCodeException(
          errorMessage: apiMessageAndCodeException.errorMessage.toString(), errorStatusCode: apiMessageAndCodeException.errorStatusCode.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<String> AllVarianntQty(String id, ProductDetails productDetails, BuildContext context) async {
    /* if (context.read<GetCartCubit>().state is GetCartSuccess) {
      int qtyTotal = 0;
      List<ProductDetails>? productDetailsData = (context.read<GetCartCubit>().state as GetCartSuccess)
          .cartModel
          .data!
          .firstWhere((element) => element.id == id, orElse: () => Data(productDetails: [productDetails]))
          .productDetails;
      for (int j = 0; j < productDetailsData![0].variants!.length; j++) {
        if (productDetails.variants![0].id == productDetailsData[0].variants![j].id) {
          qtyTotal = int.parse(productDetailsData[0].variants![j].cartCount!);
        }
      }
      return qtyTotal.toString();
    } else {
      if (context.read<AuthCubit>().state is AuthInitial || context.read<AuthCubit>().state is Unauthenticated) {
        var db = DatabaseHelper();
        int qtyTotal = 0;
        Map? productVariants;
        List<String>? productVariantIds = [];
        productVariants = (await db.getCart());
        productVariantIds = productVariants['VID'];
        for (int j = 0; j < productDetails.variants!.length; j++) {
          if (productVariantIds!.contains(productDetails.variants![0].id)) {
            String qty = (await db.checkCartItemExists(productDetails.id!, productDetails.variants![j].id!))!;
            productDetails.variants![j].cartCount = qty;
            qtyTotal = int.parse(qty);
          }
        }
        return qtyTotal.toString();
      } else {
        return "0";
      }
    } */
   if (context.read<GetCartCubit>().state is GetCartSuccess) {
      int qtyTotal = 0;
      List<Data> filteredRecords = (context.read<GetCartCubit>().state as GetCartSuccess).cartModel.data!.where((element) => element.id == id).toList();
      for (var record in filteredRecords) {
        List<ProductDetails>? productDetailsData = record.productDetails;
        for (var productDetail in productDetailsData!) {
          for (var variant in productDetail.variants!) {
            qtyTotal += int.parse(variant.cartCount!);
          }
        }
      }
      return qtyTotal.toString();
    } else {
      if (context.read<AuthCubit>().state is AuthInitial || context.read<AuthCubit>().state is Unauthenticated) {
        var db = DatabaseHelper();
        int qtyTotal = 0;
        List<OfflineCartModel> offlineCartDataList = [];
        List<Map> data = (await db.getOfflineCartData());
        offlineCartDataList = (data as List).map((e) => OfflineCartModel.fromJson(e)).toList();
        for (int i = 0; i < offlineCartDataList.length; i++) {
          if (productDetails.id!.contains(offlineCartDataList[i].pId!))
            for (int j = 0; j < productDetails.variants!.length; j++) {
              if (offlineCartDataList[i].vId!.contains(productDetails.variants![j].id!)) {
                String qty = offlineCartDataList[i].qty!;
                productDetails.variants![j].cartCount = qty;
                qtyTotal += int.parse(qty);
              }
            }
        }
        return qtyTotal.toString();
      } else {
        return "0";
      }
    }
  }
}
