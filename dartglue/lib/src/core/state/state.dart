abstract class State<T> {
  final List<StateListener> _listeners = [];
  T _value;

  State(this._value);

  T get value => _value;

  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      _notifyListeners();
    }
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void addListener(StateListener listener) {
    _listeners.add(listener);
  }

  void removeListener(StateListener listener) {
    _listeners.remove(listener);
  }
}

typedef StateListener = void Function();
