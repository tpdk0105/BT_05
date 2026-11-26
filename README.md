# Demo1-1: Spring Boot 4 + JSP/JSTL + SiteMesh 3

Dự án quản lý Category, User và Product.

Công nghệ sử dụng:
- Framework: Spring Boot 4.2.0, Spring MVC, Spring Data JPA
- Giao diện: JSP, JSTL, SiteMesh 3, Bootstrap 5
- Cơ sở dữ liệu: SQL Server (database test)
- Server: Tomcat nhúng, chạy bằng hàm main, không cần cài Tomcat riêng

---

## 1. Yêu cầu môi trường

- JDK 21 trở lên. JAVA_HOME mặc định trên máy đang là JDK 11 nên cần chọn JDK mới hơn, ví dụ C:\Java\jdk-26.0.2.1.
- SQL Server chạy ở localhost:1433, đã có database tên test.
- Thông tin kết nối nằm trong src/main/resources/application.properties. Nếu máy bạn dùng tài khoản khác, sửa spring.datasource.username và spring.datasource.password.
- Các bảng categories, products, [User] được Hibernate tự tạo hoặc cập nhật khi chạy.
- Nếu bảng [User] chưa có dữ liệu, chạy file database/test_User.sql của dự án Login cũ để có tài khoản mẫu.

---

## 2. Cách chạy

### Cách 1: Eclipse / STS

1. Import project: File, Import, Existing Maven Projects, chọn thư mục demo1-1.
2. Chuột phải project, chọn Maven, Update Project, tick Force Update rồi bấm OK.
3. Mở file src/main/java/com/example/demo/Demo11Application.java.
4. Chuột phải, chọn Run As, Spring Boot App.
5. Chờ Console hiện dòng Tomcat started on port 8090.

Nếu báo lỗi phiên bản Java: vào Run Configurations, tab JRE, chọn JDK 21 trở lên.

### Cách 2: Dòng lệnh (PowerShell)

Chạy trực tiếp:

```powershell
$env:JAVA_HOME = "C:\Java\jdk-26.0.2.1"
.\mvnw.cmd spring-boot:run
```

Hoặc đóng gói rồi chạy file jar:

```powershell
.\mvnw.cmd clean package
java -jar target\demo1-1-0.0.1-SNAPSHOT.jar
```

---

## 3. Địa chỉ truy cập

Ứng dụng chạy ở cổng 8090 (đổi bằng server.port trong application.properties).

- Trang chủ: http://localhost:8090/
- Đăng nhập: http://localhost:8090/login
- Đăng ký: http://localhost:8090/register
- Admin: http://localhost:8090/admin/home
- Manager: http://localhost:8090/manager/home

---

## 4. Tài khoản mẫu

- Admin: tài khoản admin, mật khẩu 123456
- Manager: tự tạo (xem bên dưới), mật khẩu tự đặt
- User: đăng ký mới tại trang /register

Cách tạo Manager: đăng nhập Admin, vào Quản lý User, bấm Sửa một user, đổi Vai trò thành 2 - Manager rồi Cập nhật.

---

## 5. Phân quyền

- Admin (roleid 1): quản lý Category và User gồm thêm, sửa, xóa, tìm kiếm, phân trang.
- Manager (roleid 2): quản lý Product gồm thêm, sửa, xóa, tìm kiếm theo tên, lọc theo Category, phân trang.
- User và khách (roleid 3): xem trang chủ, bấm vào Category để xem sản phẩm của danh mục đó.

Truy cập sai quyền sẽ bị chuyển về trang phù hợp với vai trò. Chưa đăng nhập thì về trang đăng nhập.

---

## 6. Các URL chính

### Xác thực

- GET, POST /login
- GET, POST /register
- GET, POST /logout

### Admin: Category

- GET /admin/categories/searchpaginated: danh sách, tìm kiếm, phân trang
- GET /admin/categories/add: form thêm
- POST /admin/categories/insert: lưu thêm mới
- GET /admin/categories/edit/{id}: form sửa
- POST /admin/categories/update: lưu cập nhật
- GET, POST /admin/categories/delete/{id}: xóa

### Admin: User

- GET /admin/users/searchpaginated: danh sách, tìm kiếm, phân trang
- GET /admin/users/add: form thêm
- POST /admin/users/insert: lưu thêm mới
- GET /admin/users/edit/{id}: form sửa
- POST /admin/users/update: lưu cập nhật
- GET, POST /admin/users/delete/{id}: xóa

### Manager: Product

- GET /manager/home: trang quản lý
- GET /manager/products/searchpaginated: danh sách, tìm kiếm, lọc, phân trang
- GET /manager/products/add: form thêm
- POST /manager/products/insert: lưu thêm mới
- GET /manager/products/edit/{id}: form sửa
- POST /manager/products/update: lưu cập nhật
- GET, POST /manager/products/delete/{id}: xóa

---

## 7. Cấu trúc thư mục chính

- src/main/java/com/example/demo/config: cấu hình Tomcat nhúng cho JSP, SiteMesh, interceptor phân quyền
- src/main/java/com/example/demo/controller: controller đăng nhập, trang chủ, admin, manager
- src/main/java/com/example/demo/entity: entity Category, User, Product
- src/main/java/com/example/demo/repository: repository (Spring Data JPA)
- src/main/java/com/example/demo/service: tầng nghiệp vụ
- src/main/resources/META-INF/WEB-INF/views: các trang JSP
- src/main/resources/META-INF/WEB-INF/decorators: layout SiteMesh (web, admin, manager, login)
- src/main/resources/META-INF/commons: header, footer, menu dùng chung

Ảnh upload được lưu ở C:\upload (đổi tại util/Constant.java).

---

## 8. Lỗi thường gặp

Báo "Identify and stop the process that's listening on port 8090":
- Cổng đang bị chiếm do bản chạy trước chưa tắt.
- Bấm nút dừng ở tab Console hoặc Boot Dashboard, hoặc đổi server.port sang số khác.

Không kết nối được database:
- Kiểm tra SQL Server đã bật, đã bật TCP/IP cổng 1433.
- Kiểm tra database test đã tồn tại, tài khoản và mật khẩu trong application.properties đúng.

Lỗi phiên bản Java:
- Chọn JDK 21 trở lên cho project hoặc cho lệnh chạy.

Trang JSP mất giao diện sau khi sửa file:
- Chạy Project, Clean rồi chạy lại ứng dụng.

Không xóa được Category:
- Category đó đang có sản phẩm. Xóa hoặc chuyển sản phẩm trước.
