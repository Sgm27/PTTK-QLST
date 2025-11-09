# WORKFLOW - DANG KY THANH VIEN

## Quy trinh thuc hien chuc nang "Dang ky thanh vien"

1. Khach hang mo trinh duyet va truy cap ten mien trien khai QLST (vi du `https://qlst.example.com`).

2. Trang `index.jsp` (`src/main/webapp/index.jsp`) tra ve the `<c:redirect url="/login"/>` de chuyen khach ve URL `/login`.

3. Tep `WEB-INF/web.xml` gan URL pattern `/login` cho lop servlet `com.qlst.servlet.LoginServlet`.

4. Container khoi tao `LoginServlet` neu chua co trong bo nho va goi `service()` cho request GET.

5. Ham `LoginServlet.doGet()` kiem tra session `currentUser`, roi forward request toi `/jsp/login.jsp` khi khach hang chua dang nhap.

6. Lop `login.jsp` (`src/main/webapp/jsp/login.jsp`) cai dat top bar voi lien ket "Dang ky" tro toi `${ctx}/register`.

7. Khach hang click lien ket "Dang ky" tren trang dang nhap de bat dau quy trinh tao tai khoan.

8. Trinh duyet gui request GET toi `${contextPath}/register`.

9. Tep `WEB-INF/web.xml` anh xa URL `/register` toi lop `com.qlst.servlet.RegisterServlet`.

10. Container khoi tao `RegisterServlet` (neu chua) va goi `service()` -> `doGet()` vi request la GET.

11. Ham `RegisterServlet.doGet()` chi goi `forwardToForm(req, resp)` de hien form dang ky.

12. Ham `forwardToForm()` dung `RequestDispatcher` forward request toi hang so `FORM_VIEW = "/jsp/FillInformation.jsp"`.

13. Lop `FillInformation.jsp` (`src/main/webapp/jsp/FillInformation.jsp`) khoi tao cac bien JSTL `ctx`, `currentPage`, `currentUser`.

14. Lop `FillInformation.jsp` render header `.top-bar` hien logo, menu, trang thai xin chao va nut dang xuat neu `sessionScope.currentUser` ton tai.

15. Lop `FillInformation.jsp` hien phan page header giai thich muc tieu "Dien thong tin thanh vien" va khung noi dung `.card`.

16. Lop `FillInformation.jsp` kiem tra `requestScope.errors` de hien hop `<div class="alert">` va danh sach `<li>` thong diep loi bang `<c:forEach>`.

17. Lop `FillInformation.jsp` tao `<form action="${ctx}/register" method="post" autocomplete="off">` de thu thap thong tin.

18. Form su dung bang `#tblInputInformation` gom cac truong va tu dong dien lai gia tri `${formData}` neu request quay ve tu servlet.

19. Dong 1 co truong ho ten `input#name` (`type="text"`, `required`, `autocomplete="name"`, placeholder "Nguyen Van A").

20. Dong 2 co truong mat khau `input#password` (`type="password"`, `required`, `autocomplete="new-password"`, placeholder "Toi thieu 8 ky tu").

21. Dong 3 co truong `input#email` (`type="email"`, `required`, `autocomplete="email"`) de dam bao dinh dang email hop le.

22. Dong 4 co truong `input#address` (`type="text"`) tuy chon, lay gia tri `${formData.address}` neu co.

23. Dong 5 co truong `input#phone` (`type="tel"`) tuy chon, hien gia tri `${formData.phone}` neu da nhap.

24. Nhom nut `button-row` gom the `<a>` "Da co tai khoan" tro ve `${ctx}/login` va nut submit `<button id="btnRegister" class="btn btn--primary">Gui yeu cau</button>`.

25. Khach hang dien du lieu va nhan "Gui yeu cau"; trinh duyet thuc hien HTML5 validation (required/type) truoc khi gui.

26. Neu validation thanh cong, form duoc POST toi `/register` voi noi dung `application/x-www-form-urlencoded`.

27. Container goi `RegisterServlet.doPost()` de xu ly request POST.

28. Ham `doPost()` dat `req.setCharacterEncoding("UTF-8")` de doc dung ky tu Unicode.

29. Ham `doPost()` doc mat khau goc bang `StringUtils.defaultString(req.getParameter("password"))`.

30. Ham `doPost()` goi `extractFormData(req)` de tao doi tuong `Member`.

31. Ham `extractFormData()` su dung `StringUtils.trimToEmpty` cho `name` va `email` de tranh `null`.

32. Ham `extractFormData()` su dung `StringUtils.trimToNull` cho `address` va `phone` de luu gia tri `null` neu nguoi dung bo trong.

33. Ham `doPost()` tao danh sach loi `List<String> errors = new ArrayList<>()` va gan `formData` vao request attribute de JSP hien lai gia tri.

34. Ham `doPost()` goi `validateRequiredFields(formData, rawPassword, errors)` de kiem tra cac truong bat buoc.

35. Ham `validateRequiredFields()` kiem tra `StringUtils.isBlank(formData.getName())` va them "Ho va ten khong duoc de trong." neu vi pham.

36. Ham `validateRequiredFields()` kiem tra `rawPassword` rong hoac co do dai < 8 ky tu va them cac thong diep loi tuong ung.

37. Ham `validateRequiredFields()` kiem tra `StringUtils.isBlank(formData.getEmail())` de dam bao email bat buoc.

38. Neu danh sach loi dang rong, `doPost()` goi `validateUniqueness(formData, errors)` de tra soat du lieu trung lap.

39. Ham `validateUniqueness()` goi `userDAO.findByUsername(formData.getName())`.

40. Lop `UserDAO` mo ket noi bang `DBConnection.getConnection()` va chuan bi cau lenh `SELECT ... FROM tblUsers WHERE username = ?`.

41. Ham `UserDAO.findByUsername()` su dung `PreparedStatement`, set tham so username va thuc thi query.

42. Ham `UserDAO.findByUsername()` map ban ghi dau tien thanh doi tuong `User` bang ham noi bo `mapRow(ResultSet)`.

43. Neu `Optional<User>` khong rong, `validateUniqueness()` them thong diep "Ten dang nhap da ton tai. Vui long chon ten khac." vao danh sach loi.

44. Ham `validateUniqueness()` goi tiep `userDAO.findByEmail(formData.getEmail())`.

45. Ham `UserDAO.findByEmail()` thuc hien cau SQL `SELECT ... FROM tblUsers WHERE email = ?` va tra ve `Optional<User>`.

46. Neu email da duoc su dung, `validateUniqueness()` them thong diep "Email da duoc su dung." vao danh sach loi.

47. Neu `UserDAO` nem `SQLException`, `validateUniqueness()` bao boc thanh `ServletException` voi thong diep "Khong the kiem tra tinh duy nhat cua ten dang nhap/email.".

48. Khi `errors` khong rong, `doPost()` gan attribute `errors` va goi `forwardToForm(req, resp)` de render lai `FillInformation.jsp`.

49. Lop `FillInformation.jsp` lap qua `${errors}` bang `<c:forEach>` va hien danh sach loi de khach hang sua thong tin.

50. Khach hang dieu chinh du lieu va gui lai form (lap lai cac buoc 25-48) cho den khi tat ca dieu kien hop le.

51. Khi khong con loi, `doPost()` goi `Member memberToPersist = buildMemberToPersist(formData, rawPassword)`.

52. Ham `buildMemberToPersist()` copy `name`, `email`, `address`, `phone` sang doi tuong moi.

53. Ham `buildMemberToPersist()` goi `PasswordUtil.hashPassword(rawPassword)` de ma hoa mat khau bang SHA-256 va set vao truong `password`.

54. Lop `PasswordUtil` dung `MessageDigest` voi thuat toan `"SHA-256"`, ma hoa chuoi UTF-8 va ghep moi byte thanh chuoi hex `%02x`.

55. Ham `doPost()` mo khoi `try (MemberDAO memberDAO = new MemberDAO()) { ... }` de dam bao ket noi JDBC duoc dong tu dong.

56. Lop `MemberDAO` ke thua `DAO`; constructor lop cha goi `DBConnection.getConnection()` va gan truong `Connection con`.

57. Ham `MemberDAO.saveInformation(memberToPersist)` khoi dong giao dich tao tai khoan thanh vien.

58. Ham `saveInformation()` luu trang thai `autoCommit`, dat `con.setAutoCommit(false)` de tu quan ly giao dich.

59. Ham `saveInformation()` goi `String userId = insertUser(member)` de chen ban ghi vao `tblUsers`.

60. Ham `insertUser()` tao `PreparedStatement` voi `Statement.RETURN_GENERATED_KEYS` va set cac cot username, password_hash, role = `"CUSTOMER"`, full_name, email, phone_number, created_at (`Timestamp` tu `LocalDateTime.now()`).

61. Ham `insertUser()` thuc thi `executeUpdate()` va doc `generatedKeys` de thu ve `id` user moi tao.

62. Neu khong the doc khoa sinh ra, `insertUser()` nem `SQLException` "Khong the lay ma nguoi dung sau khi tao thanh vien.".

63. Ham `saveInformation()` goi `Customer customer = toCustomer(member, userId)` de tao doi tuong `Customer`.

64. Ham `toCustomer()` copy `name`, `email`, `phone`, `address`, set `userAccountId = userId` va `joinedAt = LocalDateTime.now()`.

65. Ham `saveInformation()` goi `customerDAO.save(con, customer)` de chen ho so khach hang vao `tblCustomers`.

66. Ham `CustomerDAO.save()` kiem tra `customer.getUserAccountId()` khong null; neu null thi nem `IllegalArgumentException`.

67. Ham `CustomerDAO.save()` tao `PreparedStatement` `INSERT INTO tblCustomers (user_id, full_name, email, phone_number, address, joined_at) VALUES (?, ?, ?, ?, ?, ?)` va set du lieu.

68. Ham `CustomerDAO.save()` dat `Timestamp.valueOf(joinedAt)` (neu `joinedAt` null thi dat `LocalDateTime.now()`) truoc khi thuc thi `executeUpdate()`.

69. Ham `CustomerDAO.save()` doc `ResultSet keys = statement.getGeneratedKeys()` va gan `customer.setId(keys.getString(1))` neu co ban ghi.

70. Sau khi chen thanh cong ca user va customer, `saveInformation()` goi `con.commit()` de hoan tat giao dich.

71. Ham `saveInformation()` gan `member.setId(customer.getId())` de servlet biet ma khach hang moi.

72. Ham `saveInformation()` tra ve `true` de thong bao luu thanh cong.

73. Neu bat ky `SQLException` nao xay ra, `saveInformation()` goi `con.rollback()` roi nem lai loi cho tang goi.

74. Khoi `finally` cua `saveInformation()` khoi phuc trang thai `con.setAutoCommit(originalAutoCommit)`.

75. Trong `RegisterServlet`, neu `memberDAO.saveInformation()` nem loi, `doPost()` goi `log("Unable to persist member registration", e)` va them thong diep "Khong the tao tai khoan moi. Vui long thu lai sau.".

76. Neu `saveInformation()` tra ve `false`, `doPost()` cung them thong diep loi chung va forward ve form.

77. Khi viec luu thanh cong, `doPost()` dat request attribute `member = memberToPersist` (chua id, ten, email, phone, address).

78. Ham `doPost()` forward request toi `/jsp/DoSaveMember.jsp` de hien thong bao thanh cong.

79. Lop `DoSaveMember.jsp` import `com.qlst.model.Member` va doc doi tuong tu `request.getAttribute("member")`.

80. Lop `DoSaveMember.jsp` kiem tra neu `member == null` thi `response.sendRedirect(request.getContextPath() + "/register")` de ngan truy cap truc tiep.

81. Lop `DoSaveMember.jsp` render icon thanh cong SVG, tieu de "Dang ky thanh cong!" va mo ta loi chao.

82. Lop `DoSaveMember.jsp` hien `div.member-info` voi cac dong thong tin ho ten va email luon co.

83. Lop `DoSaveMember.jsp` hien dong "So dien thoai" neu `member.getPhone()` khong rong va dong "Dia chi" neu `member.getAddress()` khong rong.

84. Lop `DoSaveMember.jsp` hien nhom nut `.action-buttons` gom 2 hanh dong.

85. Nut "Dang nhap ngay" lien ket toi `${ctx}/login?registered=true` de thong bao he thong ve viec dang ky vua hoan tat.

86. Nut "Ve trang chu" tro ve `${ctx}/` de khach hang quay lai trang chu.

87. Khi nguoi dung click "Dang nhap ngay", trinh duyet gui GET `/login?registered=true`.

88. Ham `LoginServlet.doGet()` nhan tham so `registered=true` va set request attribute `message = "Dang ky thanh cong. Vui long dang nhap."`.

89. Lop `login.jsp` kiem tra `${not empty message}` va hien `<div class="alert" role="status">` thong bao thanh cong tren trang dang nhap.

90. Neu nguoi dung quay lai `/register`, `RegisterServlet.doGet()` lap lai cac buoc 11-24 de cung cap form dang ky.

91. Lop `RegisterServlet` ke thua `HttpServlet`, su dung cac vong doi `init()` / `destroy()` duoc container quan ly cho he thong servlet.

92. Lop `MemberDAO` trien khai `AutoCloseable` (thong qua lop cha `DAO`) nen try-with-resources o buoc 55 se dong ket noi du even co loi.

93. Lop `DBConnection` nap file `src/main/resources/db.properties`, dang ky driver `com.mysql.cj.jdbc.Driver` va tao chuoi `jdbc:mysql://host:port/database` cho toan bo DAO.

94. Lop `PasswordUtil` cung cap them ham `matches()` duoc `LoginServlet` su dung, dam bao gia tri hash tao o buoc 53 co the duoc doi chieu khi nguoi dung dang nhap sau nay.
