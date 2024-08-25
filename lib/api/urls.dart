class Urls {
  static String baseUrl = "http://77.37.87.48/api/method";
  static String loginUrl = '$baseUrl/iraq_post.api.auth.driver_login';
  static String barcodeScanUrl = '$baseUrl/iraq_post.api.driver.get_scan_package';
  static String tackListUrl = '$baseUrl/iraq_post.api.driver.get_driver_task';
  static String deliveryUrl = '$baseUrl/iraq_post.api.driver.create_shipment_delivery';
  static String dashboardUrl = '$baseUrl/iraq_post.api.driver.dashboard';
  static String completedTaskUrl = '$baseUrl/iraq_post.api.driver.get_driver_task_completed';
  static String pendingTaskUrl = '$baseUrl/iraq_post.api.driver.get_driver_task_pendding';
  static String startTaskUrl = '$baseUrl/iraq_post.api.driver.send_data_to_optimize_route';
  static String shipmentOutOfDeliveryUrl = '$baseUrl/iraq_post.api.driver.update_shipment_delivery';
  static String shipmentDeliveredUrl = '$baseUrl/iraq_post.api.driver.delivered_update_shipment_delivery';
  static String assignedPickUpListUrl = '$baseUrl/iraq_post.api.driver.assigned_pickup';
  static String arrivingShipmentListUrl = '$baseUrl/iraq_post.api.driver.assigned_shipment';
  static String getContact = '$baseUrl/iraq_post.api.utils.get_contact_us';
}
