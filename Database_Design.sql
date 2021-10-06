--BEGIN
--  EXECUTE IMMEDIATE 'DROP TABLE location_features_linking';
--  EXECUTE IMMEDIATE 'DROP TABLE features';
--  EXECUTE IMMEDIATE 'DROP TABLE reservation_details';
--  EXECUTE IMMEDIATE 'DROP TABLE reservation';
--  EXECUTE IMMEDIATE 'DROP TABLE customer_payment';
--  EXECUTE IMMEDIATE 'DROP TABLE customer';
--  EXECUTE IMMEDIATE 'DROP TABLE room';
--  EXECUTE IMMEDIATE 'DROP TABLE location';
--
--    
--EXCEPTION
--  WHEN OTHERS THEN
--  DBMS_OUTPUT.PUT_LINE('');
--END;
--/

DROP SEQUENCE payment_id_seq;
DROP SEQUENCE reservation_id_seq;
DROP SEQUENCE room_id_seq;
DROP SEQUENCE location_id_seq;
DROP SEQUENCE feature_id_seq;
DROP SEQUENCE customer_id_seq;

DROP TABLE location_features_linking;
DROP TABLE features;
DROP TABLE reservation_details;
DROP TABLE reservation;
DROP TABLE customer_payment;
DROP TABLE customer;
DROP TABLE room;
DROP TABLE location;


CREATE SEQUENCE payment_id_seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE reservation_id_seq
  START WITH 1
  INCREMENT BY 1;
  
CREATE SEQUENCE room_id_seq
  START WITH 1
  INCREMENT BY 1;
  
CREATE SEQUENCE location_id_seq
  START WITH 1
  INCREMENT BY 1;
  
CREATE SEQUENCE feature_id_seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE customer_id_seq
  START WITH 100001
  INCREMENT BY 1;
  
  
CREATE TABLE customer
(
  customer_id                     NUMBER         DEFAULT customer_id_seq.NEXTVAL  NOT NULL PRIMARY KEY,
  first_name                      VARCHAR2(50)                NOT NULL,
  last_name                       VARCHAR2(50)                NOT NULL,
  email                           VARCHAR2(50)                NOT NULL     UNIQUE,
  phone                           CHAR(12)                    NOT NULL,
  address_line_1                  VARCHAR2(50)                NOT NULL,
  address_line_2                  VARCHAR2(20),    
  city                            VARCHAR2(50)                NOT NULL,
  state                           CHAR(2)                     NOT NULL,
  zip                             CHAR(5)                     NOT NULL,
  birthdate                       DATE,      
  stay_credits_earned             NUMBER          DEFAULT 0   NOT NULL, 
  stay_credits_used               NUMBER          DEFAULT 0   NOT NULL,
  CONSTRAINT stay_credit_earned_used_check
    CHECK (stay_credits_earned>stay_credits_used),
  CONSTRAINT email_length_check
    CHECK (LENGTHB(email) >= 7)
);


CREATE TABLE customer_payment
(
  payment_id                     NUMBER          DEFAULT payment_id_seq.NEXTVAL NOT NULL   PRIMARY KEY,
  customer_id                    NUMBER          NOT NULL   REFERENCES customer (customer_id),
  cardholder_first_name          VARCHAR2(50)    NOT NULL,
  cardholder_mid_name            VARCHAR2(50)    NOT NULL,
  cardholder_last_name           VARCHAR2(50)    NOT NULL,
  cardtype                       CHAR(4)         NOT NULL,
  cardnumber                     VARCHAR2(50)    NOT NULL,
  expiration_date                DATE            NOT NULL,
  cc_id                          VARCHAR2(50)    NOT NULL,
  billing_address                VARCHAR2(50)    NOT NULL,
  billing_city                   VARCHAR2(50)    NOT NULL,
  billing_state                  CHAR(2)          NOT NULL,
  billing_zip                    CHAR(5)          NOT NULL
);

CREATE TABLE reservation
(
  reservation_id                 NUMBER         DEFAULT reservation_id_seq.NEXTVAL PRIMARY KEY       NOT NULL,
  customer_id                    NUMBER                           NOT NULL    REFERENCES customer (customer_id),
  confirmation_nbr               CHAR(8)                          NOT NULL    UNIQUE,
  date_created                   DATE           DEFAULT SYSDATE   NOT NULL,
  check_in_date                  DATE                             NOT NULL,
  check_out_date                 DATE,           
  status                         CHAR(1)                          NOT NULL,
  discount_code                  VARCHAR2(50),   
  reservation_total              VARCHAR2(50)                     NOT NULL,
  customer_rating                VARCHAR2(50),  
  notes                          VARCHAR2(50),
  CONSTRAINT status_check
    CHECK (status IN ('U','I', 'C','N','R'))
);

CREATE TABLE location
(
  location_id                     NUMBER          DEFAULT location_id_seq.NEXTVAL NOT NULL    PRIMARY KEY,
  location_name                   VARCHAR2(50)    NOT NULL    UNIQUE,
  address                         VARCHAR2(50)    NOT NULL,
  city                            VARCHAR2(50)    NOT NULL,
  state                           CHAR(2)         NOT NULL,
  zip                             CHAR(5)         NOT NULL,
  phone                           CHAR(12)        NOT NULL,
  url                             VARCHAR2(50)    NOT NULL
);

CREATE TABLE room
(
  room_id                        NUMBER          DEFAULT room_id_seq.NEXTVAL NOT NULL  PRIMARY KEY,
  location_id                    NUMBER          NOT NULL  REFERENCES location (location_id),
  floor                          VARCHAR2(50)    NOT NULL,
  room_number                    VARCHAR2(50)    NOT NULL,
  room_type                      CHAR(1)         NOT NULL,
  square_footage                 VARCHAR2(50)         NOT NULL,
  max_people                     VARCHAR2(50)    NOT NULL,
  weekday_rate                   VARCHAR2(50)    NOT NULL,
  weekend_rate                  VARCHAR2(50)    NOT NULL,
  CONSTRAINT roomtype_check
    CHECK (room_type IN ('D','Q','K','S','C'))
);

CREATE TABLE reservation_details
(
  reservation_id                 NUMBER          NOT NULL    REFERENCES reservation (reservation_id),
  room_id                        NUMBER          NOT NULL    REFERENCES room (room_id),
  number_of_guests               NUMBER          NOT NULL,
  CONSTRAINT reservation_details_pk
    PRIMARY KEY (reservation_id,room_id)
);

CREATE TABLE features
(
  feature_id                     NUMBER          DEFAULT feature_id_seq.NEXTVAL NOT NULL    PRIMARY KEY,
  feature_name                   VARCHAR2(50)    NOT NULL    UNIQUE
);

CREATE TABLE location_features_linking
(
  location_id                     NUMBER         NOT NULL    REFERENCES location (location_id),
  feature_id                      NUMBER         NOT NULL    REFERENCES features (feature_id),  
  CONSTRAINT location_features_linking_pk
    PRIMARY KEY (location_id,feature_id)
);

CREATE INDEX customer_payment_customer_id_ix
  ON customer_payment (customer_id);

CREATE INDEX reservation_customer_id_ix
  ON reservation (customer_id);
  
CREATE INDEX room_location_id_ix
  ON room (location_id);

CREATE INDEX reservation_date_created_ix
  ON reservation (date_created);

CREATE INDEX customer_first_name_last_name_ix
  ON customer (first_name,last_name);
  
  
-- Inserting Data
INSERT INTO location (location_name,address,city,state,zip,phone,url)
VALUES ('Sour Apple Hotel', '123 6th Street','Austin','TX', '78750', '555-222-9999', 'sourapple.com');

INSERT INTO location (location_name,address,city,state,zip,phone,url)
VALUES ('East 7th Lofts', 'South Congress', 'Austin', 'TX', '78000', '500-200-9000', 'east7thlofts.com');

INSERT INTO location (location_name,address,city,state,zip,phone,url)
VALUES ('Marble Falls', 'Balcones Canyonlands', 'Austin', 'TX', '70000', '500-222-9999', 'sourapple.com');

COMMIT;

INSERT INTO features (feature_name)
VALUES ('Free Breakfast');

INSERT INTO features (feature_name)
VALUES ('Swimming Pool');

INSERT INTO features (feature_name)
VALUES ('Hot water');

COMMIT;

INSERT INTO location_features_linking (location_id,feature_id)
VALUES (1, 1);

INSERT INTO location_features_linking (location_id,feature_id)
VALUES (1, 2);

INSERT INTO location_features_linking (location_id,feature_id)
VALUES (2, 1);

INSERT INTO location_features_linking (location_id,feature_id)
VALUES (3, 2);

INSERT INTO location_features_linking (location_id,feature_id)
VALUES (3, 3);

COMMIT;

INSERT INTO room (location_id,floor,room_number,room_type,square_footage,max_people,weekday_rate,weekend_rate)
VALUES (1, 1, 101, 'D', 300.22, 2, 200, 400);

INSERT INTO room (location_id,floor,room_number,room_type,square_footage,max_people,weekday_rate,weekend_rate)
VALUES (1, 2, 201, 'S', 600.44, 4, 400, 600);

INSERT INTO room (location_id,floor,room_number,room_type,square_footage,max_people,weekday_rate,weekend_rate)
VALUES (2, 1, 101, 'D', 300.22, 2, 200, 400);

INSERT INTO room (location_id,floor,room_number,room_type,square_footage,max_people,weekday_rate,weekend_rate)
VALUES (2, 2, 201, 'S', 600.44, 4, 400, 600);

INSERT INTO room (location_id,floor,room_number,room_type,square_footage,max_people,weekday_rate,weekend_rate)
VALUES (3, 1, 101, 'D', 300.22, 2, 200, 400);

INSERT INTO room (location_id,floor,room_number,room_type,square_footage,max_people,weekday_rate,weekend_rate)
VALUES (3, 2, 201, 'S', 600.44, 4, 400, 600);

COMMIT;

INSERT INTO customer (first_name,last_name,email,phone,address_line_1,address_line_2,city,state,zip,birthdate,stay_credits_earned,stay_credits_used)
VALUES ('Rahul', 'Singla', 'rs57244@utexas.edu', '777-274-1111', '1000 5th Street', 'East', 'Austin', 'TX', '78700', '1 Jan 1947', 1000, 500);

INSERT INTO customer (first_name,last_name,email,phone,address_line_1,address_line_2,city,state,zip,birthdate,stay_credits_earned,stay_credits_used)
VALUES ('Prakhar', 'Bansal', 'pb1111@utexas.edu', '700-200-1000', '1040 10th Street', 'East', 'Austin', 'TX', '78511', '2 Feb 2000', 2000, 1000);

COMMIT;

INSERT INTO customer_payment (customer_id,cardholder_first_name,cardholder_mid_name,cardholder_last_name,cardtype,cardnumber,expiration_date,cc_id,billing_address,billing_city,billing_state,billing_zip)
VALUES (100001, 'Rahul', 'Kumar', 'Singla', 'VISA', 1234567890123456, '01 Jan 2022', 123, '1000 5th Street', 'Austin', 'TX', '78700');

INSERT INTO customer_payment (customer_id,cardholder_first_name,cardholder_mid_name,cardholder_last_name,cardtype,cardnumber,expiration_date,cc_id,billing_address,billing_city,billing_state,billing_zip)
VALUES (100002, 'Prakhar', 'Chand', 'Bansal', 'AMEX', 4567890123456789, '01 Dec 2021', 789, '1040 10th Street', 'Austin', 'TX', '78511');

COMMIT;

INSERT INTO reservation (customer_id,confirmation_nbr,date_created,check_in_date,check_out_date,status,discount_code,reservation_total,customer_rating,notes)
VALUES (100001, 'YFUGYGKJ', DEFAULT, '1 Sep 2021', '2 Sep 2021', 'C', NULL, 200, NULL, NULL);

INSERT INTO reservation_details (reservation_id,room_id,number_of_guests)
VALUES (1, 1, 2);

COMMIT;

INSERT INTO reservation (customer_id,confirmation_nbr,date_created,check_in_date,check_out_date,status,discount_code,reservation_total,customer_rating,notes)
VALUES (100002, 'YTJJJJGF', DEFAULT, '10 Sep 2021', '12 Sep 2021', 'C', NULL, 600, NULL, NULL);

INSERT INTO reservation_details (reservation_id,room_id,number_of_guests)
VALUES (2, 2, 2);

COMMIT;

INSERT INTO reservation (customer_id,confirmation_nbr,date_created,check_in_date,check_out_date,status,discount_code,reservation_total,customer_rating,notes)
VALUES (100002, 'YFUGLLLL', DEFAULT, '16 Sep 2021', '17 Sep 2021', 'C', NULL, 400, NULL, NULL);

INSERT INTO reservation_details (reservation_id,room_id,number_of_guests)
VALUES (2, 4, 2);

COMMIT;