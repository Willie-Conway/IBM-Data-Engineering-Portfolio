CREATE TABLE `Sales` (
  `SalesID` varchar(10) DEFAULT NULL,
  `EmpID` varchar(10) DEFAULT NULL,
  `Segment` varchar(25) DEFAULT NULL,
  `Product` varchar(10) DEFAULT NULL,
  `Units_Sold` double DEFAULT NULL,
  `Sale_Price` double DEFAULT NULL,
  `Sales` double DEFAULT NULL,
  `COGS` double DEFAULT NULL,
  `Profit` double DEFAULT NULL,
  `Date` varchar(10) DEFAULT NULL
);

INSERT INTO `Sales` (`SalesID`, `EmpID`, `Segment`, `Product`, `Units_Sold`, `Sale_Price`, `Sales`, `COGS`, `Profit`, `Date`) VALUES
('S2528', 'E04732', 'Government', 'Product2', 252, 20, 5040, 2920, 2120, '04/02/2021'),
('S2534', 'E04732', 'Midmarket', 'Product4', 209, 29, 6061, 5490, 571, '07/24/2021'),
('S2530', 'E03496', 'Midmarket', 'Product2', 211, 41, 8651, 7554, 1097, '03/12/2021'),
('S2525', 'E02166', 'Channel Partners', 'Product1', 2133, 7, 14931, 10730, 4201, '09/29/2022'),
('S2512', 'E02166', 'Midmarket', 'Product1', 1200, 20, 24000, 16185, 7815, '02/01/2022'),
('S2513', 'E04732', 'Channel Partners', 'Product1', 1001, 30, 30030, 13210, 16820, '01/15/2022'),
('S2519', 'E00530', 'Channel Partners', 'Product1', 2513, 12, 30156, 7554, 22602, '06/21/2022'),
('S2514', 'E00530', 'Government', 'Product3', 2109, 15, 31635, 21780, 9855, '04/12/2022'),
('S2520', 'E03496', 'Government', 'Product3', 1677, 20, 33540, 18990, 14550, '04/03/2022'),
('S2516', 'E01525', 'Government', 'Product2', 2312, 15, 34680, 24700, 9980, '05/30/2022'),
('S2526', 'E03496', 'Government', 'Product3', 321, 143, 45903, 41400, 4503, '08/31/2021'),
('S2522', 'E04732', 'Midmarket', 'Product1', 267, 200, 53400, 24700, 28700, '08/12/2022'),
('S2533', 'E00530', 'Government', 'Product1', 832, 87, 72384, 20415, 51969, '01/07/2021'),
('S2529', 'E04732', 'Government', 'Product2', 6356, 15, 95340, 32740, 62600, '03/12/2021'),
('S2524', 'E02166', 'Midmarket', 'Product1', 982, 298, 292636, 239500, 53136, '07/02/2022'),
('S2535', 'E04732', 'Channel Partners', 'Product3', 988, 305, 301340, 197000, 104340, '11/19/2021'),
('S2532', 'E02166', 'Midmarket', 'Product4', 327, 1412, 461724, 317101, 144623, '12/25/2022'),
('S2527', 'E00530', 'Channel Partners', 'Product1', 764, 614, 469096, 231150, 237946, '05/25/2021'),
('S2523', 'E00530', 'Government', 'Product3', 2543, 212, 539116, 319860, 219256, '12/23/2021'),
('S2517', 'E01525', 'Government', 'Product4', 1567, 352, 551584, 393380, 158204, '05/16/2021'),
('S2531', 'E03496', 'Midmarket', 'Product2', 2317, 250, 579250, 361560, 217690, '06/20/2022'),
('S2515', 'E02166', 'Channel Partners', 'Product1', 882, 1115, 983430, 600880, 382550, '08/01/2021'),
('S2521', 'E04732', 'Channel Partners', 'Product3', 1245, 812, 1010940, 52635, 958305, '10/15/2021'),
('S2518', 'E01525', 'Midmarket', 'Product1', 933, 1215, 1133595, 9210, 1124385, '07/30/2021');
COMMIT;