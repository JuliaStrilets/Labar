-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Май 30 2021 г., 13:39
-- Версия сервера: 10.4.19-MariaDB
-- Версия PHP: 7.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `db`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetListOfSuppliedProductByContractNumber` (IN `contract` INT)  BEGIN
SELECT product, amount, price FROM product WHERE product.contract = contract;
END$$

--
-- Функции
--
CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalCostByContractNumber` (`contract` INT) RETURNS DECIMAL(8,2) READS SQL DATA
    DETERMINISTIC
BEGIN
DECLARE totalCost DECIMAL(8,2);
SELECT SUM(amount * price) INTO totalCost FROM product WHERE product.contract = contract;
RETURN totalCost;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `contract`
--

CREATE TABLE `contract` (
  `number` int(11) NOT NULL,
  `agreed` date NOT NULL,
  `supplier` int(11) NOT NULL,
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `contract`
--

INSERT INTO `contract` (`number`, `agreed`, `supplier`, `title`, `note`) VALUES
(1, '0000-00-00', 1, 'test', 'test'),
(2, '2021-03-02', 1, 'Закупка', 'Примечание'),
(3, '2021-03-02', 1, 'Закупка', 'Примечание');

-- --------------------------------------------------------

--
-- Структура таблицы `legal_supplier`
--

CREATE TABLE `legal_supplier` (
  `id` int(11) NOT NULL,
  `tax_number` varchar(20) NOT NULL,
  `vat_number` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `private_supplier`
--

CREATE TABLE `private_supplier` (
  `id` int(11) NOT NULL,
  `last_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `second_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reg_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `product`
--

CREATE TABLE `product` (
  `contract` int(11) NOT NULL,
  `product` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` int(11) NOT NULL,
  `price` decimal(8,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `product`
--

INSERT INTO `product` (`contract`, `product`, `amount`, `price`) VALUES
(1, 'Test 1', 10, '50'),
(2, 'Test 2', 20, '40'),
(3, 'Test 1', 10, '50'),
(4, 'Test 1', 10, '50'),
(5, 'Test 3', 20, '60'),
(6, 'Test 3', 20, '60'),
(7, 'New Product', 50, '100');

--
-- Триггеры `product`
--
DELIMITER $$
CREATE TRIGGER `before_price_insert` BEFORE INSERT ON `product` FOR EACH ROW BEGIN  
IF NEW.price <= 0 THEN
SIGNAL SQLSTATE '45001' set MESSAGE_TEXT = "Price should be positive";
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_product_insert` BEFORE INSERT ON `product` FOR EACH ROW BEGIN
IF NEW.amount <= 0 THEN
SIGNAL SQLSTATE '45001' set MESSAGE_TEXT = "Amount should be positive";
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `supplier`
--

CREATE TABLE `supplier` (
  `id` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `supplier`
--

INSERT INTO `supplier` (`id`, `name`, `address`) VALUES
(1, 'test', 'test');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `contract`
--
ALTER TABLE `contract`
  ADD PRIMARY KEY (`number`);

--
-- Индексы таблицы `legal_supplier`
--
ALTER TABLE `legal_supplier`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `private_supplier`
--
ALTER TABLE `private_supplier`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`contract`);

--
-- Индексы таблицы `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `contract`
--
ALTER TABLE `contract`
  MODIFY `number` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `private_supplier`
--
ALTER TABLE `private_supplier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `product`
--
ALTER TABLE `product`
  MODIFY `contract` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `legal_supplier`
--
ALTER TABLE `legal_supplier`
  ADD CONSTRAINT `legal_supplier_ibfk_1` FOREIGN KEY (`id`) REFERENCES `supplier` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
