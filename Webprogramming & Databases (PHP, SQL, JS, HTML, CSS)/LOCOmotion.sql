-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 03, 2017 at 12:24 PM
-- Server version: 5.5.54-0+deb8u1
-- PHP Version: 7.1.1-1+0~20170120094658.14+jessie~1.gbp69d416

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `LOCOmotion`
--

-- --------------------------------------------------------

--
-- Table structure for table `account_info`
--

CREATE TABLE `account_info` (
  `id` int(32) UNSIGNED NOT NULL,
  `email` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nog hashen',
  `admin` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `account_info`
--

INSERT INTO `account_info` (`id`, `email`, `password`, `admin`) VALUES
(179, 'Daan.marx@gmail.com', '$2y$10$Q5C.4KXftX2ndyrMolF0Yu1CCzQyuu00DD26T1Q5RPlA3EBjkcCU2', 1),
(180, 'Darth420@galacticempire.com', '$2y$10$Iw2vYYAy.aBe54IgeOlF9.xND1OeRhhNRq/sP9xTvYFEZ/u1/eUqu', 0),
(181, 'Obi1@live.nl', '$2y$10$QVB1TsQKDam22kGlEsC.6OzgNLVlSZoVwVGu2ECus8lUtFkIpB30q', 0),
(182, 'Strontman.poep@kak.be', '$2y$10$fp.uCC.nV0r3q6ESMp39SOMho0kWDdXW2.pdP6zk01PezldxA2n3.', 1),
(183, 'Palpatine@definetlynottheemperor.nl', '$2y$10$zxe1Q8aQXLR1K24rkyLn6.gmAmE1Ns.fj2eNh81ok08RJGqOjuHxq', 1),
(184, 'jade@gmail.com', '$2y$10$1rnDAWYU5jOyqu2DCWVp8.8oXY8i6U4YCGjS/FUiCqyLB4PdEfE/m', 1),
(186, 'tjalke1996@gmail.com', '$2y$10$uS8aEM6PAObDsDbA/wiEput5.zp5Js.4uEoKEz36YwK.ME4uR9ewC', 0),
(187, 'bram.otten@solcon.nl', '$2y$10$kbEOtXqUNM78MnSVKZf7reXN8dFN./Bqcrr4qYyKnicSrgT6C4HIa', 1),
(188, 'bram@loco.com', '$2y$10$ZwMqqatfqRhAQz.lLld2jufc8Mmniuz6/I/g2Y7gwvPMFNxI36tP2', 1),
(190, 'bram.otten@solcosd.dg', '$2y$10$yM4CPhTOmXq0Pj11/FovM.2VJCW.qf.keiRK.7CkW1kHi9U0TnuEG', 1),
(191, 'Ed@Snow.den', '$2y$10$SAnYrLhbLjZb0SgDFdIb2OiTOkt0VtLE3lXIHEv1Iz0ClHdL0LhxG', 1),
(192, 'pragma@wxs.nl', '$2y$10$P3YzNBWrfPzBY6alSCvFWOfoNqXx/09HYw.de/UivCTgcB5yPSBcm', 0),
(194, 'bram.otten@solchuuytf', '$2y$10$NAeIgK6QMv7xVAnp9bh36un2.MzHDxRee1EbhZIjWZr7EOyoQQaKK', 0),
(195, 'bram.otten@solchuuytf.nm', '$2y$10$9XagKKgXdn79RSZNyV4RwevEWueKs6aLnwLErVDsKYX3b8mR6F28G', 0),
(197, 'bram.otten@solcon.nll', '$2y$10$92/pD2uOQAkiPIdkhnVGaeOiuraZZsBK.FgzqTiGDLcMtrEmdyEGu', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(32) UNSIGNED NOT NULL,
  `account_id` int(32) UNSIGNED NOT NULL,
  `item_id` int(32) UNSIGNED NOT NULL,
  `amount` int(32) UNSIGNED NOT NULL DEFAULT '1',
  `date` date NOT NULL DEFAULT '2051-04-20'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `account_id`, `item_id`, `amount`, `date`) VALUES
(180, 192, 48, 1, '2017-02-03'),
(200, 187, 47, 1, '2017-02-03');

-- --------------------------------------------------------

--
-- Table structure for table `item_info`
--

CREATE TABLE `item_info` (
  `id` int(32) UNSIGNED NOT NULL,
  `category` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `legality` int(16) NOT NULL,
  `capacity` int(64) NOT NULL,
  `speedms` int(64) NOT NULL,
  `ageyears` int(64) NOT NULL,
  `description` varchar(2048) COLLATE utf8_unicode_ci NOT NULL,
  `imglink` varchar(256) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `item_info`
--

INSERT INTO `item_info` (`id`, `category`, `name`, `legality`, `capacity`, `speedms`, `ageyears`, `description`, `imglink`) VALUES
(32, 'big', 'Triton 3300/3', 100, 3, 3, 2010, 'Have you ever wondered what the fish look like under the sea? With this personal submarine not the sky, but the center of the earth is the limit! With an endurance of 12 hours, speed over 5,5 km/h and room for not just one but thee passengers, your world will never be the same. ', './uploads/Triton_3300:3.jpg'),
(43, 'big', 'Space Shuttle', 1, 8, 7777, 1979, 'This special piece of scrap-iron has been places you’ll never ever be. But wait, what if you own this retired space shuttle and visit space, just because you can?! With only 238.539.663 kilometer travelled, this shuttle would like to be taken out a couple of times more!  Warning: crew not included', './uploads/Space_Shuttle.jpg'),
(44, 'big', 'Mine Sweeper', 100, 80, 23, 1930, 'A rather large vessel designed to clear away the see of dangerous mines. Different versions of mines require different versions of sweepers. Mostly constructed out of wood in order to not set off the (possible) magnetic sensor which some mines hold.', './uploads/Minesweeper.jpg'),
(45, 'useless', 'BMW i8 Wreck', -100, 1, 0, 2014, '* State: barely usable * Presented as one of the most promising plug-in hybrids back in 2014. With an electrical range of 50km definitely one of the best of its time. Our previous user got a little too excited when driving this monster. Some interior parts are still usable for car builders or basically for anyone.', './uploads/BMW_i8_Wreck.jpg'),
(46, 'unreal', 'Luigi Kart', 100, 1, 14, 1992, 'Living his life in the shadow of his older brother Mario, Luigi strikes back with this monstrous piece of technology. The sports-model has a mind blasting engine packing 150 cc which roughly translates to a power output of 10 horsepower. Competitors have nothing on this beast.', './uploads/Luigi_Kart.jpg'),
(47, 'unreal', 'Mario Kart', 100, 1, 12, 1992, 'The all-time showstopper of Nintendo releases a powerful machine which he will use to destroy his lifelong rivals in the 150cc cup. This kart sets itself aside from the competition by having the best handling. Mario and his team designed a new set of tires to reel in the big shiny cup at the end of the year.', './uploads/Mario_Kart.jpg'),
(48, 'useless', 'BBQ Boat', 99, 12, 2, 2014, 'Used by teenagers who don’t care if their meat is undercooked or if their beer is boiling hot. Basically a floating donut with a barbecue in the centre. Mostly done as a company trip for colleagues who are not very familiar with each other but feel the obligation of spending time together.', './uploads/BBQ_Boat.jpg'),
(49, 'dangerous', 'Dynasphere', 25, 1, 14, 1930, 'A Dynophere is a monowheel vehicle inspired by a sketch made by Leonardo da Vinci. The driver\'s seat and the (gasoline)motor are part of one unit, located at the bottom of the wheel.', './uploads/Dynasphere.jpg'),
(50, 'dangerous', 'Sherman Firefly', -15, 4, 13, 1944, 'The Sherman Firefly is a variant of the US sherman tank, used by the Britisch in WWII. These tanks were stronger than the tanks of the Germans, due to their weight. This tank has an M2 machine gun  and Browning M1919 machine gun on board.', './uploads/Sherman_Firefly.jpg'),
(51, 'useless', 'Wheelbarrow', 100, 3, 9, 1680, 'A Wheelbarrow is a conveyance with one or two wheels. It is used as a garden tool or in the construction, and is used to transport people or resources. This vehicle requires an extra person to push the wheelborrow, otherwise this vehicle won\'t be able to move.', './uploads/Wheelbarrow.jpg'),
(52, 'useless', 'Golden Carriage', 90, 6, 23, 1897, 'For all the people who like to feel like they\'re the queen of Cinderella: this vehicle is perfect. This vehicle is made out of a pumpkin, but at the same time also made of 100% pure gold. It looks like magic, so buy it and see for your self.', './uploads/Golden_Carriage.jpg'),
(53, 'useless', 'Pope Mobile', -33, 2, 37, 1965, 'The Pope mobile is a specially designed vehicle used by the pope during outdoor public appearances. Imagine how awesome it would be to drive this special car yourself. This vehicle is a white Fiat Campagnola, and has an ordinairy backseat with a lot of glass so all your fans can salute you.', './uploads/paus_thumb.jpg'),
(68, 'unreal', 'Batmobile', -100, 1, 127, 1983, 'This super aerodynamic car was built for the famous super hero Batman. The Batmobile is a sleek black car equipped with bat wings. The car is bullet-proof and can withstand a lot of explosions.', './uploads/batmobile_thumb.jpg'),
(70, 'useless', 'Wooden bicycle', 100, 2, 67, 2009, 'Never able to find your bicycle in a full parking? Refursing to ride a bicycle because they are not fashionable nor special? Then you should try this one-of-a-kind wooden version of the century old concept. To extend the lifetime of this marvelous designed vehicle, the cassette, chain and chainrings are made out of aluminium and carbon instead of wood.', './uploads/Wooden_Bicycle.jpg'),
(71, 'dangerous', 'Millenium Falcon', 9001, 12, 2147483647, 2, 'The Millennium Falcon, originally known as YT-1300 492727ZED, was a Corellian YT-1300f light freighter used by the smugglers Han Solo and Chewbacca during the Galactic Civil War. It was previously owned by Lando Calrissian, who lost it to Solo in a game of sabacc.', './uploads/549b80e28ec8d.png'),
(72, 'unreal', 'Toy jet', 99, 1, 7, 2014, 'Definitely not used. We promise.', './uploads/asdasdasd.png'),
(73, 'big', 'Death Star', 100, 12000000, 10000, 872, 'Both as impregnable fortress and as symbol of the Emperor\'s inviolable rule, the deep-space mobile battle station was an achievement on the order of any fashioned by the ancestral species that had unlocked the secret of hyperspace and opened the galaxy to exploration.', './uploads/DeathStar2.jpeg'),
(75, 'dangerous', 'B2 Spirit', 51, 2, 400, 1989, 'Manly.', './uploads/aef3].jpg'),
(80, 'big', 'Star Destroyer', -200, 600000, 975, 7658, 'Destroying stars are we..?', './uploads/imperial_star_destroyer_hr_by_witch_king_42.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `item_store`
--

CREATE TABLE `item_store` (
  `id` int(32) UNSIGNED NOT NULL,
  `price` int(64) UNSIGNED NOT NULL,
  `stock` int(32) UNSIGNED NOT NULL DEFAULT '42'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `item_store`
--

INSERT INTO `item_store` (`id`, `price`, `stock`) VALUES
(32, 3000000, 33),
(33, 12, 41),
(34, 2, 89),
(35, 5, 1),
(36, 100, 22),
(37, 24, 20),
(38, 15, 34),
(39, 0, 342),
(40, 3000, 45),
(41, 3000000, 76),
(42, 499, 22),
(43, 1300000000, 2),
(44, 85000000, 5),
(45, 100, 123),
(46, 7499, 14),
(47, 12500, 4),
(48, 2500, 0),
(49, 140000, 0),
(50, 3141592, 239744),
(51, 45, 11),
(52, 3900000, 1),
(53, 185000, 2),
(54, 2, 23434),
(55, 2, 0),
(56, 2, 2),
(57, 2345, 318),
(58, 41, 41),
(59, 44, 144),
(60, 90, 144),
(61, 23, 23),
(62, 23, 23),
(63, 23, 23),
(64, 23, 23),
(65, 23, 23),
(66, 2, 232),
(67, 2, 2),
(68, 490000, 134234),
(69, 980, 5),
(70, 980, 442),
(71, 4294967295, 0),
(72, 12, 41),
(73, 2147483646, 38),
(74, 2, 234),
(75, 80000000, 37),
(76, 375, 82),
(77, 0, 0),
(78, 0, 0),
(79, 1, 1),
(80, 4294967295, 9),
(81, 78, 7),
(82, 78, 6);

-- --------------------------------------------------------

--
-- Table structure for table `order_info`
--

CREATE TABLE `order_info` (
  `id` int(64) UNSIGNED NOT NULL,
  `account_id` int(32) UNSIGNED NOT NULL,
  `item_id` int(32) UNSIGNED NOT NULL,
  `date` datetime NOT NULL,
  `order_id` int(32) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `order_info`
--

INSERT INTO `order_info` (`id`, `account_id`, `item_id`, `date`, `order_id`) VALUES
(1, 187, 32, '2017-02-03 00:01:11', 1),
(2, 187, 32, '2017-02-03 00:01:11', 1),
(3, 187, 32, '2017-02-03 00:01:11', 1),
(4, 187, 32, '2017-02-03 00:01:11', 1),
(5, 191, 72, '2017-02-03 08:04:04', 2),
(6, 191, 47, '2017-02-03 08:04:30', 3),
(7, 191, 47, '2017-02-03 08:04:30', 3),
(8, 191, 48, '2017-02-03 08:04:30', 3),
(10, 179, 50, '2017-02-03 10:03:53', 4),
(11, 179, 48, '2017-02-03 10:06:01', 5),
(12, 179, 50, '2017-02-03 10:06:01', 5),
(13, 179, 44, '2017-02-03 10:09:45', 6),
(14, 179, 47, '2017-02-03 10:09:45', 6),
(15, 179, 50, '2017-02-03 10:15:06', 7),
(16, 197, 50, '2017-02-03 10:21:20', 8),
(17, 197, 50, '2017-02-03 10:21:20', 8),
(18, 197, 50, '2017-02-03 10:21:20', 8),
(119, 179, 70, '2017-02-03 10:32:51', 10),
(120, 179, 47, '2017-02-03 10:32:51', 10),
(121, 179, 47, '2017-02-03 10:32:51', 10),
(122, 179, 73, '2017-02-03 10:36:44', 11),
(123, 179, 73, '2017-02-03 10:36:44', 11),
(124, 179, 73, '2017-02-03 10:36:44', 11),
(125, 187, 32, '2017-02-03 10:48:17', 12),
(126, 187, 73, '2017-02-03 10:48:17', 12),
(127, 187, 82, '2017-02-03 10:54:27', 13),
(128, 187, 51, '2017-02-03 10:54:27', 13),
(129, 179, 80, '2017-02-03 11:00:13', 14),
(130, 179, 80, '2017-02-03 11:00:13', 14),
(131, 179, 80, '2017-02-03 11:12:49', 15),
(132, 179, 70, '2017-02-03 11:12:49', 15),
(133, 179, 32, '2017-02-03 11:16:52', 16),
(134, 179, 32, '2017-02-03 11:16:52', 16),
(135, 179, 80, '2017-02-03 11:21:09', 17);

-- --------------------------------------------------------

--
-- Table structure for table `order_status`
--

CREATE TABLE `order_status` (
  `id` int(32) UNSIGNED NOT NULL,
  `price` int(255) UNSIGNED NOT NULL,
  `paid` bit(1) NOT NULL DEFAULT b'0',
  `shipped` bit(1) NOT NULL DEFAULT b'0',
  `delivered` bit(1) NOT NULL DEFAULT b'0',
  `cancelled` bit(1) NOT NULL DEFAULT b'0',
  `unknown` bit(1) DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `order_status`
--

INSERT INTO `order_status` (`id`, `price`, `paid`, `shipped`, `delivered`, `cancelled`, `unknown`) VALUES
(1, 12000000, b'1', b'1', b'0', b'0', b'0'),
(2, 12, b'1', b'0', b'0', b'0', b'0'),
(3, 27500, b'1', b'0', b'0', b'0', b'0'),
(4, 3154092, b'1', b'0', b'0', b'0', b'0'),
(5, 3144092, b'1', b'0', b'0', b'0', b'0'),
(6, 85012500, b'1', b'0', b'0', b'0', b'0'),
(7, 3141592, b'1', b'0', b'0', b'0', b'0'),
(8, 9424776, b'1', b'0', b'0', b'0', b'0'),
(9, 314159200, b'1', b'0', b'0', b'0', b'0'),
(10, 25980, b'1', b'0', b'0', b'0', b'0'),
(11, 4294967295, b'1', b'0', b'0', b'0', b'0'),
(12, 2150483646, b'1', b'0', b'0', b'0', b'0'),
(13, 123, b'1', b'0', b'0', b'0', b'0'),
(14, 4294967295, b'1', b'0', b'0', b'0', b'0'),
(15, 4294967295, b'1', b'0', b'0', b'0', b'0'),
(16, 6000000, b'1', b'0', b'0', b'0', b'0'),
(17, 4294967295, b'1', b'0', b'0', b'0', b'0');

-- --------------------------------------------------------

--
-- Table structure for table `shipping_info`
--

CREATE TABLE `shipping_info` (
  `id` int(32) UNSIGNED NOT NULL,
  `firstname` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `inbetweennames` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `lastname` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `city` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `country` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `street` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `number` int(32) UNSIGNED DEFAULT NULL,
  `letter` varchar(32) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `shipping_info`
--

INSERT INTO `shipping_info` (`id`, `firstname`, `inbetweennames`, `lastname`, `city`, `country`, `street`, `number`, `letter`) VALUES
(179, 'Daan', 'Damiaan', 'Marx', 'Amsterdam', 'DPRK', 'Linnaeusstraat', 56, '3'),
(180, 'Darth', 'chiller', 'Vader', 'Death Star', 'France', 'SECTION B98', 1, ''),
(181, 'Obi-Wan', '', 'Kenobi', 'Mos Eisley', 'Belgium', 'Spacers Row', 1, '1'),
(182, 'Dia', '', 'Ray', 'kaksterdam', 'The Netherlands', 'korte schijtse dwars straat', 69, 'p'),
(183, 'Sheev', 'the senate', 'Palpatine', 'Death Star', 'France', 'SECTION B107', 1, ''),
(184, 'jade', '', 'schreuder', 'amsterdam', 'The Netherlands', 'housestreet', 15, 'B'),
(186, 'Judith', 'Anne', 'Laverman', 'Diemen', 'The Netherlands', 'tjalk', 110, ''),
(187, 'Marb', '', 'Netto', 'Amsterdam', 'DPRK', 'Science Park', 904, ''),
(191, 'Edward', '', 'Snowden', 'Moscow', 'DPRK', 'Airport', 1, ''),
(197, 'B', '', 'O', 'A', 'The Netherlands', 'B', 4, '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account_info`
--
ALTER TABLE `account_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `id` (`id`),
  ADD KEY `id_2` (`id`,`email`,`password`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `item_info`
--
ALTER TABLE `item_info`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cats` (`category`),
  ADD KEY `id` (`id`,`category`,`imglink`(255));

--
-- Indexes for table `item_store`
--
ALTER TABLE `item_store`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`,`price`,`stock`);

--
-- Indexes for table `order_info`
--
ALTER TABLE `order_info`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`,`item_id`,`order_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_status`
--
ALTER TABLE `order_status`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `price` (`price`),
  ADD KEY `id_2` (`id`);

--
-- Indexes for table `shipping_info`
--
ALTER TABLE `shipping_info`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`,`lastname`(255));

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account_info`
--
ALTER TABLE `account_info`
  MODIFY `id` int(32) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=198;
--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(32) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;
--
-- AUTO_INCREMENT for table `item_info`
--
ALTER TABLE `item_info`
  MODIFY `id` int(32) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;
--
-- AUTO_INCREMENT for table `item_store`
--
ALTER TABLE `item_store`
  MODIFY `id` int(32) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;
--
-- AUTO_INCREMENT for table `order_info`
--
ALTER TABLE `order_info`
  MODIFY `id` int(64) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=136;
--
-- AUTO_INCREMENT for table `order_status`
--
ALTER TABLE `order_status`
  MODIFY `id` int(32) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `shipping_info`
--
ALTER TABLE `shipping_info`
  MODIFY `id` int(32) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=198;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account_info` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `item_store` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `item_info`
--
ALTER TABLE `item_info`
  ADD CONSTRAINT `item_info_ibfk_1` FOREIGN KEY (`id`) REFERENCES `item_store` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shipping_info`
--
ALTER TABLE `shipping_info`
  ADD CONSTRAINT `shipping_info_ibfk_1` FOREIGN KEY (`id`) REFERENCES `account_info` (`id`) ON DELETE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`bram`@`localhost` EVENT `delete_old_cart` ON SCHEDULE EVERY 1 DAY STARTS '2017-01-31 23:59:59' ON COMPLETION NOT PRESERVE ENABLE DO DELETE
FROM
  cart
WHERE
  DATEDIFF(DATE, CURDATE()) < -10$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
