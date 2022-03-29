-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 16, 2022 at 02:18 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_hotel`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_admin`
--

CREATE TABLE `tbl_admin` (
  `id_admin` int(11) NOT NULL,
  `nama_admin` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `kt_sandi_admin` char(8) NOT NULL,
  `level_login` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_fsilitas_hotel`
--

CREATE TABLE `tbl_fsilitas_hotel` (
  `id_fasilitas` int(11) NOT NULL,
  `nama_layanan` varchar(50) NOT NULL,
  `deksripsi_layanan` varchar(255) NOT NULL,
  `foto_layanan` blob NOT NULL,
  `id_admin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pembayaran`
--

CREATE TABLE `tbl_pembayaran` (
  `kd_bayar` char(6) NOT NULL,
  `kd_reservasi` char(6) NOT NULL,
  `bukti_bayar` varchar(100) NOT NULL,
  `tgl_bayar` date NOT NULL,
  `nama_akun_rekening` varchar(50) NOT NULL,
  `nmr_rekening` char(14) NOT NULL,
  `status_bayar` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_pembayaran`
--

INSERT INTO `tbl_pembayaran` (`kd_bayar`, `kd_reservasi`, `bukti_bayar`, `tgl_bayar`, `nama_akun_rekening`, `nmr_rekening`, `status_bayar`) VALUES
('BYR001', 'RSV001', 'Web capture_10-3-2022_203855_localhost.jpeg', '2022-03-16', 'shandra ', '23410920-283', 1);

--
-- Triggers `tbl_pembayaran`
--
DELIMITER $$
CREATE TRIGGER `update_status_bayar` AFTER INSERT ON `tbl_pembayaran` FOR EACH ROW BEGIN
 UPDATE tbl_reservasi SET status_reservasi= 1
 WHERE kd_reservasi= NEW.kd_reservasi;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_resepsionis`
--

CREATE TABLE `tbl_resepsionis` (
  `id` int(11) NOT NULL,
  `nama_resepsionis` varchar(50) NOT NULL,
  `username_resepsionis` varchar(50) NOT NULL,
  `kt_sandi_resepsionis` char(8) NOT NULL,
  `level_login` int(11) NOT NULL DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_reservasi`
--

CREATE TABLE `tbl_reservasi` (
  `kd_reservasi` char(6) NOT NULL,
  `kd_tamu` char(5) NOT NULL,
  `tgl_check_in` date NOT NULL,
  `tgl_check_out` date NOT NULL,
  `jml_kamar_dipesan` int(11) NOT NULL,
  `jml_orang` int(11) NOT NULL,
  `jml_hari` int(11) NOT NULL,
  `id_kamar` int(11) NOT NULL,
  `tgl_dipesan` date NOT NULL,
  `total_bayar` int(11) NOT NULL,
  `status_reservasi` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_reservasi`
--

INSERT INTO `tbl_reservasi` (`kd_reservasi`, `kd_tamu`, `tgl_check_in`, `tgl_check_out`, `jml_kamar_dipesan`, `jml_orang`, `jml_hari`, `id_kamar`, `tgl_dipesan`, `total_bayar`, `status_reservasi`) VALUES
('RSV001', 'TM00', '2022-03-16', '2022-03-18', 1, 1, 2, 1, '2022-03-16', 200000, 1);

--
-- Triggers `tbl_reservasi`
--
DELIMITER $$
CREATE TRIGGER `stok_kamar` AFTER INSERT ON `tbl_reservasi` FOR EACH ROW BEGIN
 UPDATE tbl_tipe_kamar SET jml_kamar= jml_kamar - NEW.jml_kamar_dipesan 
 WHERE id_kamar= NEW.id_kamar;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_status_rsvp` AFTER DELETE ON `tbl_reservasi` FOR EACH ROW BEGIN
 UPDATE tbl_tipe_kamar SET jml_kamar= jml_kamar + old.jml_kamar_dipesan 
 WHERE id_kamar= old.id_kamar;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_tamu`
--

CREATE TABLE `tbl_tamu` (
  `kd_tamu` char(5) NOT NULL,
  `nama_tamu` varchar(50) NOT NULL,
  `email` varchar(40) NOT NULL,
  `no_telepon` char(13) NOT NULL,
  `alamat` varchar(50) NOT NULL,
  `kata_sandi` char(8) NOT NULL,
  `provinsi` varchar(50) NOT NULL,
  `kota` varchar(50) NOT NULL,
  `kecamatan` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_tamu`
--

INSERT INTO `tbl_tamu` (`kd_tamu`, `nama_tamu`, `email`, `no_telepon`, `alamat`, `kata_sandi`, `provinsi`, `kota`, `kecamatan`) VALUES
('TM00', 'Shandra Wikusdiyanti', 'shandraw946@gmail.com', '081872838293', 'Kihapit', '1234567', '2', '3', '1'),
('TM001', 'shandra wikusdiyanti', 'shandraw946@gmail.com', '081872838293', 'jkk', '1234567', '2', '2', '3'),
('TM002', 'arly', 'arly123@gmail.com', '081872838293', 'kihapit', '1234567', '2', '1', '3');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_tipe_kamar`
--

CREATE TABLE `tbl_tipe_kamar` (
  `id_kamar` int(11) NOT NULL,
  `nm_tipe_kamar` varchar(50) NOT NULL,
  `fasilitas_kamar` varchar(255) NOT NULL,
  `harga_kamar` int(11) NOT NULL,
  `jml_kamar` int(11) NOT NULL,
  `batas_orang` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_tipe_kamar`
--

INSERT INTO `tbl_tipe_kamar` (`id_kamar`, `nm_tipe_kamar`, `fasilitas_kamar`, `harga_kamar`, `jml_kamar`, `batas_orang`) VALUES
(1, 'Deluxe ', 'ndjadjahdjad', 100000, 9, 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_admin`
--
ALTER TABLE `tbl_admin`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indexes for table `tbl_fsilitas_hotel`
--
ALTER TABLE `tbl_fsilitas_hotel`
  ADD PRIMARY KEY (`id_fasilitas`),
  ADD KEY `id_admin` (`id_admin`);

--
-- Indexes for table `tbl_pembayaran`
--
ALTER TABLE `tbl_pembayaran`
  ADD PRIMARY KEY (`kd_bayar`),
  ADD KEY `kd_reservasi` (`kd_reservasi`);

--
-- Indexes for table `tbl_resepsionis`
--
ALTER TABLE `tbl_resepsionis`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_reservasi`
--
ALTER TABLE `tbl_reservasi`
  ADD PRIMARY KEY (`kd_reservasi`),
  ADD KEY `kd_tamu` (`kd_tamu`),
  ADD KEY `id_kamar` (`id_kamar`);

--
-- Indexes for table `tbl_tamu`
--
ALTER TABLE `tbl_tamu`
  ADD PRIMARY KEY (`kd_tamu`);

--
-- Indexes for table `tbl_tipe_kamar`
--
ALTER TABLE `tbl_tipe_kamar`
  ADD PRIMARY KEY (`id_kamar`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_admin`
--
ALTER TABLE `tbl_admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_fsilitas_hotel`
--
ALTER TABLE `tbl_fsilitas_hotel`
  MODIFY `id_fasilitas` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_resepsionis`
--
ALTER TABLE `tbl_resepsionis`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_tipe_kamar`
--
ALTER TABLE `tbl_tipe_kamar`
  MODIFY `id_kamar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_pembayaran`
--
ALTER TABLE `tbl_pembayaran`
  ADD CONSTRAINT `tbl_pembayaran_ibfk_1` FOREIGN KEY (`kd_reservasi`) REFERENCES `tbl_reservasi` (`kd_reservasi`);

--
-- Constraints for table `tbl_reservasi`
--
ALTER TABLE `tbl_reservasi`
  ADD CONSTRAINT `tbl_reservasi_ibfk_1` FOREIGN KEY (`kd_tamu`) REFERENCES `tbl_tamu` (`kd_tamu`),
  ADD CONSTRAINT `tbl_reservasi_ibfk_2` FOREIGN KEY (`id_kamar`) REFERENCES `tbl_tipe_kamar` (`id_kamar`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
