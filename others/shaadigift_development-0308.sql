/*
MySQL Data Transfer
Source Host: localhost
Source Database: shaadigiftlist_development
Target Host: localhost
Target Database: shaadigiftlist_development
Date: 03/08/2007 18:50:05
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for addresses
-- ----------------------------
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL auto_increment,
  `line_one` varchar(255) default NULL,
  `line_two` varchar(255) default NULL,
  `line_three` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `county` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `post_code` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for addresses_customers
-- ----------------------------
CREATE TABLE `addresses_customers` (
  `address_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  KEY `fk_address_customer_addresses` (`address_id`),
  KEY `fk_address_customer_customers` (`customer_id`),
  CONSTRAINT `fk_address_customer_addresses` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`),
  CONSTRAINT `fk_address_customer_customers` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for adminusers
-- ----------------------------
CREATE TABLE `adminusers` (
  `id` int(11) NOT NULL auto_increment,
  `user_name` varchar(255) default NULL,
  `hashed_password` varchar(255) default NULL,
  `salt` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for contact_us
-- ----------------------------
CREATE TABLE `contact_us` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `contact_number` varchar(255) default NULL,
  `current_member` int(11) default NULL,
  `text` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for customers
-- ----------------------------
CREATE TABLE `customers` (
  `id` int(11) NOT NULL auto_increment,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `date_of_birth` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `contact_number` varchar(255) default NULL,
  `evening_number` varchar(255) default NULL,
  `mobile_number` varchar(255) default NULL,
  `user_name` varchar(255) default NULL,
  `hashed_password` varchar(255) default NULL,
  `salt` varchar(255) default NULL,
  `customertype_id` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for customers_orders
-- ----------------------------
CREATE TABLE `customers_orders` (
  `customer_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  KEY `fk_customer_order_customers` (`customer_id`),
  KEY `fk_customer_order_orders` (`order_id`),
  CONSTRAINT `fk_customer_order_customers` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `fk_customer_order_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for customertypes
-- ----------------------------
CREATE TABLE `customertypes` (
  `id` int(11) NOT NULL auto_increment,
  `type_name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for emailregisters
-- ----------------------------
CREATE TABLE `emailregisters` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for giftmessages
-- ----------------------------
CREATE TABLE `giftmessages` (
  `id` int(11) NOT NULL auto_increment,
  `payment_id` int(11) NOT NULL,
  `message` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for guestcart_items
-- ----------------------------
CREATE TABLE `guestcart_items` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` int(11) default NULL,
  `guestcart_id` int(11) default NULL,
  `price` float default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for guestcartitems
-- ----------------------------
CREATE TABLE `guestcartitems` (
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for guestcarts
-- ----------------------------
CREATE TABLE `guestcarts` (
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for line_items
-- ----------------------------
CREATE TABLE `line_items` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) default NULL,
  `payment_id` int(11) default NULL,
  `date_added` datetime default NULL,
  `position` int(11) default NULL,
  `bought` bit(1) default '\0',
  `visible` varchar(255) default NULL,
  `cost_price` decimal(6,2) default '0.00',
  `customer_ip` varchar(255) default NULL,
  `date_purchased` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for orderconditions
-- ----------------------------
CREATE TABLE `orderconditions` (
  `id` int(11) NOT NULL auto_increment,
  `status_name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for orders
-- ----------------------------
CREATE TABLE `orders` (
  `id` int(11) NOT NULL auto_increment,
  `customer_number` varchar(255) default NULL,
  `shipping_address_id` int(11) default NULL,
  `ordercondition_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for paymentmethods
-- ----------------------------
CREATE TABLE `paymentmethods` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for payments
-- ----------------------------
CREATE TABLE `payments` (
  `id` int(11) NOT NULL auto_increment,
  `paymentmethod_id` int(11) NOT NULL,
  `card_expiration_month` int(11) default NULL,
  `card_expiration_year` int(11) default NULL,
  `purchaser_first_name` varchar(255) default NULL,
  `purchaser_last_name` varchar(255) default NULL,
  `purchaser_email` varchar(255) default NULL,
  `purchaser_telephone` varchar(255) default NULL,
  `customer_ip` varchar(255) default NULL,
  `date_purchased` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_payment_paymentmethods` (`paymentmethod_id`),
  CONSTRAINT `fk_payment_paymentmethods` FOREIGN KEY (`paymentmethod_id`) REFERENCES `paymentmethods` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for products
-- ----------------------------
CREATE TABLE `products` (
  `id` int(11) NOT NULL auto_increment,
  `image_url` varchar(255) default NULL,
  `category` varchar(255) default NULL,
  `reference` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `description` text,
  `unit_cost` decimal(6,2) default '0.00',
  `markup_percentage` decimal(6,2) default '0.00',
  `markup_amount` decimal(6,2) default '0.00',
  `price` decimal(6,2) default '0.00',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for products_tags
-- ----------------------------
CREATE TABLE `products_tags` (
  `product_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  KEY `fk_product_tag_products` (`product_id`),
  KEY `fk_product_tag_tags` (`tag_id`),
  CONSTRAINT `fk_product_tag_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_product_tag_tags` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for save_emails
-- ----------------------------
CREATE TABLE `save_emails` (
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for schema_info
-- ----------------------------
CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for security_questions
-- ----------------------------
CREATE TABLE `security_questions` (
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for tags
-- ----------------------------
CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `tag_name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for wedding_details
-- ----------------------------
CREATE TABLE `wedding_details` (
  `id` int(11) NOT NULL auto_increment,
  `customer_id` int(11) default NULL,
  `wedding_date` datetime default NULL,
  `image_url` varchar(255) default 'images/photos/no_image.gif',
  `venue` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `adminusers` VALUES ('1', 'Jaharul', '4b7a44d291d289504ab732d668f800f13efd3a4d', '504386400.299514464016635', '2007-08-03 17:59:40', '2007-08-03 17:59:40');
INSERT INTO `adminusers` VALUES ('2', 'pallay', 'c273d604f3ed36f987cc71a3eaa020758fda2e7e', '504147300.0163998420602727', '2007-08-03 17:59:40', '2007-08-03 17:59:40');
INSERT INTO `customertypes` VALUES ('1', 'bride', '2007-08-03 17:59:40', '2007-08-03 17:59:40');
INSERT INTO `customertypes` VALUES ('2', 'groom', '2007-08-03 17:59:40', '2007-08-03 17:59:40');
INSERT INTO `customertypes` VALUES ('3', 'guest', '2007-08-03 17:59:40', '2007-08-03 17:59:40');
INSERT INTO `orderconditions` VALUES ('1', 'customer deleted', '2007-08-03 17:59:41', '2007-08-03 17:59:41');
INSERT INTO `orderconditions` VALUES ('2', 'jaharul deleted', '2007-08-03 17:59:41', '2007-08-03 17:59:41');
INSERT INTO `orderconditions` VALUES ('3', 'open', '2007-08-03 17:59:41', '2007-08-03 17:59:41');
INSERT INTO `orderconditions` VALUES ('4', 'awaiting payment', '2007-08-03 17:59:41', '2007-08-03 17:59:41');
INSERT INTO `orderconditions` VALUES ('5', 'payment received', '2007-08-03 17:59:41', '2007-08-03 17:59:41');
INSERT INTO `orderconditions` VALUES ('6', 'payment failed', '2007-08-03 17:59:41', '2007-08-03 17:59:41');
INSERT INTO `orderconditions` VALUES ('7', 'awaiting delivery', '2007-08-03 17:59:41', '2007-08-03 17:59:41');
INSERT INTO `orderconditions` VALUES ('8', 'completed', '2007-08-03 17:59:41', '2007-08-03 17:59:41');
INSERT INTO `orderconditions` VALUES ('9', 'archived', '2007-08-03 17:59:41', '2007-08-03 17:59:41');
INSERT INTO `paymentmethods` VALUES ('1', 'paypal', '2007-08-03 17:59:41', '2007-08-03 17:59:41');
INSERT INTO `products` VALUES ('1', '/images/products/no_image.gif', 'Electronics', '???', 'Russell Hobbs Montana Gift Pack', 'Kettle:\n3kW rapid boil concealed element for easy cleaning and to reduce limescale build up.\n1.7 litre capacity.\nAnti-scale washable filter.\nWater gauge.\nSoft touch handle.\nIlluminated power indicator.\nMulti-directional 360 degree base with cord storage. \n2 slice toaster:\nWide/long slots for bigger cuts of bread.\nHigh-lift facility.\n6 position variable browning control. \nFrozen bread and cancel functions.\nRemovable crumb tray.\nPolished stainless steel finish. ', '49.99', '20.00', '10.00', '59.99', null, null);
INSERT INTO `products` VALUES ('2', '/images/products/no_image.gif', 'Electronics', '???', 'Breville Stainless Steel and Cream Gift Pack', '3kW.\n1.7 litre capacity. \nDry boil protection. \nSafety cut out. \nRemovable, washable limescale filter. \nWater window.\nSpout fill. \nAutomatic switch off. \nNeon power indicator. \n360 degree base. \nNon slip feet. \nCord storage. \n2 Slice Toaster:\nVariable width. \nSelf centring. \nVariable browning control. \nCancel/frozen/reheat facility. \nMid cycle cancel. \nRemovable crumb tray. \nNon slip feet. \nCord storage. ', '49.99', '20.00', '10.00', '59.99', null, null);
INSERT INTO `products` VALUES ('3', '/images/products/no_image.gif', 'Electronics', '???', 'Breville Silver Triple Pack', '3kW fastboil. \n1.7 litre capacity jug kettle. \nToaster: \n2 slice cool wall toaster. \nVariable width toasting slots. \nHigh lift. \nMid cycle cancel facility. \nSandwich toaster: \n2 slice sandwich toaster with non-stick plates.\nPower on and ready to cook indicators.\nStylish stainless steel and silver finish to all products. ', '49.99', '25.00', '12.50', '62.49', null, null);
INSERT INTO `products` VALUES ('4', '/images/products/DelonghiCrema4SliceToaster.jpg', 'Electronics', '???', 'DeLonghi Crema 4 Slice Toaster', 'Cream. \nRetro style. \nCan operate 2 slots independently. \nVariable width. \nSelf centring. \nVariable browning control. \nHi-rise facility. \nCancel/frozen/reheat/stop facility. \n2 slide out crumb trays.\nNon slip feet.\nCord storage.\n', '39.99', '5.00', '2.00', '41.99', null, null);
INSERT INTO `products` VALUES ('5', '/images/products/RussellHobbsClassic4SliceToaster.jpg', 'Electronics', '???', ' Russell Hobbs Classic 4 Slice Toaster', 'Independent 2 slice operation. \nVariable width. \nSelf centring. \nCoolwall. \nVariable browning control. \nHi-lift. \nCancel/frozen/reheat facility. \n2 removable crumb trays. \nNon slip feet.\n', '34.99', '10.00', '3.50', '38.49', null, null);
INSERT INTO `products` VALUES ('6', '/images/products/Deco2SliceBrushedStainlessSteelToaster.jpg', 'Electronics', '???', ' Deco 2 Slice Brushed Stainless Steel Toaster', 'Polished stainless steel finish.\nEnergy saving independent 2 slice operation.\nWide/long slots for bigger cuts of bread.\n6 position variable browning control.\nHigh lift facility.\nFrozen bread and cancel functions. \nPolished stainless steel finish.\nRemovable crumb tray. \n', '34.94', '10.00', '3.49', '38.43', null, null);
INSERT INTO `products` VALUES ('7', '/images/products/BrevilleStainlessSteel4SliceToaster.jpg', 'Electronics', '???', ' Breville Stainless Steel 4 Slice Toaster', 'Independent 2 slice operation. \nDigital display and LED indicator lights to indicate where the toasting cycle is up to. \nVariable width. \nSelf centring. \nCoolwall. \nElectronic variable browning control. \nHigh lift. \nCancel/frozen/reheat facility. \nMid cycle cancel. \nRemovable crumb tray.\n', '29.99', '10.00', '3.00', '32.99', null, null);
INSERT INTO `products` VALUES ('8', '/images/products/RussellHobbsRetro 2SliceStainlessSteelToaster.jpg', 'Electronics', '???', 'Russell Hobbs Retro 2 Slice Stainless Steel Toaster', 'Variable width. \nSelf centring. \nVariable browning control. \nHi lift. \nCancel/frozen/reheat facility. \nMid cycle cancel. \nRemovable crumb tray. \nNon slip feet. \nCord storage. \n', '29.99', '10.00', '3.00', '32.99', null, null);
INSERT INTO `products` VALUES ('9', '/images/products/TefalAvantiBlackandSilver4SliceToaster.jpg', 'Electronics', '???', ' Tefal Avanti Black and Silver 4 Slice Toaster', 'Front angled toaster for safe viewing whilst toasting. \nIndependent 2 slice operation. \nExtra deep variable width bread slots. \nSelf centring. \nCoolwall. \nVariable browning control. \nHi-lift. \nCancel/frozen/reheat facility. \nMid cycle cancel. \nRemovable crumb tray. \nNon slip feet. \nCord storage. \n', '29.99', '10.00', '3.00', '32.99', null, null);
INSERT INTO `products` VALUES ('10', '/images/products/MorphyRichardsGraphiteComplements4SliceToaster.jpg', 'Electronics', '???', ' Morphy Richards Graphite Complements 4 Slice Toaster', 'Independent 2 slice operation. \nElectronic variable browning control. \nCool touch. \nCountdown feature. \nHi lift. \nCancel/frozen/reheat facility. \nMid cycle cancel. \nRemovable crumb tray. \nCord storage.\n', '29.99', '10.00', '3.00', '32.99', null, null);
INSERT INTO `products` VALUES ('11', '/images/products/BrevilleCafeStyleSandwichPressandMelt.jpg', 'Electronics', '???', ' Breville Cafe Style Sandwich Press and Melt', 'Makes 2 rounds of sandwiches. \nCafe style toasted panini and ciabatta snacks in minutes. \n2000 watts for rapid heat up. \nNon-stick flat cooking plates. \nUnique floating hinge top plate. \nAdjustable top plate - suitable for melting cheese. \nPower on/ready lights. \nUpright storage facilities\n', '29.97', '5.00', '1.50', '31.47', null, null);
INSERT INTO `products` VALUES ('12', '/images/products/MorphyRichards44065AccentsPowder Pink2SliceToaster.jpg', 'Electronics', '???', ' Morphy Richards 44065 Accents Powder Pink 2 Slice Toaster', 'Variable bread width. \nDeep toasting chamber for large items. \nHi-lift. \nCancel/frozen/reheat facility. \nRemovable crumb tray. \nNon slip feet. \nCord storage. \n', '29.95', '5.00', '1.50', '31.45', null, null);
INSERT INTO `products` VALUES ('13', '/images/products/MorphyRichardsAccentsJetBlack2SliceToaster.jpg', 'Electronics', '???', ' Morphy Richards Accents Jet Black 2 Slice Toaster', 'Variable bread width. \nDeep toasting chamber for large items. \nVariable browning control. \nHi-lift facility for removing small items. \nCancel/frozen/reheat facility. \nRemovable washable crumb tray. \nNon slip feet. \nCord storage.\n', '29.79', '5.00', '1.49', '31.28', null, null);
INSERT INTO `products` VALUES ('14', '/images/products/MorphyRichards447093in1SnackingMachine.jpg', 'Electronics', '???', ' Morphy Richards 44709 3 in 1 Snacking Machine', '740 watts.\n2 deep fill sandwich plates. \n2 health grill plates for cooking meat, vegetables and fish. \nNon stick, easy clean removable plates. \nMakes 2 rounds of filled toasted sandwiches. \nCarry handle incorporating locking clasp. \nSuitable for upright storage\n\n', '24.99', '5.00', '1.25', '26.24', null, null);
INSERT INTO `products` VALUES ('15', '/images/products/BrevilleSilverStyle4SliceIlluminatedToaster.jpg', 'Electronics', '???', ' Breville Silver Style 4 Slice Illuminated Toaster', 'Illuminating toasting status indicator lights. \nVariable width. \nSelf centring. \nCoolwall. \nVariable browning control. \nHi lift. \nCancel/frozen/reheat facility. \nMid cycle cancel. \nRemovable crumb tray. \nNon slip feet. \nCord storage. \n', '27.99', '5.00', '1.40', '29.39', null, null);
INSERT INTO `products` VALUES ('16', '/images/products/CookworksSignaturePaniniPress.jpg', 'Electronics', '???', ' Cookworks Signature Panini Press', 'Makes caf? style toasted ciabatta and panini bread sandwiches.  \nHorizontal floating hinge for variable thickness sandwiches.  \nNon-stick coating.  \nPower on and ready indicator.  \nStands up for easy storage. \nCord storage. \n', '26.99', '5.00', '1.35', '28.34', null, null);
INSERT INTO `products` VALUES ('17', '/images/products/Disney2SliceToaster.jpg', 'Electronics', '???', ' Disney 2 Slice Toaster', 'Toasts Mickey Mouse\'s face onto each slice. \nPlays the Mickey Mouse March music when toast is ready. \nVariable browning control. \nCancel function. \nRemovable crumb tray. \nNon slip feet. \nIncludes quick start guide\n', '24.99', '5.00', '1.25', '26.24', null, null);
INSERT INTO `products` VALUES ('18', '/images/products/no_image.gif', 'Electronics', '???', ' Prestige Insignia 2 Slice Brushed Stainless Steel Toaster', '2 deep variable width toasting slots for thick and thin bread. \nAuto pop up. \n5 position electronic variable browning control with LED indicator. \nHigh-lift facility for easy removal small items. \nDefrost and mid cycle cancel button with illumination. \nEasy removable crumb tray. \nNon-slip feet. \n', '24.99', '5.00', '1.25', '26.24', null, null);
INSERT INTO `products` VALUES ('19', '/images/products/RussellHobbsRetro4SliceStainlessSteelToaster.jpg', 'Electronics', '???', ' Russell Hobbs Retro 4 Slice Stainless Steel Toaster', 'Independent 2 slice operation. \nVariable width. \nSelf centring. \nVariable browning control. \nHi lift. \nCancel/frozen/reheat facility. \nMid cycle cancel. \nRemovable crumb tray. \nNon slip feet. \nCord storage\n', '24.99', '5.00', '1.25', '26.24', null, null);
INSERT INTO `products` VALUES ('20', '/images/products/Breville4SliceSilverSandwichToaster.jpg', 'Electronics', '???', 'Breville 4 Slice Silver Sandwich Toaster', '4 deep fill plates make a fulfilling snack.\nCuts and seals to reduce leakage.\nEasy clean, non stick plates.\nRapid heat-up and high temperature makes golden brown sandwiches.\nPower on and ready to cook indicators.\nVertical storage and cord wrap to save on space.\nNon slip feet for safety. \nContemporary satin silver finish. \n', '24.99', '5.00', '1.25', '26.24', null, null);
INSERT INTO `products` VALUES ('21', '/images/products/no_image.gif', 'Electronics', '???', ' Kenwood Miro Pink 2 Slice Toaster', 'Wide self centring deep slots. \nVariable browning control. \nHi lift. \nIlluminated control panel for cancel/defrost/reheat facility. \nSlide out crumb tray. \nCord storage\n', '24.99', '5.00', '1.25', '26.24', null, null);
INSERT INTO `products` VALUES ('22', '/images/products/MorphyRichards44407Style4SliceToaster.jpg', 'Electronics', '???', ' Morphy Richards 44407 Style 4 Slice Toaster', 'Deep variable width toasting chamber. \nVariable browning control. \nHi-lift. \nCancel/frozen/reheat facility. \nBun warming rack. \nRemovable crumb tray. \nNon slip feet. \nCord storage\n', '24.99', '5.00', '1.25', '26.24', null, null);
INSERT INTO `products` VALUES ('23', '/images/products/CookworksSignature4SliceStainlessSteelToaster.jpg', 'Electronics', '???', ' Cookworks Signature 4 Slice Stainless Steel Toaster', 'Independent 2 slice operation. \nVariable width. \nSelf centring. \nVariable browning control. \nHi lift. \nCancel/frozen/reheat facility. \nMid cycle cancel. \nRemovable crumb tray. \nNon slip feet. \nCord storage. \n\n', '24.99', '5.00', '1.25', '26.24', null, null);
INSERT INTO `products` VALUES ('24', '/images/products/no_image.gif', 'Electronics', '???', ' Tefal Toast and Grill', '1300 watts. \nCompact size (no bigger than an average 4 slice toaster). \n2 trays (toast/grill rack and enamel plate). \nBooster button to toast or reheat in ultra fast time (cooks chilled Pizza in 5 minutes - 3 x faster than a conventional oven). \nPerfect toasting control thanks to two heating elements (top and below). \nElectronic 25 minute timer with variable browning control. \nOn/off indicator. \nEasy to clean thanks to its hinged grill. \nNon slip feet. \n', '24.99', '5.00', '1.25', '26.24', null, null);
INSERT INTO `schema_info` VALUES ('30');
INSERT INTO `tags` VALUES ('1', 'electronics', '2007-08-03 17:59:40', '2007-08-03 17:59:40');
INSERT INTO `tags` VALUES ('2', 'jewellery (male)', '2007-08-03 17:59:40', '2007-08-03 17:59:40');
INSERT INTO `tags` VALUES ('3', 'jewellery (female)', '2007-08-03 17:59:40', '2007-08-03 17:59:40');
