You are implementing the module "View customer statistics by revenue" for an electronic supermarket management system (QLST).  
The stack is classic Java EE: JSP pages (view), Servlets (controller), and DAO classes using JDBC (persistence).  
Follow the class structure and relationships below as closely as possible.

====================
1. PRESENTATION (JSP) LAYER
====================

1.1 MainManagement.jsp
- Purpose: main menu for the manager. Has a link/button to open the statistics screen.
- Attributes / UI elements:
  - viewStatistic : link  
    - Clicking this link navigates to SelectStatisticType.jsp.

1.2 SelectStatisticType.jsp
- Purpose: first step of the statistics flow. The manager chooses which type of statistic to see and the date range.
- Attributes / UI elements (conceptual fields):
  - statisticType : Select  
    - A dropdown to choose among different statistic types (for this module we care about "customer revenue").
  - startDate : Date  
    - Input field for the start date of the reporting period.
  - endDate : Date  
    - Input field for the end date of the reporting period.
  - btnViewStatistic : submit  
    - Submit button. When clicked, the form is sent to CustomerStatisticServlet.
- Behavior:
  - Sends request parameters (statisticType, startDate, endDate) to CustomerStatisticServlet via HTTP (GET or POST, but Servlet method is modeled as doGet).

1.3 CustomerStatistic.jsp
- Purpose: show the list of customers and their total revenue in the chosen period; allow the manager to drill down into details of a specific customer.
- Attributes / UI elements:
  - startDate : Date  
    - The selected start date, displayed again for reference.
  - endDate : Date  
    - The selected end date, displayed again for reference.
  - tblCustomerStatistic : table  
    - HTML table bound to listCustomerStatistic. Each row shows a customer and their totalPrice (revenue) in the period.
  - listCustomerStatistic : CustomerStatistic[] (List<CustomerStatistic>)  
    - The list of statistics objects provided by CustomerStatisticServlet.
  - customer : Select  
    - Dropdown or selection component to choose a specific customer (may be derived from the table selection).
  - btnViewDetail : Submit  
    - Button to view detailed orders of the selected customer.
- Behavior:
  - This page is reached after CustomerStatisticServlet sets the attributes and forwards to it.
  - When btnViewDetail is clicked, the selected customer id and date range are sent to OrderServlet.

1.4 CustomerOrder.jsp
- Purpose: show all orders of a specific customer in the selected date range.
- Attributes / UI elements:
  - customerStatistic : CustomerStatistic  
    - The aggregated statistic object for the selected customer (total revenue, and reference to Customer).
  - startDate : Date
  - endDate : Date
  - tblOrder : table  
    - Table that displays orders for this customer in the period.
  - lstOrder : Order[] (List<Order>)  
    - List of Order objects provided by OrderServlet.
  - btnClose : submit  
    - Button to close the detail view or return to the previous screen.
- Behavior:
  - This page is reached after OrderServlet sets customerStatistic, lstOrder, startDate, endDate and forwards to it.

====================
2. CONTROLLER (SERVLET) LAYER
====================

2.1 CustomerStatisticServlet
- Purpose: controller that receives the request from SelectStatisticType.jsp, calls the DAO to compute statistics, and forwards the result to CustomerStatistic.jsp.
- Methods:
  - doGet(HttpServletRequest request, HttpServletResponse response) : void
    - Reads request parameters: statisticType, startDate, endDate.
    - Converts startDate and endDate to java.util.Date (or java.time types, but keep the UML’s “Date” idea).
    - Calls CustomerStatisticDAO.getCustomerStatistic(startDate, endDate).
    - Stores the returned List<CustomerStatistic> as a request attribute (e.g., "listCustomerStatistic").
    - Forwards the request to CustomerStatistic.jsp.

2.2 OrderServlet
- Purpose: controller that receives the request from CustomerStatistic.jsp when the manager wants to see the detailed orders of a customer.
- Methods:
  - doGet(HttpServletRequest request, HttpServletResponse response) : void
    - Reads parameters: customerId, startDate, endDate (also can receive the selected CustomerStatistic if needed).
    - Converts startDate and endDate.
    - Calls OrderDAO.getOrder(customerId, startDate, endDate).
    - Sets attributes on the request:
      - "customerStatistic" : CustomerStatistic (for the selected customer).
      - "lstOrder" : List<Order>.
      - "startDate", "endDate".
    - Forwards to CustomerOrder.jsp.

====================
3. DAO LAYER
====================

3.1 DAO (base class)
- Purpose: generic base class for all DAO classes, holding the database connection.
- Attributes:
  - protected Connection con;
- Constructors:
  - DAO()
    - Opens or receives a JDBC Connection (according to the project’s standard).
- Notes:
  - CustomerStatisticDAO and OrderDAO inherit from DAO.

3.2 CustomerStatisticDAO (extends DAO)
- Purpose: provide data access methods related to customer revenue statistics.
- Constructors:
  - CustomerStatisticDAO()
    - Calls super() and initializes DAO state if needed.
- Methods:
  - List<CustomerStatistic> getCustomerStatistic(Date startDate, Date endDate)
    - SQL responsibility: group orders by customer and sum the total order value in the given date range.
    - For each customer, build a CustomerStatistic object:
      - setTotalPrice(sumRevenue)
      - setCustomer(the corresponding Customer entity).
    - Returns a list of CustomerStatistic.

3.3 OrderDAO (extends DAO)
- Purpose: provide access to orders and their details for a given customer in a date range.
- Constructors:
  - OrderDAO()
- Methods:
  - List<Order> getOrder(int customerID, Date startDate, Date endDate)
    - SQL responsibility: fetch all orders of the given customer between startDate and endDate, including order details and products.
    - For each row group:
      - Build an Order object.
      - Build corresponding OrderDetail objects (and link Product instances).
    - Returns a list of fully populated Order objects (with listOrderDetail).

====================
4. DOMAIN MODEL LAYER
====================

4.1 Member
- Purpose: base class for all people that are registered in the system (customers and staff).
- Attributes:
  - id : int
  - name : String
  - password : String
  - email : String
  - phone : String
  - address : String
  - note : String

4.2 Staff (extends Member)
- Attributes:
  - position : String
- Notes:
  - Represents any staff member (warehouse staff, sales staff, etc.).

4.3 Manager (extends Staff)
- Attributes:
  - (none additional in this diagram)
- Notes:
  - Specific type of Staff that has access to viewing statistics.

4.4 Customer (extends Member)
- Attributes:
  - id : int    // shown explicitly; other fields inherited from Member
- Notes:
  - Represents a customer that can place orders and whose revenue is being analyzed.

4.5 CustomerStatistic
- Purpose: represent the aggregated revenue of a single customer in a given period.
- Attributes:
  - totalPrice : float
- Associations:
  - Has an association to Customer (1 CustomerStatistic ↔ 1 Customer).
    - Model this as a field:
      - customer : Customer
- Notes:
  - This class is used only for reporting; it is not a direct table in DB (can be mapped from query results).

4.6 Order
- Purpose: represent a purchase order (online or at the counter).
- Attributes:
  - id : integer
  - date : Date
  - totalPrice : float
  - customer : Customer
  - deliveryInvoice : DeliveryInvoice   // type already exists in another part of the system
  - listOrderDetail : List<OrderDetail>
- Associations:
  - Many Orders belong to one Customer.
  - One Order has one or more OrderDetail lines.

4.7 OrderDetail
- Purpose: represent one line item in an order.
- Attributes:
  - id : integer
  - price : float
  - quantity : integer
  - order : Order
  - listProduct : Product[]  (UML shows an array; in implementation it can be a single Product field or a List<Product>. Prefer a single Product for a normal order line.)
- Associations:
  - Each OrderDetail references exactly one Product.
  - Many OrderDetails belong to one Order.

4.8 Product
- Purpose: represent an item sold in the supermarket.
- Attributes:
  - id : int
  - name : String
  - price : float   // UML shows String, but you should implement it as numeric
  - quantity : Integer

====================
5. OVERALL FLOW OF THE "VIEW CUSTOMER STATISTICS BY REVENUE" USE CASE
====================

1. The Manager logs in, goes to MainManagement.jsp and clicks the "ViewStatistic" link.
2. MainManagement.jsp navigates to SelectStatisticType.jsp.
3. On SelectStatisticType.jsp, the manager:
   - Chooses statisticType = "customer revenue",
   - Inputs startDate and endDate,
   - Clicks btnViewStatistic.
4. The form is submitted to CustomerStatisticServlet.doGet().
5. CustomerStatisticServlet:
   - Parses startDate and endDate from the request.
   - Calls new CustomerStatisticDAO().getCustomerStatistic(startDate, endDate).
   - Receives a List<CustomerStatistic>, each having a Customer and a totalPrice.
   - Attaches listCustomerStatistic, startDate, endDate as request attributes.
   - Forwards to CustomerStatistic.jsp.
6. CustomerStatistic.jsp:
   - Renders tblCustomerStatistic based on listCustomerStatistic.
   - Allows the manager to select a specific customer (customer select or row).
   - When btnViewDetail is clicked, it submits customerID (and startDate, endDate) to OrderServlet.
7. OrderServlet.doGet():
   - Reads customerID, startDate, endDate.
   - Calls new OrderDAO().getOrder(customerID, startDate, endDate).
   - Receives a List<Order> with details for that customer.
   - Optionally reconstructs the CustomerStatistic object for that customer.
   - Sets request attributes: customerStatistic, lstOrder, startDate, endDate.
   - Forwards to CustomerOrder.jsp.
8. CustomerOrder.jsp:
   - Displays customer info and aggregated statistic (customerStatistic).
   - Renders tblOrder to show each Order, its date, totalPrice, and list of OrderDetail with Products.
   - Provides btnClose to return to the previous page or menu.

Implement the classes and their fields/methods according to this description.  
You may adjust internal code style and minor types, but the class names, main attributes, methods, and relationships should remain consistent with this design so that the module behaves exactly as described.
