enum MainAxisAlignment {
  start,
  center,
  end,
}

enum CrossAxisAlignment {
  start,
  center,
  end,
}

class EdgeInsets {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const EdgeInsets.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;
}
