abstract class PlatformImplementation {
  PlatformImplementation(); // Remove const
  
  void createView(String viewId, Map<String, dynamic> props);
  void createText(String viewId, Map<String, dynamic> props);
  void createButton(String viewId, Map<String, dynamic> props);
  void createImage(String viewId, Map<String, dynamic> props);
}