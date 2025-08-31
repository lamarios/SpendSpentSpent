import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';
import 'package:spend_spent_spent/globals.dart';

part 'expense_file_management.freezed.dart';

class ExpenseFileManagementCubit extends Cubit<ExpenseFileManagementState> {
  final CarouselController carouselController = CarouselController();

  ExpenseFileManagementCubit(super.initialState);

  close() async {
    carouselController.dispose();
    super.close();
  }

  addFile(SssFile file) {
    final List<SssFile> files = List.from(state.files);
    files.add(file);
    emit(state.copyWith(files: files));
  }

  removeFile(SssFile file) {
    final List<SssFile> files = List.from(state.files);
    files.remove(file);
    emit(state.copyWith(files: files));
  }

  Future<void> uploadImage(XFile image) async {
    emit(state.copyWith(loading: true));

    carouselController.animateToItem(
      state.files.length,
      duration: animationDuration,
      curve: animationCurve,
    );
    try {
      final file = await service.uploadImage(image);
      addFile(file);
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  onFileUpdated(SssFile file) {
    final List<SssFile> files = List.from(state.files);
    final index = files.indexWhere((element) => element.id == file.id);
    files[index] = file;
    emit(state.copyWith(files: files));
  }
}

@freezed
sealed class ExpenseFileManagementState with _$ExpenseFileManagementState {
  const factory ExpenseFileManagementState({
    @Default(false) bool loading,
    @Default([]) List<SssFile> files,
  }) = _ExpenseFileManagementState;

  const ExpenseFileManagementState._();

  List<double> get possiblePrices {
    return files
        .map((e) => e.amounts)
        .expand((element) => element)
        .toSet()
        .toList();
  }

  List<String> get possibleTags {
    return files
        .map((e) => e.aiTags)
        .expand((element) => element)
        .toSet()
        .toList();
  }
}
