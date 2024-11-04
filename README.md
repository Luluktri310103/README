# Web Service REST untuk Manajemen Clinics
## Nama : Luluk Tri Utami
## Nim : 21.01.55.0006

## Tujuan
Membuat dan menguji web service REST untuk manajemen clinics menggunakan PHP dan MySQL.

## Alat yang Dibutuhkan
1. XAMPP (atau server web lain dengan PHP dan MySQL)
2. Text editor (misalnya Visual Studio Code, Notepad++, dll)
3. Postman

## Langkah-langkah Praktikum

### 1. Persiapan Lingkungan
1. Instal XAMPP jika belum ada.
2. Buat folder baru bernama `rest_clinics` di dalam direktori `htdocs` XAMPP Anda.

### 2. Membuat Database
1. Buka phpMyAdmin (http://localhost/phpmyadmin)
2. Buat database baru bernama `clinicsstore`
3. Pilih database `clinicsstore`, lalu buka tab SQL
4. Jalankan query SQL berikut untuk membuat tabel dan menambahkan data sampel:

```sql
CREATE TABLE clinics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone INT NOT NULL,
    schedule VARCHAR (225) NOT NULL

);

INSERT INTO clinics (name, address, phone, schedule) VALUES
('Klinik Sehat Sentosa', 'Jl. Merdeka No. 12, Jakarta', '021-1234567', 'Senin-Jumat 08:00-17:00'),
('Klinik Harapan Bunda', 'Jl. Sudirman No. 45, Bandung', '022-7654321', 'Senin-Sabtu 09:00-18:00'),
('Klinik Pratama Medika', 'Jl. Veteran No. 21, Surabaya', '031-9876543', 'Senin-Minggu 07:00-15:00'),
('Klinik Kasih Ibu', 'Jl. Ahmad Yani No. 78, Yogyakarta', '0274-567890', 'Senin-Jumat 08:00-16:00'),
('Klinik Sejahtera', 'Jl. Pahlawan No. 10, Semarang', '024-2345678', 'Senin-Jumat 08:00-17:00, Sabtu 08:00-12:00');

```

### 3. Membuat File PHP untuk Web Service
1. Buka text editor Anda.
2. Buat file baru dan simpan sebagai `clinics_api.php` di dalam folder `rest_clinics`.
3. Salin dan tempel kode berikut ke dalam `clinics_api.php`:
```
<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$method = $_SERVER['REQUEST_METHOD'];
$request = [];

if (isset($_SERVER['PATH_INFO'])) {
    $request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
}

function getConnection() {
    $host = 'localhost';
    $db   = 'clinicsstore';
    $user = 'root';
    $pass = ''; // Ganti dengan password MySQL Anda jika ada
    $charset = 'utf8mb4';

    $dsn = "mysql:host=$host;dbname=$db;charset=$charset";
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ];
    try {
        return new PDO($dsn, $user, $pass, $options);
    } catch (\PDOException $e) {
        throw new \PDOException($e->getMessage(), (int)$e->getCode());
    }
}

function response($status, $data = NULL) {
    header("HTTP/1.1 " . $status);
    if ($data) {
        echo json_encode($data);
    }
    exit();
}

$db = getConnection();

switch ($method) {
    case 'GET':
        if (!empty($request) && isset($request[0])) {
            $id = $request[0];
            $stmt = $db->prepare("SELECT * FROM clinics WHERE id = ?");
            $stmt->execute([$id]);
            $clinics = $stmt->fetch();
            if ($clinics) {
                response(200, $clinics);
            } else {
                response(404, ["message" => "clinics not found"]);
            }
        } else {
            $stmt = $db->query("SELECT * FROM clinics");
            $clinics = $stmt->fetchAll();
            response(200, $clinics);
        }
        break;
    
    case 'POST':
        $data = json_decode(file_get_contents("php://input"));
        if (!isset($data->name) || !isset($data->address) || !isset($data->phone) || !isset($data->schedule)) {
            response(400, ["message" => "Missing required fields"]);
        }
        $sql = "INSERT INTO clinics (name, address, phone, schedule) VALUES (?, ?, ?, ?)";
        $stmt = $db->prepare($sql);
        if ($stmt->execute([$data->name, $data->address, $data->phone, $data->schedule ])) {
            response(201, ["message" => "clinics created", "id" => $db->lastInsertId()]);
        } else {
            response(500, ["message" => "Failed to create clinics"]);
        }
        break;
    
    case 'PUT':
        if (empty($request) || !isset($request[0])) {
            response(400, ["message" => "clinics ID is required"]);
        }
        $id = $request[0];
        $data = json_decode(file_get_contents("php://input"));
        if (!isset($data->name) || !isset($data->address) || !isset($data->phone) || !isset($data->schedule)) {
            response(400, ["message" => "Missing required fields"]);
        }
        $sql = "UPDATE clinics SET name = ?, address = ?, phone = ?, schedule = ? WHERE id = ?";
        $stmt = $db->prepare($sql);
        if ($stmt->execute([$data->name, $data->address, $data->phone, $data->schedule, $id])) {
            response(200, ["message" => "clinics updated"]);
        } else {
            response(500, ["message" => "Failed to update clinics"]);
        }
        break;
    
    case 'DELETE':
        if (empty($request) || !isset($request[0])) {
            response(400, ["message" => "clinics ID is required"]);
        }
        $id = $request[0];
        $sql = "DELETE FROM clinics WHERE id = ?";
        $stmt = $db->prepare($sql);
        if ($stmt->execute([$id])) {
            response(200, ["message" => "clinics deleted"]);
        } else {
            response(500, ["message" => "Failed to delete clinics"]);
        }
        break;
    
    default:
        response(405, ["message" => "Method not allowed"]);
        break;
}
?>
```

### 4. Pengujian dengan Postman
1. Buka Postman
2. Buat request baru untuk setiap operasi berikut:

#### a. GET All Clinics
- Method: GET
- URL: `http://localhost/rest_clinics/clinics_api.php`
- Klik "Send"

#### b. GET Specific 
- Method: GET
- URL: `http://localhost/rest_clinics/clinics_api.php/1` (untuk buku dengan ID 1)
- Klik "Send"

#### c. POST New Clinics
- Method: POST
- URL: `http://localhost/rest_clinics/clinics_api.php`
- Headers: 
  - Key: Content-Type
  - Value: application/json
- Body:
  - Pilih "raw" dan "JSON"
  - Masukkan:
    ```json
   {
    "name": "Klinik Pratama Medika",
    "address": "JL. Merdeka no 13, Semarang",
    "phone" : "231",
    "schedule": "Senin-Jumat 08:00-17:00"
}
    ```
- Klik "Send"

#### d. PUT (Update) Clinics
- Method: PUT
- URL: `http://localhost/rest_clinics/clinics_api.php/6` (asumsikan ID buku baru adalah 6)
- Headers: 
  - Key: Content-Type
  - Value: application/json
- Body:
  - Pilih "raw" dan "JSON"
  - Masukkan:
    ```json
    {
    "name": "Klinik Pratama Medika Sejahtera",
    "address": "JL. Merdeka no 13, Semarang",
    "phone" : "231",
    "schedule": "Senin-Jumat 08:00-17:00"
}
    ```
- Klik "Send"

#### e. DELETE Clinics
- Method: DELETE
- URL: `http://localhost/rest_clinics/clinics_api.php/6` (untuk menghapus buku dengan ID 6)
- Klik "Send"

### Kesimpulan
Dalam praktikum ini, Anda telah berhasil membuat web service REST untuk manajemen buku menggunakan PHP dan MySQL. Anda juga telah belajar cara menguji API menggunakan Postman. Praktik ini memberikan dasar yang kuat untuk pengembangan API RESTful lebih lanjut.

### HASIL

#### HASIL DATABASE
![Screenshot (247)](https://github.com/user-attachments/assets/f9db409d-e7b0-41c0-a3e9-44718c2db3b7)

#### HASIL TABEL DATABASE CLINICS 
![Screenshot (248)](https://github.com/user-attachments/assets/a1490b2b-7bc0-4970-bf36-e96acd3ee605)

#### HASIL DATABASE TABEL CLINICS
![Screenshot (249)](https://github.com/user-attachments/assets/7958febf-011d-4b0c-ba67-6ed1816a124d)

#### HASIL GET CLINICS
![Screenshot (250)](https://github.com/user-attachments/assets/f4d13949-9cc7-49da-bb9c-f8c8cc94f7fd)

#### HASIL GET CLINICS 1
![Screenshot (251)](https://github.com/user-attachments/assets/ca678374-6377-454a-955f-f0b50bf09183)

#### HASIL PUT CLINICS
![Screenshot (258)](https://github.com/user-attachments/assets/b7d61957-2d3f-4f1e-89ba-50e852a1985d)

#### HASIL POST CILINICS
![Screenshot (255)](https://github.com/user-attachments/assets/9018dcb8-d1c5-4a08-88cd-7640cb406aaa).

#### HASIL DELETE CLINICS
![Screenshot (254)](https://github.com/user-attachments/assets/f5d82c96-d847-45e6-80d1-6d2532d5c3b8)
