-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 04 Nov 2024 pada 03.45
-- Versi server: 10.4.22-MariaDB
-- Versi PHP: 8.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `clinicsstore`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `clinics`
--

CREATE TABLE `clinics` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` int(11) NOT NULL,
  `schedule` varchar(225) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `clinics`
--

INSERT INTO `clinics` (`id`, `name`, `address`, `phone`, `schedule`) VALUES
(1, 'Klinik Sehat Sentosa', 'Jl. Merdeka No. 12, Jakarta', 21, 'Senin-Jumat 08:00-17:00'),
(2, 'Klinik Harapan Bunda', 'Jl. Sudirman No. 45, Bandung', 22, 'Senin-Sabtu 09:00-18:00'),
(3, 'Klinik Pratama Medika', 'Jl. Veteran No. 21, Surabaya', 31, 'Senin-Minggu 07:00-15:00'),
(4, 'Klinik Kasih Ibu', 'Jl. Ahmad Yani No. 78, Yogyakarta', 274, 'Senin-Jumat 08:00-16:00'),
(5, 'Klinik Sejahtera', 'Jl. Pahlawan No. 10, Semarang', 24, 'Senin-Jumat 08:00-17:00, Sabtu 08:00-12:00'),
(7, 'Klinik Pratama Medika Sejahtera', 'JL. Merdeka no 13, Semarang Selatan', 231, 'Senin-Jumat 08:00-17:00'),
(9, 'Klinik Pratama Medika Sejahtera', 'JL. Merdeka no 13, Semarang Selatan', 231, 'Senin-Jumat 08:00-17:00');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `clinics`
--
ALTER TABLE `clinics`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `clinics`
--
ALTER TABLE `clinics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
