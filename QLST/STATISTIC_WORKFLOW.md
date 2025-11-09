# WORKFLOW - XEM THỐNG KÊ KHÁCH HÀNG THEO DOANH THU

## Quy trình thực hiện chức năng "Xem thống kê khách hàng theo doanh thu"

1. Nhân viên quản lý đăng nhập vào hệ thống

2. Hệ thống hiển thị giao diện gồm có tiêu đề và các nút chức năng, nút "Thống kê", nút "Đăng xuất"

3. Nhân viên quản lý click "Thống kê"

4. Hệ thống hiển thị lớp MainManagement.jsp

5. Lớp MainManagement.jsp hiển thị giao diện gồm các chức năng quản lý và nút "Xem thống kê khách hàng"

6. Nhân viên quản lý click nút "Xem thống kê khách hàng"

7. Lớp MainManagement.jsp gọi lớp SelectStatisticType.jsp

8. Lớp SelectStatisticType.jsp hiển thị giao diện gồm dropdown chọn loại thống kê, ô nhập ngày bắt đầu, ô nhập ngày kết thúc và nút "Xem thống kê"

9. Nhân viên quản lý chọn loại thống kê "Khách hàng theo doanh thu" từ dropdown

10. Nhân viên quản lý nhập ngày bắt đầu và ngày kết thúc

11. Nhân viên quản lý click nút "Xem thống kê"

12. Lớp SelectStatisticType.jsp gọi lớp CustomerStatisticServlet

13. Lớp CustomerStatisticServlet gọi hàm doGet()

14. Hàm doGet() nhận các tham số statisticType, startDate và endDate

15. Hàm doGet() kiểm tra tính hợp lệ của statisticType

16. Hàm doGet() kiểm tra tính hợp lệ của startDate và endDate

17. Hàm doGet() chuyển đổi startDate từ String sang LocalDate

18. Hàm doGet() chuyển đổi endDate từ String sang LocalDate

19. Hàm doGet() kiểm tra endDate không được nhỏ hơn startDate

20. Hàm doGet() chuyển đổi startDate từ LocalDate sang Date

21. Hàm doGet() chuyển đổi endDate từ LocalDate sang Date

22. Hàm doGet() gọi lớp CustomerStatisticDAO

23. Lớp CustomerStatisticDAO gọi hàm getCustomerStatistic() với tham số startDate và endDate

24. Hàm getCustomerStatistic() khởi tạo danh sách statistics rỗng

25. Hàm getCustomerStatistic() chuẩn bị câu truy vấn SQL để lấy thống kê doanh thu khách hàng

26. Hàm getCustomerStatistic() gọi hàm toStartOfDay() để chuyển đổi startDate sang Timestamp

27. Hàm toStartOfDay() chuyển đổi Date sang LocalDate

28. Hàm toStartOfDay() chuyển đổi LocalDate sang Timestamp bắt đầu ngày

29. Hàm toStartOfDay() trả về Timestamp cho hàm getCustomerStatistic()

30. Hàm getCustomerStatistic() gọi hàm toStartOfNextDay() để chuyển đổi endDate sang Timestamp

31. Hàm toStartOfNextDay() chuyển đổi Date sang LocalDate

32. Hàm toStartOfNextDay() cộng thêm 1 ngày

33. Hàm toStartOfNextDay() chuyển đổi LocalDate sang Timestamp bắt đầu ngày

34. Hàm toStartOfNextDay() trả về Timestamp cho hàm getCustomerStatistic()

35. Hàm getCustomerStatistic() thực thi câu truy vấn SQL với startDate và endDate

36. Hàm getCustomerStatistic() lặp qua từng dòng kết quả trả về

37. Hàm getCustomerStatistic() gọi hàm mapCustomer() để đóng gói thông tin khách hàng

38. Hàm mapCustomer() khởi tạo đối tượng Customer

39. Hàm mapCustomer() lấy customer_id từ ResultSet

40. Hàm mapCustomer() gọi lớp Customer để gán id

41. Lớp Customer gán giá trị id

42. Lớp Customer trả về kết quả cho hàm mapCustomer()

43. Hàm mapCustomer() lấy full_name từ ResultSet

44. Hàm mapCustomer() gọi lớp Customer để gán name

45. Lớp Customer gán giá trị name

46. Lớp Customer trả về kết quả cho hàm mapCustomer()

47. Hàm mapCustomer() lấy email từ ResultSet

48. Hàm mapCustomer() gọi lớp Customer để gán email

49. Lớp Customer gán giá trị email

50. Lớp Customer trả về kết quả cho hàm mapCustomer()

51. Hàm mapCustomer() lấy phone_number từ ResultSet

52. Hàm mapCustomer() gọi lớp Customer để gán phone

53. Lớp Customer gán giá trị phone

54. Lớp Customer trả về kết quả cho hàm mapCustomer()

55. Hàm mapCustomer() lấy address từ ResultSet

56. Hàm mapCustomer() gọi lớp Customer để gán address

57. Lớp Customer gán giá trị address

58. Lớp Customer trả về kết quả cho hàm mapCustomer()

59. Hàm mapCustomer() trả về đối tượng Customer cho hàm getCustomerStatistic()

60. Hàm getCustomerStatistic() lấy total_revenue từ ResultSet

61. Hàm getCustomerStatistic() chuyển đổi total_revenue từ BigDecimal sang float

62. Hàm getCustomerStatistic() gọi lớp CustomerStatistic để đóng gói thông tin thống kê

63. Lớp CustomerStatistic khởi tạo đối tượng với customer và totalPrice

64. Lớp CustomerStatistic đóng gói thông tin thực thể thống kê

65. Lớp CustomerStatistic trả về kết quả cho hàm getCustomerStatistic()

66. Hàm getCustomerStatistic() thêm đối tượng CustomerStatistic vào danh sách statistics

67. Hàm getCustomerStatistic() trả về danh sách statistics cho hàm doGet()

68. Hàm doGet() lưu danh sách statistics vào request attribute "listCustomerStatistic"

69. Hàm doGet() lưu startDate vào request attribute "startDate"

70. Hàm doGet() lưu endDate vào request attribute "endDate"

71. Hàm doGet() gọi lớp CustomerStatistic.jsp để hiển thị kết quả

72. Lớp CustomerStatistic.jsp hiển thị giao diện gồm tiêu đề "Kết quả thống kê khách hàng"

73. Lớp CustomerStatistic.jsp hiển thị thông tin khoảng thời gian thống kê

74. Lớp CustomerStatistic.jsp hiển thị số lượng khách hàng

75. Lớp CustomerStatistic.jsp hiển thị ô tìm kiếm

76. Lớp CustomerStatistic.jsp hiển thị bảng danh sách khách hàng với các cột: Mã khách hàng, Họ tên, Tổng doanh thu và Thao tác

77. Lớp CustomerStatistic.jsp lặp qua từng CustomerStatistic trong listCustomerStatistic

78. Lớp CustomerStatistic.jsp hiển thị thông tin mã khách hàng, họ tên, tổng doanh thu và nút "Xem chi tiết"

79. Nhân viên quản lý xem kết quả thống kê khách hàng theo doanh thu được sắp xếp giảm dần theo tổng doanh thu

80. Nhân viên quản lý có thể nhập từ khóa vào ô tìm kiếm để lọc danh sách khách hàng theo mã hoặc tên

81. Lớp CustomerStatistic.jsp thực hiện tìm kiếm nhanh trên client-side và hiển thị kết quả lọc

82. Nhân viên quản lý click nút "Xem chi tiết" của một khách hàng

83. Lớp CustomerStatistic.jsp gọi lớp OrderServlet với tham số customerId, startDate và endDate

84. Lớp OrderServlet gọi hàm doGet()

85. Hàm doGet() nhận các tham số customerId, startDate và endDate

86. Hàm doGet() kiểm tra tính hợp lệ của customerId

87. Hàm doGet() kiểm tra tính hợp lệ của startDate và endDate

88. Hàm doGet() chuyển đổi startDate từ String sang LocalDate

89. Hàm doGet() chuyển đổi endDate từ String sang LocalDate

90. Hàm doGet() kiểm tra endDate không được nhỏ hơn startDate

91. Hàm doGet() chuyển đổi startDate từ LocalDate sang Date

92. Hàm doGet() chuyển đổi endDate từ LocalDate sang Date

93. Hàm doGet() gọi lớp OrderDAO

94. Lớp OrderDAO gọi hàm getOrderList() với tham số customerId, startDate và endDate

95. Hàm getOrderList() khởi tạo danh sách orders rỗng

96. Hàm getOrderList() chuẩn bị câu truy vấn SQL để lấy danh sách đơn hàng

97. Hàm getOrderList() gọi hàm toStartOfDay() để chuyển đổi startDate sang Timestamp

98. Hàm toStartOfDay() chuyển đổi Date sang LocalDate

99. Hàm toStartOfDay() chuyển đổi LocalDate sang Timestamp bắt đầu ngày

100. Hàm toStartOfDay() trả về Timestamp cho hàm getOrderList()

101. Hàm getOrderList() gọi hàm toStartOfNextDay() để chuyển đổi endDate sang Timestamp

102. Hàm toStartOfNextDay() chuyển đổi Date sang LocalDate

103. Hàm toStartOfNextDay() cộng thêm 1 ngày

104. Hàm toStartOfNextDay() chuyển đổi LocalDate sang Timestamp bắt đầu ngày

105. Hàm toStartOfNextDay() trả về Timestamp cho hàm getOrderList()

106. Hàm getOrderList() thực thi câu truy vấn SQL với customerId, startDate và endDate

107. Hàm getOrderList() lặp qua từng dòng kết quả trả về

108. Hàm getOrderList() gọi hàm mapOrder() để đóng gói thông tin đơn hàng

109. Hàm mapOrder() khởi tạo đối tượng Order

110. Hàm mapOrder() lấy order_id từ ResultSet

111. Hàm mapOrder() gọi lớp Order để gán id

112. Lớp Order gán giá trị id

113. Lớp Order trả về kết quả cho hàm mapOrder()

114. Hàm mapOrder() lấy order_date từ ResultSet

115. Hàm mapOrder() gọi lớp Order để gán date

116. Lớp Order gán giá trị date

117. Lớp Order trả về kết quả cho hàm mapOrder()

118. Hàm mapOrder() lấy total_price từ ResultSet

119. Hàm mapOrder() chuyển đổi total_price từ BigDecimal sang float

120. Hàm mapOrder() gọi lớp Order để gán totalPrice

121. Lớp Order gán giá trị totalPrice

122. Lớp Order trả về kết quả cho hàm mapOrder()

123. Hàm mapOrder() gọi hàm mapCustomer() để đóng gói thông tin khách hàng

124. Hàm mapCustomer() khởi tạo đối tượng Customer

125. Hàm mapCustomer() lấy customer_id từ ResultSet

126. Hàm mapCustomer() gọi lớp Customer để gán id

127. Lớp Customer gán giá trị id

128. Lớp Customer trả về kết quả cho hàm mapCustomer()

129. Hàm mapCustomer() lấy full_name từ ResultSet

130. Hàm mapCustomer() gọi lớp Customer để gán name

131. Lớp Customer gán giá trị name

132. Lớp Customer trả về kết quả cho hàm mapCustomer()

133. Hàm mapCustomer() lấy email từ ResultSet

134. Hàm mapCustomer() gọi lớp Customer để gán email

135. Lớp Customer gán giá trị email

136. Lớp Customer trả về kết quả cho hàm mapCustomer()

137. Hàm mapCustomer() lấy phone_number từ ResultSet

138. Hàm mapCustomer() gọi lớp Customer để gán phone

139. Lớp Customer gán giá trị phone

140. Lớp Customer trả về kết quả cho hàm mapCustomer()

141. Hàm mapCustomer() lấy address từ ResultSet

142. Hàm mapCustomer() gọi lớp Customer để gán address

143. Lớp Customer gán giá trị address

144. Lớp Customer trả về kết quả cho hàm mapCustomer()

145. Hàm mapCustomer() trả về đối tượng Customer cho hàm mapOrder()

146. Hàm mapOrder() gọi lớp Order để gán customer

147. Lớp Order gán giá trị customer

148. Lớp Order trả về kết quả cho hàm mapOrder()

149. Hàm mapOrder() trả về đối tượng Order cho hàm getOrderList()

150. Hàm getOrderList() thêm đối tượng Order vào danh sách orders

151. Hàm getOrderList() trả về danh sách orders cho hàm doGet()

152. Hàm doGet() gọi lớp OrderDAO

153. Lớp OrderDAO gọi hàm sumTotalPrice() với tham số orders

154. Hàm sumTotalPrice() khởi tạo biến total bằng 0

155. Hàm sumTotalPrice() lặp qua từng Order trong danh sách orders

156. Hàm sumTotalPrice() cộng dồn totalPrice của từng Order vào biến total

157. Hàm sumTotalPrice() trả về tổng total cho hàm doGet()

158. Hàm doGet() gọi lớp CustomerDAO

159. Lớp CustomerDAO gọi hàm resolveCustomer() với tham số customerId và orders

160. Hàm resolveCustomer() kiểm tra nếu orders không rỗng và có customer

161. Hàm resolveCustomer() trả về customer từ đơn hàng đầu tiên cho hàm doGet()

162. Hàm doGet() gọi lớp CustomerStatistic để đóng gói thông tin thống kê

163. Lớp CustomerStatistic khởi tạo đối tượng với customer và totalPrice

164. Lớp CustomerStatistic đóng gói thông tin thực thể thống kê

165. Lớp CustomerStatistic trả về kết quả cho hàm doGet()

166. Hàm doGet() lưu danh sách orders vào request attribute "lstOrder"

167. Hàm doGet() lưu customerStatistic vào request attribute "customerStatistic"

168. Hàm doGet() gọi lớp CustomerOrder.jsp để hiển thị kết quả

169. Lớp CustomerOrder.jsp hiển thị giao diện gồm tiêu đề "Đơn hàng theo khách hàng"

170. Lớp CustomerOrder.jsp hiển thị thông tin khách hàng, mã khách hàng và tổng doanh thu

171. Lớp CustomerOrder.jsp hiển thị nút "Quay lại thống kê"

172. Lớp CustomerOrder.jsp hiển thị bảng danh sách đơn hàng với các cột: Mã đơn hàng, Ngày đặt hàng, Tổng tiền và Thao tác

173. Lớp CustomerOrder.jsp lặp qua từng Order trong lstOrder

174. Lớp CustomerOrder.jsp hiển thị thông tin mã đơn hàng, ngày đặt hàng, tổng tiền và nút "Xem chi tiết"

175. Nhân viên quản lý xem danh sách đơn hàng của khách hàng

176. Nhân viên quản lý click nút "Xem chi tiết" của một đơn hàng

177. Lớp CustomerOrder.jsp gọi lớp CustomerOrderDetailServlet với tham số orderId, customerId, startDate và endDate

178. Lớp CustomerOrderDetailServlet gọi hàm doGet()

179. Hàm doGet() nhận các tham số orderId, customerId, startDate và endDate

180. Hàm doGet() lưu customerId vào request attribute "customerId"

181. Hàm doGet() lưu startDate vào request attribute "startDate"

182. Hàm doGet() lưu endDate vào request attribute "endDate"

183. Hàm doGet() kiểm tra tính hợp lệ của orderId

184. Hàm doGet() gọi lớp OrderDAO

185. Lớp OrderDAO gọi hàm getOrderDetail() với tham số orderId

186. Hàm getOrderDetail() khởi tạo biến order bằng null

187. Hàm getOrderDetail() chuẩn bị câu truy vấn SQL để lấy chi tiết đơn hàng

188. Hàm getOrderDetail() thực thi câu truy vấn SQL với orderId

189. Hàm getOrderDetail() lặp qua từng dòng kết quả trả về

190. Hàm getOrderDetail() kiểm tra nếu order bằng null

191. Hàm getOrderDetail() gọi hàm mapOrder() để đóng gói thông tin đơn hàng

192. Hàm mapOrder() khởi tạo đối tượng Order

193. Hàm mapOrder() lấy order_id từ ResultSet

194. Hàm mapOrder() gọi lớp Order để gán id

195. Lớp Order gán giá trị id

196. Lớp Order trả về kết quả cho hàm mapOrder()

197. Hàm mapOrder() lấy order_date từ ResultSet

198. Hàm mapOrder() gọi lớp Order để gán date

199. Lớp Order gán giá trị date

200. Lớp Order trả về kết quả cho hàm mapOrder()

201. Hàm mapOrder() lấy total_price từ ResultSet

202. Hàm mapOrder() chuyển đổi total_price từ BigDecimal sang float

203. Hàm mapOrder() gọi lớp Order để gán totalPrice

204. Lớp Order gán giá trị totalPrice

205. Lớp Order trả về kết quả cho hàm mapOrder()

206. Hàm mapOrder() gọi hàm mapCustomer() để đóng gói thông tin khách hàng

207. Hàm mapCustomer() khởi tạo đối tượng Customer

208. Hàm mapCustomer() lấy customer_id từ ResultSet

209. Hàm mapCustomer() gọi lớp Customer để gán id

210. Lớp Customer gán giá trị id

211. Lớp Customer trả về kết quả cho hàm mapCustomer()

212. Hàm mapCustomer() lấy full_name từ ResultSet

213. Hàm mapCustomer() gọi lớp Customer để gán name

214. Lớp Customer gán giá trị name

215. Lớp Customer trả về kết quả cho hàm mapCustomer()

216. Hàm mapCustomer() lấy email từ ResultSet

217. Hàm mapCustomer() gọi lớp Customer để gán email

218. Lớp Customer gán giá trị email

219. Lớp Customer trả về kết quả cho hàm mapCustomer()

220. Hàm mapCustomer() lấy phone_number từ ResultSet

221. Hàm mapCustomer() gọi lớp Customer để gán phone

222. Lớp Customer gán giá trị phone

223. Lớp Customer trả về kết quả cho hàm mapCustomer()

224. Hàm mapCustomer() lấy address từ ResultSet

225. Hàm mapCustomer() gọi lớp Customer để gán address

226. Lớp Customer gán giá trị address

227. Lớp Customer trả về kết quả cho hàm mapCustomer()

228. Hàm mapCustomer() trả về đối tượng Customer cho hàm mapOrder()

229. Hàm mapOrder() gọi lớp Order để gán customer

230. Lớp Order gán giá trị customer

231. Lớp Order trả về kết quả cho hàm mapOrder()

232. Hàm mapOrder() trả về đối tượng Order cho hàm getOrderDetail()

233. Hàm getOrderDetail() lấy product_id từ ResultSet

234. Hàm getOrderDetail() kiểm tra nếu product_id không null

235. Hàm getOrderDetail() gọi hàm mapOrderDetail() để đóng gói thông tin chi tiết đơn hàng

236. Hàm mapOrderDetail() khởi tạo đối tượng OrderDetail

237. Hàm mapOrderDetail() lấy order_detail_price từ ResultSet

238. Hàm mapOrderDetail() chuyển đổi order_detail_price từ BigDecimal sang float

239. Hàm mapOrderDetail() gọi lớp OrderDetail để gán price

240. Lớp OrderDetail gán giá trị price

241. Lớp OrderDetail trả về kết quả cho hàm mapOrderDetail()

242. Hàm mapOrderDetail() lấy order_detail_quantity từ ResultSet

243. Hàm mapOrderDetail() gọi lớp OrderDetail để gán quantity

244. Lớp OrderDetail gán giá trị quantity

245. Lớp OrderDetail trả về kết quả cho hàm mapOrderDetail()

246. Hàm mapOrderDetail() lấy product_id từ ResultSet

247. Hàm mapOrderDetail() kiểm tra nếu product_id không null

248. Hàm mapOrderDetail() khởi tạo đối tượng Product

249. Hàm mapOrderDetail() lấy product_id từ ResultSet

250. Hàm mapOrderDetail() gọi lớp Product để gán id

251. Lớp Product gán giá trị id

252. Lớp Product trả về kết quả cho hàm mapOrderDetail()

253. Hàm mapOrderDetail() lấy product_name từ ResultSet

254. Hàm mapOrderDetail() gọi lớp Product để gán name

255. Lớp Product gán giá trị name

256. Lớp Product trả về kết quả cho hàm mapOrderDetail()

257. Hàm mapOrderDetail() lấy product_price từ ResultSet

258. Hàm mapOrderDetail() chuyển đổi product_price từ BigDecimal sang float

259. Hàm mapOrderDetail() gọi lớp Product để gán price

260. Lớp Product gán giá trị price

261. Lớp Product trả về kết quả cho hàm mapOrderDetail()

262. Hàm mapOrderDetail() lấy product_stock_quantity từ ResultSet

263. Hàm mapOrderDetail() gọi lớp Product để gán quantity

264. Lớp Product gán giá trị quantity

265. Lớp Product trả về kết quả cho hàm mapOrderDetail()

266. Hàm mapOrderDetail() gọi lớp OrderDetail để gán product

267. Lớp OrderDetail gán giá trị product

268. Lớp OrderDetail trả về kết quả cho hàm mapOrderDetail()

269. Hàm mapOrderDetail() trả về đối tượng OrderDetail cho hàm getOrderDetail()

270. Hàm getOrderDetail() gọi lớp OrderDetail để gán order

271. Lớp OrderDetail gán giá trị order

272. Lớp OrderDetail trả về kết quả cho hàm getOrderDetail()

273. Hàm getOrderDetail() gọi lớp Order để lấy listOrderDetail

274. Lớp Order trả về listOrderDetail cho hàm getOrderDetail()

275. Hàm getOrderDetail() thêm đối tượng OrderDetail vào listOrderDetail

276. Hàm getOrderDetail() trả về đối tượng Order cho hàm doGet()

277. Hàm doGet() kiểm tra nếu order bằng null

278. Hàm doGet() lưu order vào request attribute "order"

279. Hàm doGet() gọi lớp CustomerOrderDetail.jsp để hiển thị kết quả

280. Lớp CustomerOrderDetail.jsp hiển thị giao diện gồm tiêu đề "Chi tiết đơn hàng"

281. Lớp CustomerOrderDetail.jsp hiển thị thông tin mã đơn hàng, ngày đặt hàng, khách hàng và tổng tiền

282. Lớp CustomerOrderDetail.jsp hiển thị nút "Quay lại danh sách đơn hàng"

283. Lớp CustomerOrderDetail.jsp hiển thị bảng danh sách sản phẩm với các cột: Tên sản phẩm, Đơn giá, Số lượng và Thành tiền

284. Lớp CustomerOrderDetail.jsp lặp qua từng OrderDetail trong listOrderDetail của order

285. Lớp CustomerOrderDetail.jsp gọi lớp OrderDetail để lấy product

286. Lớp OrderDetail trả về product cho lớp CustomerOrderDetail.jsp

287. Lớp CustomerOrderDetail.jsp gọi lớp Product để lấy name

288. Lớp Product trả về name cho lớp CustomerOrderDetail.jsp

289. Lớp CustomerOrderDetail.jsp gọi lớp OrderDetail để lấy price

290. Lớp OrderDetail trả về price cho lớp CustomerOrderDetail.jsp

291. Lớp CustomerOrderDetail.jsp gọi lớp OrderDetail để lấy quantity

292. Lớp OrderDetail trả về quantity cho lớp CustomerOrderDetail.jsp

293. Lớp CustomerOrderDetail.jsp tính thành tiền bằng price nhân quantity

294. Lớp CustomerOrderDetail.jsp hiển thị thông tin tên sản phẩm, đơn giá, số lượng và thành tiền

295. Nhân viên quản lý xem chi tiết đơn hàng với danh sách sản phẩm

296. Nhân viên quản lý click nút "Quay lại danh sách đơn hàng"

297. Lớp CustomerOrderDetail.jsp gọi lại lớp OrderServlet với tham số customerId, startDate và endDate

298. Hệ thống quay lại trang CustomerOrder.jsp hiển thị danh sách đơn hàng của khách hàng

* Nhân viên quản lý có thể quay lại bước 176 để xem chi tiết đơn hàng khác

* Nhân viên quản lý có thể click nút "Quay lại thống kê" tại bước 171 để quay lại trang CustomerStatistic.jsp

* Nhân viên quản lý có thể quay lại bước 82 để xem chi tiết đơn hàng của khách hàng khác

* Nhân viên quản lý có thể quay lại bước 6 để thực hiện thống kê với khoảng thời gian khác hoặc loại thống kê khác

299. Nhân viên quản lý hoàn thành xem thống kê khách hàng theo doanh thu
