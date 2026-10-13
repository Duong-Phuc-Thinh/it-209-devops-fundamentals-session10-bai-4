# Bài 4: Thiết lập Custom Network & Named Volume bằng Docker CLI

## Giới thiệu
Dự án cung cấp kịch bản tự động hóa việc thiết lập cụm ứng dụng gồm Backend Container và PostgreSQL Database Container thông qua Docker CLI.

## Các chức năng chính
- **Custom Bridge Network (`app-net`)**: Giúp các container tự động phân giải địa chỉ IP thông qua hostname/service name (DNS resolution nội bộ).
- **Named Volume (`db-data`)**: Lưu trữ dữ liệu PostgreSQL độc lập với chu kỳ sống của container, đảm bảo Data Persistence.
- **Kịch bản kiểm chứng Data Persistence**: Tự động thêm dữ liệu, xóa cứng container DB (`docker rm -f`), khởi tạo lại container DB mới dùng cùng Volume và xác minh dữ liệu không bị mất.
- **Kiểm tra kết nối Mạng**: Ping kiểm tra khả năng giao tiếp nội bộ giữa Backend Container và DB Container.

## Cấu trúc thư mục
- `commands.sh`: Script thực thi toàn bộ quy trình thiết lập, test persistence và kiểm tra mạng.
- `app.py`: Script Python minh họa ứng dụng Backend kết nối tới DB bằng hostname `db-server`.
- `README.md`: Hướng dẫn và giải thích dự án.

## Hướng dẫn sử dụng

1. Cấp quyền thực thi và chạy script `commands.sh`:
```bash loop
chmod +x commands.sh
./commands.sh
```

2. Kết quả kiểm tra bao gồm:
- Danh sách network chứa `app-net`
- Danh sách volume chứa `db-data`
- Kết quả `docker network inspect app-net`
- Lệnh `ping -c 2 db-server` từ `app-container` thành công
- Dữ liệu mẫu nguyên vẹn sau khi tái tạo container `db-server`
