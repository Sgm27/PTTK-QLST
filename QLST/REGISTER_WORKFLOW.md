# WORKFLOW - ĐĂNG KÝ THÀNH VIÊN

## Quy trình thực hiện chức năng "Đăng ký thành viên"

1. Khách hàng truy cập trang chủ hệ thống quản lý siêu thị QLST.

2. Giao diện chính hiển thị thanh điều hướng với các liên kết "Đăng nhập", "Đăng ký" và "Thống kê".

3. Khách hàng nhấp vào liên kết "Đăng ký" trên thanh điều hướng.

4. Trình duyệt gửi yêu cầu GET /register tới máy chủ ứng dụng.

5. Tệp web.xml ánh xạ URL /register tới lớp com.qlst.servlet.RegisterServlet.

6. Máy chủ ứng dụng khởi tạo (hoặc tái sử dụng) đối tượng RegisterServlet và gọi phương thức doGet().

7. Phương thức doGet() gọi hàm forwardToForm(req, resp) để điều hướng tới giao diện điền thông tin thành viên.

8. Hàm forwardToForm() sử dụng RequestDispatcher.forward tới đường dẫn /jsp/FillInformation.jsp.

9. Máy chủ ứng dụng tải trang FillInformation.jsp và bắt đầu biên dịch JSP thành servlet tương ứng nếu chưa có.

10. FillInformation.jsp khai báo taglib JSTL core với prefix "c" để sử dụng biểu thức JSTL.

11. FillInformation.jsp tạo biến ngữ cảnh ctx bằng giá trị pageContext.request.contextPath.

12. FillInformation.jsp lấy sessionScope.currentUser để xác định khách hàng đã đăng nhập hay chưa và lưu vào biến currentUser.

13. FillInformation.jsp nếu currentUser không rỗng thì thiết lập displayName bằng fullName hoặc username của người dùng.

14. FillInformation.jsp dựng phần header với logo QLST và điều hướng tới các trang Login, Register, MainManagement.

15. FillInformation.jsp so sánh biến currentPage với "fillInformation" để đánh dấu liên kết Đăng ký đang hoạt động.

16. FillInformation.jsp hiển thị tiêu đề trang "Điền thông tin thành viên" và mô tả "Hoàn tất biểu mẫu bên dưới để gửi yêu cầu tạo tài khoản khách hàng.".

17. FillInformation.jsp vẽ section card chứa form đăng ký cùng các hướng dẫn nhập liệu.

18. FillInformation.jsp kiểm tra attribute errors; nếu tồn tại, hiển thị khối cảnh báo kèm danh sách từng lỗi.

19. FillInformation.jsp hiển thị form có action="${ctx}/register", method="post" và thuộc tính autocomplete="off".

20. FillInformation.jsp tạo trường input name="name" với thuộc tính required và bind giá trị formData.name nếu có trong request attribute.

21. FillInformation.jsp tạo trường input name="password" loại password, required, placeholder "Tối thiểu 8 ký tự".

22. FillInformation.jsp tạo trường input name="email" với type="email", required, bind giá trị formData.email nếu có.

23. FillInformation.jsp tạo trường input name="address" cho phép bỏ trống và bind giá trị formData.address nếu đã nhập trước.

24. FillInformation.jsp tạo trường input name="phone" cho số điện thoại và bind giá trị formData.phone nếu có.

25. FillInformation.jsp hiển thị hai nút: "Đã có tài khoản" (liên kết tới /login) và nút submit "Gửi yêu cầu".

26. Khách hàng nhập họ tên, mật khẩu, email, địa chỉ, số điện thoại rồi nhấn nút "Gửi yêu cầu".

27. Trình duyệt gửi yêu cầu POST /register kèm dữ liệu biểu mẫu tới RegisterServlet.

28. Máy chủ ứng dụng gọi phương thức doPost(HttpServletRequest req, HttpServletResponse resp) của RegisterServlet.

29. doPost() đặt encoding UTF-8 cho request để xử lý tiếng Việt chính xác.

30. doPost() gọi StringUtils.defaultString(req.getParameter("password")) để đọc mật khẩu thô, thay thế null bằng chuỗi rỗng.

31. doPost() gọi phương thức extractFormData(req) để gom dữ liệu biểu mẫu thành đối tượng Member.

32. extractFormData() khởi tạo Member mới.

33. extractFormData() sử dụng StringUtils.trimToEmpty để gán họ tên vào member.setName().

34. extractFormData() sử dụng StringUtils.trimToEmpty để gán email vào member.setEmail().

35. extractFormData() sử dụng StringUtils.trimToNull để gán địa chỉ vào member.setAddress().

36. extractFormData() sử dụng StringUtils.trimToNull để gán số điện thoại vào member.setPhone().

37. extractFormData() trả về đối tượng Member đã chuẩn hóa cho doPost().

38. doPost() tạo danh sách errors kiểu ArrayList để ghi nhận thông báo lỗi hợp lệ.

39. doPost() đặt request attribute "formData" bằng đối tượng Member để JSP bind lại giá trị nếu cần.

40. doPost() gọi validateRequiredFields(formData, rawPassword, errors) để kiểm tra các trường bắt buộc.

41. validateRequiredFields() kiểm tra nếu formData.getName() rỗng (isBlank) thì thêm lỗi "Ho va ten khong duoc de trong." vào errors.

42. validateRequiredFields() kiểm tra mật khẩu rỗng; nếu rawPassword isBlank, thêm lỗi "Mat khau khong duoc de trong.".

43. validateRequiredFields() kiểm tra độ dài mật khẩu; nếu rawPassword dưới 8 ký tự, thêm lỗi "Mat khau phai co it nhat 8 ky tu.".

44. validateRequiredFields() kiểm tra email rỗng; nếu formData.getEmail() isBlank, thêm lỗi "Email khong duoc de trong.".

45. Sau khi validateRequiredFields(), doPost() kiểm tra nếu danh sách errors hiện đang rỗng.

46. Khi errors rỗng, doPost() tiếp tục gọi validateUniqueness(formData, errors) để kiểm tra trùng lặp tài khoản.

47. validateUniqueness() gói trong khối try để bắt SQLException từ UserDAO.

48. validateUniqueness() gọi userDAO.findByUsername(formData.getName()).

49. findByUsername() tạo kết nối JDBC thông qua DBConnection.getConnection().

50. findByUsername() chuẩn bị câu lệnh SELECT id, username, password_hash, role, full_name, email, phone_number, created_at FROM tblUsers WHERE username = ?.

51. findByUsername() bind tham số username và thực thi executeQuery().

52. Nếu ResultSet có bản ghi, findByUsername() gọi mapRow(resultSet) để đóng gói dữ liệu vào đối tượng User.

53. mapRow() gán id, username, password_hash, role, full_name, email, phone_number và chuyển đổi created_at sang LocalDateTime.

54. findByUsername() trả về Optional<User> chứa dữ liệu nếu tìm thấy.

55. validateUniqueness() kiểm tra Optional.isPresent(); nếu true thì thêm lỗi "Ten dang nhap da ton tai. Vui long chon ten khac." vào errors.

56. validateUniqueness() tiếp tục gọi userDAO.findByEmail(formData.getEmail()).

57. findByEmail() lặp lại quy trình chuẩn bị PreparedStatement SELECT với điều kiện email = ?.

58. Nếu tìm thấy email, validateUniqueness() thêm lỗi "Email da duoc su dung." vào errors.

59. Nếu UserDAO ném SQLException, validateUniqueness() ném ServletException "Khong the kiem tra tinh duy nhat cua ten dang nhap/email." để báo lỗi tầng servlet.

60. doPost() sau validateUniqueness() kiểm tra lại danh sách errors.

61. Nếu errors không rỗng, doPost() đặt attribute "errors" vào request.

62. doPost() gọi forwardToForm(req, resp) để trả người dùng về FillInformation.jsp.

63. FillInformation.jsp nhận errors và formData, hiển thị danh sách thông báo lỗi ngay trên form.

64. Khách hàng điều chỉnh thông tin và gửi lại biểu mẫu; luồng xử lý quay về bước 26 và lặp tới khi hợp lệ.

65. Khi errors rỗng, doPost() gọi buildMemberToPersist(formData, rawPassword) để chuẩn bị dữ liệu lưu trữ.

66. buildMemberToPersist() khởi tạo Member mới có tên memberToPersist.

67. buildMemberToPersist() sao chép name từ formData sang memberToPersist.setName().

68. buildMemberToPersist() gọi PasswordUtil.hashPassword(rawPassword) để băm mật khẩu SHA-256 và gán vào memberToPersist.setPassword().

69. PasswordUtil.hashPassword() khởi tạo MessageDigest với thuật toán "SHA-256".

70. PasswordUtil.hashPassword() chuyển mật khẩu sang bytes UTF-8, tính hash và chuyển mỗi byte thành chuỗi hex 2 ký tự.

71. PasswordUtil.hashPassword() trả về chuỗi hash để lưu trữ.

72. buildMemberToPersist() sao chép email, address, phone từ formData sang memberToPersist.

73. buildMemberToPersist() trả về memberToPersist cho doPost().

74. doPost() khai báo biến boolean savedSuccessfully để ghi nhận kết quả lưu thành viên.

75. doPost() tạo khối try-with-resources với new MemberDAO() để đảm bảo đóng kết nối JDBC sau khi xử lý.

76. Constructor MemberDAO kế thừa DAO và gọi super(), bên trong mở kết nối DB và gán vào thuộc tính con.

77. Trong khối try, doPost() gọi memberDAO.saveInformation(memberToPersist).

78. saveInformation() lấy trạng thái auto-commit hiện tại từ Connection bằng con.getAutoCommit().

79. saveInformation() đặt con.setAutoCommit(false) để bắt đầu transaction.

80. saveInformation() gọi insertUser(member) để thêm bản ghi người dùng mới.

81. insertUser() lấy thời gian LocalDateTime.now() lưu vào biến createdAt.

82. insertUser() chuẩn bị PreparedStatement INSERT INTO tblUsers (username, password_hash, role, full_name, email, phone_number, created_at) VALUES (?, ?, ?, ?, ?, ?, ?) với RETURN_GENERATED_KEYS.

83. insertUser() gán username bằng member.getName().

84. insertUser() gán password_hash bằng member.getPassword() (đã băm).

85. insertUser() gán role = "CUSTOMER" để chỉ định vai trò khách hàng.

86. insertUser() gán full_name = member.getName(), email = member.getEmail(), phone_number = member.getPhone().

87. insertUser() gán created_at = Timestamp.valueOf(createdAt).

88. insertUser() thực thi executeUpdate() để ghi dữ liệu vào bảng tblUsers.

89. insertUser() đọc ResultSet generatedKeys, lấy khóa chính id bằng generatedKeys.getString(1).

90. Nếu không lấy được khóa chính, insertUser() ném SQLException "Không thể lấy mã người dùng sau khi tạo thành viên.".

91. saveInformation() nhận userId trả về từ insertUser().

92. saveInformation() gọi toCustomer(member, userId) để ánh xạ sang đối tượng Customer.

93. toCustomer() khởi tạo Customer mới, gán name, email, phone, address từ Member.

94. toCustomer() gán userAccountId = userId và joinedAt = LocalDateTime.now().

95. saveInformation() gọi customerDAO.save(con, customer) để lưu hồ sơ khách hàng.

96. customerDAO.save() kiểm tra nếu customer.getUserAccountId() null thì ném IllegalArgumentException, đảm bảo dữ liệu hợp lệ.

97. customerDAO.save() chuẩn bị PreparedStatement INSERT INTO tblCustomers (user_id, full_name, email, phone_number, address, joined_at) VALUES (?, ?, ?, ?, ?, ?).

98. customerDAO.save() gán user_id bằng customer.getUserAccountId().

99. customerDAO.save() gán full_name, email, phone_number, address lần lượt từ Customer.

100. customerDAO.save() xác định joinedAt; nếu null thì set LocalDateTime.now(), sau đó bind Timestamp.valueOf(joinedAt).

101. customerDAO.save() thực thi executeUpdate() để tạo bản ghi khách hàng.

102. customerDAO.save() đọc generatedKeys; nếu có, gọi customer.setId(keys.getString(1)).

103. Sau khi thêm khách hàng, saveInformation() gọi con.commit() để hoàn tất transaction.

104. saveInformation() gán member.setId(customer.getId()) để đồng bộ mã khách hàng mới tạo.

105. saveInformation() trả về true báo lưu thành công.

106. Nếu trong transaction xảy ra SQLException, khối catch trong saveInformation() gọi con.rollback() để hoàn tác.

107. saveInformation() ném tiếp SQLException cho tầng gọi xử lý.

108. Khối finally của saveInformation() khôi phục con.setAutoCommit(originalAutoCommit).

109. doPost() nhận kết quả true và gán savedSuccessfully = true.

110. Nếu saveInformation() ném SQLException, khối catch trong doPost() ghi log "Unable to persist member registration".

111. Trong khối catch, doPost() thêm lỗi "Khong the tao tai khoan moi. Vui long thu lai sau." vào errors.

112. doPost() đặt request attribute errors, gọi forwardToForm(req, resp) và kết thúc xử lý POST.

113. Khi savedSuccessfully là false (trường hợp MemberDAO trả về false), doPost() thêm lỗi chung, forward về FillInformation.jsp và chờ người dùng thử lại.

114. Khi savedSuccessfully true và không có lỗi, doPost() gọi resp.sendRedirect(req.getContextPath() + "/login?registered=true").

115. Trình duyệt nhận phản hồi HTTP 302 và điều hướng tới URL /login?registered=true.

116. Tệp web.xml ánh xạ /login tới com.qlst.servlet.LoginServlet.

117. Máy chủ gọi LoginServlet.doGet(req, resp) để xử lý yêu cầu.

118. LoginServlet.doGet() lấy phiên làm việc hiện tại bằng req.getSession(false).

119. Nếu session tồn tại và có thuộc tính currentUser, LoginServlet gửi redirect tới /jsp/MainManagement.jsp để tránh đăng nhập lại.

120. Với khách hàng vừa đăng ký (chưa đăng nhập), LoginServlet phát hiện tham số registered=true trong request.

121. LoginServlet đặt request attribute "message" = "Đăng ký thành công. Vui lòng đăng nhập.".

122. LoginServlet forward tới /jsp/login.jsp để hiển thị thông báo cùng form đăng nhập.

123. Trang login.jsp tải JSTL core và functions để hỗ trợ xử lý giao diện.

124. login.jsp đặt ctx = pageContext.request.contextPath, currentUser = sessionScope.currentUser.

125. login.jsp dựng header tương tự FillInformation.jsp, đánh dấu liên kết Đăng nhập đang hoạt động.

126. login.jsp hiển thị tiêu đề "Đăng nhập tài khoản" cùng mô tả "Nhập thông tin để truy cập bảng điều khiển và báo cáo khách hàng.".

127. login.jsp tạo card chứa form đăng nhập với các trường username và password required.

128. login.jsp kiểm tra attribute error để hiển thị thông báo lỗi nếu đăng nhập sai.

129. login.jsp kiểm tra attribute message và hiển thị khối alert role="status" với nội dung "Đăng ký thành công. Vui lòng đăng nhập.".

130. login.jsp hiển thị liên kết "Chưa có tài khoản? Tạo mới ngay" dẫn về /register để khách hàng khác đăng ký.

131. Khách hàng xem thông báo đăng ký thành công và có thể nhập thông tin đăng nhập để vào hệ thống.

132. Nếu khách hàng quay lại trang đăng ký, liên kết "Đăng ký" trên login.jsp đưa họ về FillInformation.jsp và quy trình lặp lại từ bước 1.

133. Nếu trong quá trình đăng ký có lỗi dữ liệu hoặc giao dịch, khách hàng được đưa về FillInformation.jsp cùng danh sách errors để chỉnh sửa.

134. Nếu khách hàng đóng trình duyệt hoặc rời trang, đăng ký chưa hoàn tất; khi quay lại cần thực hiện lại từ bước 1.

* Khách hàng có thể lặp lại các bước từ 26 đến 113 khi biểu mẫu chưa hợp lệ hoặc lưu thất bại cho đến khi đăng ký thành công.

* Sau khi nhận thông báo ở bước 129, khách hàng có thể chuyển sang chức năng đăng nhập hoặc quay lại bước 1 để đăng ký tài khoản khác.
