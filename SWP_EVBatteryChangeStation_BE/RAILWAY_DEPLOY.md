# Hướng dẫn Deploy lên Railway với Docker

## Vấn đề đã được sửa

File `railway.json` đã được cập nhật để sử dụng Docker thay vì RAILPACK, giải quyết lỗi "Error creating build plan with Railpack".

## Các bước deploy

### 1. Đảm bảo các file đã được cấu hình đúng

- ✅ `railway.json` - đã cấu hình để dùng Docker
- ✅ `Dockerfile` - đã sẵn sàng
- ✅ `.dockerignore` - đã có

### 2. Kết nối repository với Railway

1. Đăng nhập vào [railway.app](https://railway.app)
2. Tạo New Project → Deploy from GitHub repo
3. Chọn repository của bạn

### 3. Cấu hình Environment Variables

Vào **Variables** tab trong Railway dashboard và thêm các biến sau:

```env
# Database Connection (quan trọng nhất)
ConnectionStrings__DefaultConnection=server=YOUR_DB_SERVER;database=EVBatterySwap;uid=YOUR_USER;pwd=YOUR_PASSWORD;TrustServerCertificate=True

# ASP.NET Core Configuration
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://+:${PORT}

# JWT Configuration
JwtConfig__Key=Hi18MvspEcBtmCVfaxD/rCGCzOotOf/wX3ntuh1tIN0=khongthemokhoa
JwtConfig__Issuer=App
JwtConfig__Audience=App
JwtConfig__ExpireMinutes=30

# Email Settings
EmailSettings__Email=your-email@gmail.com
EmailSettings__AppPassword=your-app-password

# VNPay Configuration
Vnpay__TmnCode=YOUR_TMN_CODE
Vnpay__HashSecret=YOUR_HASH_SECRET
Vnpay__BaseUrl=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
Vnpay__ReturnUrl=https://your-app.railway.app/api/VNPay/vnpay-return
Vnpay__Command=pay
Vnpay__CurrCode=VND
Vnpay__Version=2.1.0
Vnpay__Locale=vn

# CORS Origins (nếu cần)
AllowedOrigins__0=https://your-frontend-domain.com
AllowedOrigins__1=http://localhost:3000
```

**Lưu ý quan trọng:**
- Railway tự động set biến `PORT`, nên dùng `ASPNETCORE_URLS=http://+:${PORT}` để app lắng nghe đúng port
- Thay `YOUR_DB_SERVER`, `YOUR_USER`, `YOUR_PASSWORD` bằng thông tin database thật của bạn
- Thay `your-app.railway.app` bằng domain Railway của bạn (sẽ có sau khi deploy)

### 4. Cấu hình Build Settings (nếu cần)

1. Vào **Settings** → **Build**
2. Đảm bảo **Build Command** để trống (Railway sẽ tự động dùng Dockerfile)
3. Nếu thấy lỗi về Railpack, chọn **Dockerfile** trong phần Build Method

### 5. Deploy

- Railway sẽ tự động deploy khi bạn push code lên GitHub
- Hoặc click **Deploy** trong Railway dashboard
- Xem logs trong tab **Deployments** để theo dõi quá trình build

### 6. Kiểm tra sau khi deploy

1. Vào tab **Settings** → **Networking** để xem domain của bạn
2. Test API: `https://your-app.railway.app/swagger`
3. Kiểm tra logs trong tab **Deployments** nếu có lỗi

## Database Setup

Railway không hỗ trợ SQL Server trực tiếp. Bạn cần:

1. **Sử dụng Azure SQL Database** (khuyến nghị):
   - Tạo Azure SQL Database
   - Lấy connection string từ Azure Portal
   - Thêm vào Railway environment variables

2. **Hoặc sử dụng AWS RDS SQL Server**

3. **Hoặc sử dụng Railway PostgreSQL/MySQL** (cần migrate database)

## Troubleshooting

### Lỗi "Error creating build plan with Railpack"
✅ **Đã sửa**: File `railway.json` đã được cập nhật để dùng Docker

### Lỗi về PORT
- Đảm bảo đã set `ASPNETCORE_URLS=http://+:${PORT}` trong environment variables
- Railway tự động inject biến `PORT`, không cần set thủ công

### Lỗi kết nối database
- Kiểm tra connection string đúng format
- Đảm bảo database server cho phép kết nối từ Railway IP
- Kiểm tra firewall rules của database server

### Build fails
- Xem logs trong Railway dashboard → Deployments
- Kiểm tra Dockerfile có đúng syntax không
- Đảm bảo tất cả .csproj files đều có trong repository

## Cập nhật CORS

Sau khi có domain Railway, cập nhật CORS trong `Program.cs` hoặc thêm vào environment variables:

```
AllowedOrigins__0=https://your-frontend-domain.com
```

## Liên kết hữu ích

- [Railway Documentation](https://docs.railway.app/)
- [Railway Discord](https://discord.gg/railway)

