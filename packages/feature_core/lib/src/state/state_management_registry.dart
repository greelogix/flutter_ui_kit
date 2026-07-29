import 'state_management_adapter.dart';
import 'adapters/bloc_adapter.dart';
import 'adapters/getx_adapter.dart';
import 'adapters/redux_adapter.dart';
import 'adapters/value_notifier_adapter.dart';
import 'adapters/mobx_adapter.dart';
import 'adapters/no_state_adapter.dart';
import 'adapters/provider_adapter.dart';
import 'adapters/riverpod_adapter.dart';

/// Resolves [StateManagementAdapter] by config id.
class StateManagementRegistry {
  StateManagementRegistry({Map<String, StateManagementAdapter>? adapters})
    : _adapters =
          adapters ??
          {
            'none': NoStateAdapter(),
            'riverpod': RiverpodAdapter(),
            'bloc': BlocAdapter(),
            'provider': ProviderAdapter(),
            'getx': GetXAdapter(),
            'mobx': MobXAdapter(),
            'redux': ReduxAdapter(),
            'value_notifier': ValueNotifierAdapter(),
          };

  final Map<String, StateManagementAdapter> _adapters;

  StateManagementAdapter resolve(String id) {
    return _adapters[id] ?? _adapters['none']!;
  }

  List<String> supportedIds() => _adapters.keys.toList()..sort();
}
