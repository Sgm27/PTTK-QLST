1, Quản lý đăng nhập vào hệ thống quản lý.
2, Lớp LoginServlet xử lý yêu cầu POST và gọi UserDAO để tìm người dùng theo tên đăng nhập.
3, Lớp UserDAO truy vấn cơ sở dữ liệu, PasswordUtil so khớp mật khẩu và trả kết quả cho LoginServlet.
4, Lớp LoginServlet tạo session currentUser và điều hướng về MainManagement.jsp.
5, Lớp MainManagement.jsp hiển thị giao diện chính gồm tiêu đề và nút "Xem thống kê khách hàng".
6, Quản lý click nút "Xem thống kê khách hàng".
7, Lớp MainManagement.jsp điều hướng sang SelectStatisticType.jsp.
8, Lớp SelectStatisticType.jsp hiển thị form chọn loại thống kê và khoảng thời gian.
9, Quản lý chọn tùy chọn "Khách hàng theo doanh thu" trong select statisticType.
10, Quản lý nhập ngày bắt đầu vào trường startDate.
11, Quản lý nhập ngày kết thúc vào trường endDate.
12, Quản lý click nút "Xem thống kê".
13, Lớp SelectStatisticType.jsp gửi yêu cầu GET đến đường dẫn /customer-statistic.
14, Lớp AuthenticationFilter kiểm tra session currentUser và cho phép truy cập.
15, Lớp CustomerStatisticServlet gọi hàm doGet() để xử lý yêu cầu.
16, Hàm doGet() đọc tham số statisticType, startDate và endDate từ request.
17, Hàm doGet() lưu statisticType, startDate, endDate vào attribute của request.
18, Hàm doGet() xác thực statisticType thuộc nhóm cho phép.
19, Hàm doGet() parse startDate sang LocalDate thông qua DateTimeFormatter.
20, Hàm doGet() parse endDate sang LocalDate và kiểm tra không sớm hơn startDate.
21, Hàm doGet() chuyển startDate và endDate sang đối tượng java.util.Date.
22, Hàm doGet() tạo đối tượng CustomerStatisticDAO trong khối try-with-resources.
23, Lớp CustomerStatisticDAO gọi hàm getCustomerStatistic() với startDate và endDate.
24, Hàm getCustomerStatistic() chuẩn bị câu lệnh SQL tổng hợp doanh thu khách hàng.
25, Hàm getCustomerStatistic() gán tham số Timestamp bắt đầu bằng toStartOfDay().
26, Hàm getCustomerStatistic() gán tham số Timestamp kết thúc bằng toStartOfNextDay().
27, Hàm getCustomerStatistic() thực thi câu truy vấn và duyệt ResultSet.
28, Hàm getCustomerStatistic() gọi phương thức mapCustomer() để đóng gói thông tin khách hàng.
29, Hàm mapCustomer() khởi tạo đối tượng Customer và set id, tên, email, điện thoại, địa chỉ.
30, Hàm getCustomerStatistic() lấy tổng doanh thu, chuyển sang float và khởi tạo CustomerStatistic.
31, Hàm getCustomerStatistic() thêm từng CustomerStatistic vào danh sách.
32, Hàm getCustomerStatistic() trả danh sách CustomerStatistic về cho CustomerStatisticDAO.
33, Lớp CustomerStatisticDAO trả danh sách kết quả cho CustomerStatisticServlet.
34, Hàm doGet() nhận danh sách và gán attribute listCustomerStatistic lên request.
35, Hàm doGet() forward request đến CustomerStatistic.jsp để hiển thị giao diện.
36, Lớp CustomerStatistic.jsp hiển thị header báo cáo và tổng quan khoảng thời gian.
37, Lớp CustomerStatistic.jsp hiển thị banner tóm tắt startDate, endDate và số khách hàng.
38, Lớp CustomerStatistic.jsp render ô tìm kiếm nhanh và nút "Tìm kiếm".
39, Lớp CustomerStatistic.jsp tạo bảng danh sách khách hàng với mã, tên và tổng doanh thu.
40, Script JavaScript trong CustomerStatistic.jsp lắng nghe input để lọc các dòng bảng.
41, Quản lý nhập từ khóa vào ô tìm kiếm để lọc danh sách khách hàng (nếu cần).
42, Quản lý click nút "Xem chi tiết" tại dòng khách hàng cần xem đơn hàng.
43, Lớp CustomerStatistic.jsp gửi form GET đến đường dẫn /customer-order kèm customerId, startDate, endDate.
44, Lớp AuthenticationFilter kiểm tra session currentUser trước khi cho phép truy cập /customer-order.
45, Lớp OrderServlet gọi hàm doGet() để xử lý yêu cầu danh sách đơn hàng.
46, Hàm doGet() đọc tham số customerId, startDate, endDate từ request.
47, Hàm doGet() gán lại startDate và endDate vào attribute request phục vụ hiển thị.
48, Hàm doGet() kiểm tra tham số rỗng và validate khoảng thời gian.
49, Hàm doGet() parse startDate sang LocalDate bằng DateTimeFormatter.
50, Hàm doGet() parse endDate, kiểm tra không trước startDate và chuyển thành java.util.Date.
51, Hàm doGet() khởi tạo OrderDAO trong khối try-with-resources.
52, Lớp OrderDAO gọi hàm getOrderList() với customerId, startDate, endDate.
53, Hàm getOrderList() chuẩn bị câu SQL lọc đơn hàng theo khách hàng và khoảng thời gian.
54, Hàm getOrderList() gán tham số customerId cùng Timestamp bắt đầu và kết thúc.
55, Hàm getOrderList() thực thi query và gọi mapOrder() cho từng dòng ResultSet.
56, Hàm mapOrder() khởi tạo Order, set id, ngày, tổng tiền và gán Customer qua mapCustomer().
57, Hàm getOrderList() thu thập danh sách Order và trả về cho OrderDAO.
58, Lớp OrderDAO trả danh sách Order về cho OrderServlet.
59, Hàm doGet() gọi OrderDAO.sumTotalPrice() để tính tổng doanh thu của danh sách.
60, Hàm doGet() tạo CustomerDAO và gọi resolveCustomer() để lấy đối tượng Customer hiển thị.
61, Hàm resolveCustomer() ưu tiên lấy Customer từ đơn hàng đầu tiên, nếu không có thì tạo Customer rỗng với id.
62, Hàm doGet() tạo CustomerStatistic mới gồm Customer và tổng doanh thu.
63, Hàm doGet() gán lstOrder và customerStatistic vào attribute request.
64, Hàm doGet() forward request đến CustomerOrder.jsp để render giao diện.
65, Lớp CustomerOrder.jsp hiển thị banner thông tin khách hàng và tổng doanh thu.
66, Lớp CustomerOrder.jsp hiển thị form "Quay lại thống kê" gửi về CustomerStatisticServlet.
67, Lớp CustomerOrder.jsp render bảng lstOrder với mã đơn, ngày đặt và tổng tiền.
68, Quản lý chọn một đơn hàng và click nút "Xem chi tiết".
69, Lớp CustomerOrder.jsp gửi form GET đến đường dẫn /customer-order-detail kèm orderId, customerId, startDate, endDate.
70, Lớp AuthenticationFilter tiếp tục kiểm tra session currentUser cho đường dẫn /customer-order-detail.
71, Lớp CustomerOrderDetailServlet gọi hàm doGet() để xử lý yêu cầu chi tiết đơn hàng.
72, Hàm doGet() đọc orderId, customerId, startDate, endDate và gán lại lên attribute request.
73, Hàm doGet() kiểm tra orderId hợp lệ, nếu thiếu sẽ gán thông báo lỗi.
74, Hàm doGet() tạo OrderDAO và gọi getOrderDetail() với orderId.
75, Hàm getOrderDetail() chuẩn bị câu SQL join đơn hàng, chi tiết và sản phẩm.
76, Hàm getOrderDetail() thực thi truy vấn, khởi tạo Order lần đầu thông qua mapOrder().
77, Hàm getOrderDetail() gọi mapOrderDetail() để đóng gói OrderDetail và Product cho từng dòng.
78, Hàm mapOrderDetail() tạo Product, gán id, tên, giá, tồn kho và set vào OrderDetail.
79, Hàm getOrderDetail() thêm từng OrderDetail vào danh sách listOrderDetail của Order và trả Order về cho servlet.
80, Hàm doGet() nhận Order, gán attribute order và forward đến CustomerOrderDetail.jsp hiển thị kết quả.
81, Lớp CustomerOrderDetail.jsp hiển thị banner mã đơn, ngày đặt, tổng tiền và bảng sản phẩm chi tiết.
82, Quản lý xem danh sách sản phẩm và click nút "Quay lại danh sách đơn hàng".
83, Lớp CustomerOrderDetail.jsp gửi form GET về /customer-order với customerId, startDate, endDate.
84, Hàm doGet() của OrderServlet nhận lại yêu cầu và thực hiện lại các bước từ 46 đến 64 để hiển thị danh sách đơn hàng.
85, Quản lý click nút "Quay lại thống kê" trên CustomerOrder.jsp khi muốn trở lại bảng doanh thu.
86, Lớp CustomerOrder.jsp gửi form GET về /customer-statistic với statisticType, startDate, endDate.
87, Hàm doGet() của CustomerStatisticServlet nhận yêu cầu và thực hiện lại các bước từ 15 đến 35 để hiển thị bảng thống kê khách hàng.
* Quản lý có thể lặp lại các bước từ 42 đến 87 để xem chi tiết các khách hàng hoặc khoảng thời gian khác.
