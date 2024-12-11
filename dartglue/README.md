# DartGlue

A native UI framework for Dart that provides direct access to platform UI components.

## Usage

Create a new project:
```bash
dartglue create my_app
```

Run your app:
```bash
cd my_app
dartglue run
```

## Example

```dart
void main() {
  final app = NativeView(
    width: 300,
    height: 500,
    backgroundColor: '#FFFFFF',
    children: [
      NativeText(
        'Hello from DartGlue!',
        fontSize: 24,
        textColor: '#000000',
      ),
    ],
  );
}
```
