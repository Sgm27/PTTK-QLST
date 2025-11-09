1.Manager click "Xem thong ke khach hang" tai MainManagement.jsp.
2.MainManagement.jsp chuyen huong den SelectStatisticType.jsp.
3.SelectStatisticType.jsp hien thi form chon loai thong ke va khoang thoi gian.
4.Manager chon tuy chon "Khach hang theo doanh thu".
5.Manager nhap ngay bat dau vao o startDate.
6.Manager nhap ngay ket thuc vao o endDate.
7.Manager click nut "Xem thong ke".
8.SelectStatisticType.jsp gui yeu cau den CustomerStatisticServlet.
9.CustomerStatisticServlet thuc hien phuong thuc doGet().
10.CustomerStatisticServlet kiem tra tham so statisticType.
11.CustomerStatisticServlet kiem tra startDate va endDate.
12.CustomerStatisticServlet parse startDate sang LocalDate.
13.CustomerStatisticServlet parse endDate va kiem tra thu tu ngay.
14.CustomerStatisticServlet chuyen doi LocalDate sang Date de truy van.
15.CustomerStatisticServlet goi CustomerStatisticDAO.
16.CustomerStatisticDAO thuc hien phuong thuc getCustomerStatistic().
17.getCustomerStatistic() chuan bi cau SQL tong hop doanh thu khach hang.
18.getCustomerStatistic() gan tham so ngay bat dau va ket thuc.
19.getCustomerStatistic() thuc thi cau lenh va lap qua ResultSet.
20.getCustomerStatistic() tao CustomerStatistic tu thong tin khach hang va tong doanh thu.
21.CustomerStatisticDAO tra danh sach CustomerStatistic cho servlet.
22.CustomerStatisticServlet gan listCustomerStatistic vao request.
23.CustomerStatisticServlet forward den CustomerStatistic.jsp.
24.CustomerStatistic.jsp hien banner tom tat khoang thoi gian va so khach hang.
25.CustomerStatistic.jsp hien bang khach hang va tong doanh thu.
26.Manager xem danh sach khach hang tren bang.
27.Manager click nut "Xem chi tiet" o dong khach hang duoc chon.
28.CustomerStatistic.jsp gui yeu cau den OrderServlet.
29.OrderServlet thuc hien phuong thuc doGet().
30.OrderServlet kiem tra customerId va khoang ngay.
31.OrderServlet parse startDate va endDate.
32.OrderServlet goi OrderDAO.
33.OrderDAO thuc hien phuong thuc getOrder().
34.getOrder() truy van don hang va chi tiet san pham cua khach hang.
35.getOrder() gom ket qua thanh danh sach Order day du.
36.OrderDAO tra danh sach Order cho OrderServlet.
37.OrderServlet tinh tong doanh thu tu danh sach Order.
38.OrderServlet tao CustomerStatistic cho trang chi tiet.
39.OrderServlet gan lstOrder va customerStatistic vao request.
40.OrderServlet forward den CustomerOrder.jsp.
41.CustomerOrder.jsp hien thong tin khach hang va tong doanh thu.
42.CustomerOrder.jsp hien bang don hang va chi tiet san pham.
43.Manager xem tung don hang tren bang.
44.Manager click nut "Quay lai thong ke".
45.CustomerOrder.jsp gui yeu cau tro lai CustomerStatisticServlet.
46.CustomerStatisticServlet nhan tham so va hien lai danh sach thong ke ban dau.
