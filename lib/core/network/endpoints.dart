class Endpoints {
  // Auth
  static const login = "/auth/login";
  static const logout = "/auth/logout";
  static const refresh = "/auth/refresh";

  // Customers
  static const customers = "/customers";
  static String customerById(int id) => "/customers/$id";

  // Route plan
  static String routeToday = "/routes/me";
  static String optimizeRoute(int routeId) => "/routes/$routeId/optimize";
  static String updateRouteOrder(int routeId) =>
      "/routes/$routeId/ordered-customer-ids";

  // Visits
  static const checkIn = "/visits/check-in";
  static const checkOut = "/visits/check-out";
  static const visits = "/visits";

  // EPOD (file upload)
  static const uploadFile = "/files/upload";

  // Invoices
  static const invoices = "/invoices";
  static String invoiceById(int id) => "/invoices/$id";
  static String submitInvoice(int id) => "/invoices/$id/submit";

  // Van stock
  static String vanStock(int repId) => "/inventory/van/$repId";

  // GPS tracking
  static const trackingBatch = "/tracking/points/batch";
}
