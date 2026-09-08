import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigationCubit extends Cubit<int> {
  MainNavigationCubit() : super(1); 

  void changeTab(int index) => emit(index);
}