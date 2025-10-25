import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuCubit extends Cubit<int> {
  final TabsRouter tabsRouter;

  MenuCubit(super.initialState, this.tabsRouter) {
    tabsRouter.addListener(onTabChanged);
  }

  void onTabChanged() {
    emit(tabsRouter.activeIndex);
  }

  @override
  Future<void> close() {
    tabsRouter.removeListener(onTabChanged);
    return super.close();
  }
}
