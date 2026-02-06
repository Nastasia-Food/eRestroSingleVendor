import 'package:erestroSingleVender/data/model/offlineCartModel.dart';
import 'package:erestroSingleVender/data/repositories/product/productRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/sectionsModel.dart';

//State
@immutable
abstract class GetOfflineCartState {}

class GetOfflineCartInitial extends GetOfflineCartState {}

class GetOfflineCart extends GetOfflineCartState {
  //to GetOfflineCart
  final String? userId, productVariantId;

  GetOfflineCart({this.userId, this.productVariantId});
}

class GetOfflineCartProgress extends GetOfflineCartState {
  GetOfflineCartProgress();
}

// ignore: must_be_immutable
class GetOfflineCartSuccess extends GetOfflineCartState {
  List<OfflineCartModel> offlineCartList;
  GetOfflineCartSuccess(this.offlineCartList);
}

class GetOfflineCartFailure extends GetOfflineCartState {
  final String errorMessage;
  GetOfflineCartFailure(this.errorMessage);
}

class GetOfflineCartCubit extends Cubit<GetOfflineCartState> {
  final ProductRepository _productRepository = ProductRepository();
  GetOfflineCartCubit() : super(GetOfflineCartInitial());

  //to GetOfflineCart user
  getOfflineCart(ProductDetails productDetails, BuildContext context) {
    
    //emitting GetOfflineCartProgress state
    emit(GetOfflineCartProgress());
    //GetOfflineCart user in api
    _productRepository.getOfflineCart(productDetails, context).then((result) {
      //success
      emit(GetOfflineCartSuccess(result));
    }).catchError((e) {
      //failure
      emit(GetOfflineCartFailure(e.toString()));
    });
  }

  fetchOfflineCart() {
    if (state is GetOfflineCartSuccess) {
      return (state as GetOfflineCartSuccess).offlineCartList;
    }
    return [];
  }

  /* void updateQuntity(OfflineCartModel productDetails, String? qty, int? index) {
    if (state is GetOfflineCartSuccess) {
      if (state is GetOfflineCartSuccess) {
        List<OfflineCartModel> currentAddress = (state as GetOfflineCartSuccess).offlineCartList;
        currentAddress[index!] = currentAddress[index].copyWith(qty: qty);
        currentAddress[index] = productDetails;
        emit(GetOfflineCartSuccess(currentAddress));
      }
    }
  } */

}
