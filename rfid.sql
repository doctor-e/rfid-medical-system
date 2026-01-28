-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: rfid
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `allergy`
--

DROP TABLE IF EXISTS `allergy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allergy` (
  `allergy_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `severity` varchar(20) DEFAULT NULL,
  `patient_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`allergy_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `allergy_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allergy`
--

LOCK TABLES `allergy` WRITE;
/*!40000 ALTER TABLE `allergy` DISABLE KEYS */;
INSERT INTO `allergy` VALUES (1,'Peanuts','Severe','RFID001'),(2,'Dust','Mild','RFID002'),(3,'Pollen','Moderate','RFID003'),(4,'Latex','Moderate','RFID004'),(5,'Seafood','Severe','RFID005'),(6,'Penicillin','Severe','RFID006'),(7,'Cats','Mild','RFID007'),(8,'Gluten','Moderate','RFID008'),(9,'Shellfish','Severe','RFID009'),(10,'Mold','Moderate','RFID010'),(11,'Soy','Mild','RFID011'),(12,'Animal Dander','Moderate','RFID012'),(13,'Latex','Severe','RFID013'),(14,'Pollen','Moderate','RFID014'),(15,'Dust','Mild','RFID015'),(16,'Peanuts','Severe','RFID016'),(17,'Seafood','Severe','RFID017'),(18,'Latex','Moderate','RFID018'),(19,'Penicillin','Severe','RFID019'),(20,'Cats','Mild','RFID020'),(21,'Gluten','Moderate','RFID021'),(22,'Mold','Moderate','RFID022'),(23,'Soy','Mild','RFID023'),(24,'Animal Dander','Moderate','RFID024'),(25,'Shellfish','Severe','RFID025'),(26,'Bee Sting','Severe','RFID026'),(27,'Chocolate','Mild','RFID027'),(28,'Strawberries','Mild','RFID028'),(29,'Eggs','Moderate','RFID029'),(30,'Wheat','Severe','RFID030'),(31,'Mold','Moderate','RFID031'),(32,'Peanuts','Severe','RFID032'),(33,'Seafood','Severe','RFID033'),(34,'Pollen','Moderate','RFID034'),(35,'Cats','Mild','RFID035'),(36,'Latex','Moderate','RFID036'),(37,'Penicillin','Severe','RFID037'),(38,'Dust','Mild','RFID038'),(39,'Soy','Mild','RFID039'),(40,'Gluten','Moderate','RFID040'),(41,'Animal Dander','Moderate','RFID041'),(42,'Shellfish','Severe','RFID042'),(43,'Bee Sting','Severe','RFID043'),(44,'Chocolate','Mild','RFID044'),(45,'Strawberries','Mild','RFID045'),(46,'Eggs','Moderate','RFID046'),(47,'Wheat','Severe','RFID047'),(48,'Seafood','Moderate','RFID048'),(49,'Nuts','Severe','RFID049'),(50,'Dust','Mild','RFID050');
/*!40000 ALTER TABLE `allergy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditlog`
--

DROP TABLE IF EXISTS `auditlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditlog` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `action` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  `patient_id` varchar(32) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `patient_id` (`patient_id`),
  KEY `auditlog_ibfk_2` (`user_id`),
  CONSTRAINT `auditlog_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`),
  CONSTRAINT `auditlog_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditlog`
--

LOCK TABLES `auditlog` WRITE;
/*!40000 ALTER TABLE `auditlog` DISABLE KEYS */;
INSERT INTO `auditlog` VALUES (1,'Created prescription',NULL,'RFID001',1),(2,'Updated patient info',NULL,'RFID002',2),(3,'Created prescription',NULL,'RFID004',4),(4,'Updated patient info',NULL,'RFID005',1),(5,'Reviewed visit notes',NULL,'RFID006',2),(6,'Canceled prescription',NULL,'RFID007',3),(7,'Created prescription',NULL,'RFID008',5),(8,'Created prescription',NULL,'RFID009',6),(9,'Updated patient info',NULL,'RFID010',7),(10,'Reviewed visit notes',NULL,'RFID011',8),(11,'Canceled prescription',NULL,'RFID012',9),(12,'Created prescription',NULL,'RFID013',10);
/*!40000 ALTER TABLE `auditlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chronicdisease`
--

DROP TABLE IF EXISTS `chronicdisease`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chronicdisease` (
  `disease_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `patient_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`disease_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `chronicdisease_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chronicdisease`
--

LOCK TABLES `chronicdisease` WRITE;
/*!40000 ALTER TABLE `chronicdisease` DISABLE KEYS */;
INSERT INTO `chronicdisease` VALUES (1,'Diabetes','RFID001'),(2,'Hypertension','RFID002'),(3,'Thyroid Disorder','RFID004'),(4,'Arthritis','RFID005'),(5,'Migraines','RFID006'),(6,'Asthma','RFID007'),(7,'Hypertension','RFID008'),(8,'Obesity','RFID009'),(9,'Migraine','RFID010'),(10,'Diabetes','RFID011'),(11,'Asthma','RFID012'),(12,'Hypertension','RFID013'),(13,'Diabetes','RFID014'),(14,'Hypertension','RFID015'),(15,'Asthma','RFID016'),(16,'Thyroid Disorder','RFID017'),(17,'Arthritis','RFID018'),(18,'Migraines','RFID019'),(19,'Obesity','RFID020'),(20,'Sleep Apnea','RFID021'),(21,'Heart Disease','RFID022'),(22,'Kidney Disease','RFID023'),(23,'Cholesterol','RFID024'),(24,'Gastritis','RFID025'),(25,'Hepatitis','RFID026'),(26,'COPD','RFID027'),(27,'Anemia','RFID028'),(28,'Vitamin D Deficiency','RFID029'),(29,'Hyperthyroidism','RFID030'),(30,'Diabetes','RFID031'),(31,'Hypertension','RFID032'),(32,'Asthma','RFID033'),(33,'Thyroid Disorder','RFID034'),(34,'Arthritis','RFID035'),(35,'Migraines','RFID036'),(36,'Obesity','RFID037'),(37,'Sleep Apnea','RFID038'),(38,'Heart Disease','RFID039'),(39,'Kidney Disease','RFID040'),(40,'Cholesterol','RFID041'),(41,'Gastritis','RFID042'),(42,'Hepatitis','RFID043'),(43,'COPD','RFID044'),(44,'Anemia','RFID045'),(45,'Vitamin D Deficiency','RFID046'),(46,'Hyperthyroidism','RFID047'),(47,'Hypotension','RFID048'),(48,'Migraine','RFID049'),(49,'Diabetes','RFID050');
/*!40000 ALTER TABLE `chronicdisease` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drug`
--

DROP TABLE IF EXISTS `drug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug` (
  `drug_id` int NOT NULL AUTO_INCREMENT,
  `drug_name` varchar(100) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`drug_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drug`
--

LOCK TABLES `drug` WRITE;
/*!40000 ALTER TABLE `drug` DISABLE KEYS */;
INSERT INTO `drug` VALUES (1,'Paracetamol','Pain reliever and fever reducer'),(2,'Amoxicillin','Antibiotic for bacterial infections'),(3,'Insulin','Hormone for diabetes treatment'),(4,'Ibuprofen','Anti-inflammatory painkiller'),(5,'Cetirizine','Antihistamine for allergies'),(6,'Metformin','Diabetes medication'),(7,'Lisinopril','Blood pressure medication'),(8,'Aspirin','Pain relief and anti-clotting'),(9,'Hydrochlorothiazide','Diuretic for high blood pressure'),(10,'Prednisone','Anti-inflammatory corticosteroid'),(11,'Metoprolol','Beta-blocker for heart issues'),(12,'Omeprazole','Proton pump inhibitor for acid reflux'),(13,'Simvastatin','Cholesterol-lowering medication'),(14,'Aspirin','Pain relief and anti-clotting'),(15,'Metformin','Diabetes medication'),(16,'Lisinopril','Blood pressure medication'),(17,'Omeprazole','Proton pump inhibitor for acid reflux'),(18,'Simvastatin','Cholesterol-lowering medication'),(19,'Hydrochlorothiazide','Diuretic for high blood pressure'),(20,'Prednisone','Anti-inflammatory corticosteroid'),(21,'Metoprolol','Beta-blocker for heart issues'),(22,'Albuterol','Asthma inhaler'),(23,'Levothyroxine','Thyroid hormone'),(24,'Ibuprofen','Anti-inflammatory painkiller'),(25,'Cetirizine','Antihistamine for allergies'),(26,'Furosemide','Diuretic'),(27,'Pantoprazole','Proton pump inhibitor'),(28,'Warfarin','Anticoagulant'),(29,'Clopidogrel','Blood thinner'),(30,'Amoxicillin','Antibiotic'),(31,'Ibuprofen','Anti-inflammatory painkiller'),(32,'Cetirizine','Antihistamine for allergies'),(33,'Metformin','Diabetes medication'),(34,'Lisinopril','Blood pressure medication'),(35,'Aspirin','Pain relief and anti-clotting'),(36,'Omeprazole','Proton pump inhibitor'),(37,'Simvastatin','Cholesterol-lowering medication'),(38,'Hydrochlorothiazide','Diuretic for high blood pressure'),(39,'Prednisone','Anti-inflammatory corticosteroid'),(40,'Metoprolol','Beta-blocker for heart issues'),(41,'Albuterol','Asthma inhaler'),(42,'Levothyroxine','Thyroid hormone'),(43,'Furosemide','Diuretic'),(44,'Pantoprazole','Proton pump inhibitor'),(45,'Warfarin','Anticoagulant'),(46,'Clopidogrel','Blood thinner'),(47,'Amoxicillin','Antibiotic'),(48,'Paracetamol','Pain and fever relief'),(49,'Naproxen','Anti-inflammatory'),(50,'Cefuroxime','Antibiotic');
/*!40000 ALTER TABLE `drug` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `patient_id` varchar(50) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `blood_type` varchar(3) DEFAULT NULL,
  `emergency_contact` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES ('RFID001','Ali','Benali','1985-03-12','M','A+','0555555501'),('RFID002','Sara','Khaldi','1990-07-25','F','O+','0666666602'),('RFID003','Youssef','Amar','2000-11-05','M','B+','0777777703'),('RFID004','Meryem','Boudiaf','1995-05-18','F','AB+','0555555504'),('RFID005','Hassan','Fares','1982-09-30','M','O+','0666666605'),('RFID006','Nadia','Cheb','1998-02-14','F','A-','0777777706'),('RFID007','Omar','Said','1987-12-01','M','B-','0555555507'),('RFID008','Amira','Toumi','2001-08-21','F','O+','0666666608'),('RFID009','Karim','Ziani','1989-03-11','M','A-','0777777709'),('RFID010','Salma','Meziane','1992-07-22','F','B+','0555555510'),('RFID011','Rachid','Fethi','1978-12-05','M','O-','0666666611'),('RFID012','Noura','Djelloul','1996-05-19','F','AB-','0777777712'),('RFID013','Yassine','Khalfi','2002-08-30','M','B+','0555555513'),('RFID014','Salim','Bencheikh','1983-02-12','M','A+','0666666614'),('RFID015','Imane','Kherfi','1991-06-18','F','O-','0777777715'),('RFID016','Karim','Sahli','1988-09-05','M','B+','0555555516'),('RFID017','Lina','Touati','1995-11-23','F','AB+','0666666617'),('RFID018','Rachid','Belhachemi','1982-04-14','M','O+','0777777718'),('RFID019','Nadia','Chergui','2000-01-30','F','A-','0555555519'),('RFID020','Omar','Fares','1987-12-07','M','B-','0666666620'),('RFID021','Yasmine','Djelloul','1996-03-18','F','O+','0777777721'),('RFID022','Hassan','Ziani','1990-05-25','M','A+','0555555522'),('RFID023','Meryem','Meziane','1992-07-20','F','B+','0666666623'),('RFID024','Samir','Fethi','1978-12-05','M','O-','0777777724'),('RFID025','Amira','Djelloul','1996-05-19','F','AB-','0555555525'),('RFID026','Yassine','Khalfi','2002-08-30','M','B+','0666666626'),('RFID027','Karim','Ziani','1989-03-11','M','A-','0777777727'),('RFID028','Salma','Meziane','1992-07-22','F','B+','0555555528'),('RFID029','Rachid','Fethi','1978-12-05','M','O-','0666666629'),('RFID030','Noura','Djelloul','1996-05-19','F','AB-','0777777730'),('RFID031','Ahmed','Brahimi','1980-03-12','M','A+','0555555531'),('RFID032','Sofia','Rezig','1993-07-04','F','B+','0666666632'),('RFID033','Mohamed','Karim','1985-10-22','M','O-','0777777733'),('RFID034','Leila','Haddad','1990-01-15','F','AB+','0555555534'),('RFID035','Youssef','Fares','1987-06-30','M','O+','0666666635'),('RFID036','Samira','Toumi','1995-08-18','F','A-','0777777736'),('RFID037','Othman','Belkacem','1992-05-25','M','B-','0555555537'),('RFID038','Nadia','Cherif','1998-11-10','F','O+','0666666638'),('RFID039','Khalid','Ziani','1986-09-05','M','A+','0777777739'),('RFID040','Rania','Meziane','1991-12-02','F','B-','0555555540'),('RFID041','Imad','Fethi','1983-07-17','M','O+','0666666641'),('RFID042','Amina','Djelloul','1996-03-23','F','AB-','0777777742'),('RFID043','Yassine','Khalfi','2000-10-11','M','B+','0555555543'),('RFID044','Karim','Ziani','1989-02-28','M','A-','0666666644'),('RFID045','Salma','Meziane','1992-04-19','F','B+','0777777745'),('RFID046','Rachid','Fethi','1978-08-15','M','O-','0555555546'),('RFID047','Noura','Djelloul','1996-05-09','F','AB-','0666666647'),('RFID048','Youssef','Khalfi','2002-08-21','M','B+','0777777748'),('RFID049','Karim','Touati','1988-11-03','M','O+','0555555549'),('RFID050','Lina','Fares','1994-06-27','F','A+','0666666650');
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription` (
  `prescription_id` int NOT NULL AUTO_INCREMENT,
  `prescription_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `patient_id` varchar(32) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`prescription_id`),
  KEY `patient_id` (`patient_id`),
  KEY `prescription_ibfk_2` (`user_id`),
  CONSTRAINT `prescription_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`),
  CONSTRAINT `prescription_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription`
--

LOCK TABLES `prescription` WRITE;
/*!40000 ALTER TABLE `prescription` DISABLE KEYS */;
INSERT INTO `prescription` VALUES (1,'2026-01-10','active','RFID001',1),(2,'2026-01-12','completed','RFID002',1),(3,'2026-01-25','active','RFID004',4),(4,'2026-01-26','completed','RFID005',1),(5,'2026-01-27','active','RFID006',2),(6,'2026-01-28','canceled','RFID007',3),(7,'2026-01-29','active','RFID008',5),(8,'2026-01-30','active','RFID009',6),(9,'2026-01-31','completed','RFID010',7),(10,'2026-02-01','active','RFID011',8),(11,'2026-02-02','canceled','RFID012',9),(12,'2026-02-03','active','RFID013',10),(72,'2026-01-24',NULL,'RFID050',1),(73,'2026-01-24','active','RFID050',1),(74,'2026-01-25','active','RFID005',1),(75,'2026-01-25','active','RFID005',1),(76,'2026-01-26','active','RFID015',1);
/*!40000 ALTER TABLE `prescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescription_drug`
--

DROP TABLE IF EXISTS `prescription_drug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription_drug` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dosage` varchar(50) DEFAULT NULL,
  `frequency` varchar(100) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `prescription_id` int DEFAULT NULL,
  `drug_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prescriptionitem_ibfk_1` (`prescription_id`),
  KEY `prescriptionitem_ibfk_2` (`drug_id`),
  CONSTRAINT `prescription_drug_ibfk_1` FOREIGN KEY (`prescription_id`) REFERENCES `prescription` (`prescription_id`),
  CONSTRAINT `prescription_drug_ibfk_2` FOREIGN KEY (`drug_id`) REFERENCES `drug` (`drug_id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription_drug`
--

LOCK TABLES `prescription_drug` WRITE;
/*!40000 ALTER TABLE `prescription_drug` DISABLE KEYS */;
INSERT INTO `prescription_drug` VALUES (1,'500mg',NULL,'5 days',1,1),(2,'250mg',NULL,'7 days',1,2),(3,'10 units',NULL,'daily',2,3),(71,'500 mg','2/day','5 days',72,2),(72,'500mg','every 6 hours','3 days',73,1),(73,'As directed','Once daily','7 days',74,1),(74,'1g','Three times daily','3 days',75,4),(75,'500mg','Once daily','7days',75,8),(76,'1000mg','Once daily','7 days',76,1);
/*!40000 ALTER TABLE `prescription_drug` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL DEFAULT 'password123',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Driss','Mansouri','drissm','doctor','password123'),(2,'Lina','Farah','linaf','pharmacist','password123'),(3,'Samir','Ould','samiro','emergency','password123'),(4,'Rania','Kacem','raniak','doctor','password123'),(5,'Karim','Bouzid','karimb','pharmacist','password123'),(6,'Samia','Yahi','samiy','emergency','password123'),(7,'Fouad','Belkacem','fouadb','doctor','password123'),(8,'Lamia','Haddad','lamiah','pharmacist','password123'),(9,'Amel','Bouabdellah','amelb','doctor','password123'),(10,'Riyad','Cherif','riyadc','pharmacist','password123'),(11,'Dounia','Bensaid','douniab','emergency','password123'),(12,'Sofiane','Belhadj','sofianeb','doctor','password123'),(13,'Hanane','Boudjemaa','hananeb','pharmacist','password123'),(51,'Omar','Messaoudi','omarm2','doctor','password123'),(52,'Salma','Amrani','salmaa2','pharmacist','password123'),(53,'Nabil','Karim','nabilk2','emergency','password123'),(54,'Imane','Fouad','imanef2','doctor','password123'),(55,'Yassine','Benali','yassineb2','pharmacist','password123'),(56,'Karim','Said','karims2','emergency','password123'),(57,'Amira','Toumi','amirat2','doctor','password123'),(58,'Samir','Ould','samiro2','pharmacist','password123'),(59,'Rania','Kacem','raniak2','doctor','password123'),(60,'Lina','Farah','linaf2','pharmacist','password123'),(61,'Driss','Mansouri','drissm2','emergency','password123'),(62,'Nora','Benmoussa','norab2','doctor','password123'),(63,'Sofiane','Belhadj','sofianeb2','doctor','password123'),(64,'Hanane','Boudjemaa','hananeb2','pharmacist','password123'),(65,'Fatima','Boualem','fatimab2','doctor','password123'),(66,'Dounia','Bensaid','douniab2','emergency','password123'),(67,'Riyad','Cherif','riyadc2','pharmacist','password123'),(68,'Ahmed','Khelifi','ahmedk2','doctor','password123'),(69,'Karim','Bouaziz','karimb2','pharmacist','password123'),(70,'Samira','Belhadj','samirab2','emergency','password123');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visit`
--

DROP TABLE IF EXISTS `visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit` (
  `visit_id` int NOT NULL AUTO_INCREMENT,
  `visit_date` date DEFAULT NULL,
  `notes` text,
  `patient_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`visit_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `visit_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit`
--

LOCK TABLES `visit` WRITE;
/*!40000 ALTER TABLE `visit` DISABLE KEYS */;
INSERT INTO `visit` VALUES (1,'2026-01-05','Routine checkup','RFID001'),(2,'2026-01-11','Follow-up visit','RFID002'),(3,'2026-01-24','Thyroid check','RFID004'),(4,'2026-01-25','Joint pain','RFID005'),(5,'2026-01-26','Migraine follow-up','RFID006'),(6,'2026-01-27','Asthma attack review','RFID007'),(7,'2026-01-28','Blood pressure control','RFID008'),(8,'2026-01-29','Blood pressure follow-up','RFID009'),(9,'2026-01-30','Migraine check','RFID010'),(10,'2026-01-31','Diabetes review','RFID011'),(11,'2026-02-01','Asthma control','RFID012'),(12,'2026-02-02','Routine heart check','RFID013'),(13,'2026-02-04','Routine checkup','RFID014'),(14,'2026-02-05','Follow-up','RFID015'),(15,'2026-02-06','Pain management','RFID016'),(16,'2026-02-07','Lab results','RFID017'),(17,'2026-02-08','Medication review','RFID018'),(18,'2026-02-09','Asthma check','RFID019'),(19,'2026-02-10','Blood pressure follow-up','RFID020'),(20,'2026-02-11','Migraine check','RFID021'),(21,'2026-02-12','Diabetes review','RFID022'),(22,'2026-02-13','Asthma control','RFID023'),(23,'2026-02-14','Heart check','RFID024'),(24,'2026-02-15','Routine labs','RFID025'),(25,'2026-02-16','Prescription follow-up','RFID026'),(26,'2026-02-17','Emergency visit','RFID027'),(27,'2026-02-18','Allergy review','RFID028'),(28,'2026-02-19','Medication adjustment','RFID029'),(29,'2026-02-20','Routine checkup','RFID030');
/*!40000 ALTER TABLE `visit` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-26 21:48:40
