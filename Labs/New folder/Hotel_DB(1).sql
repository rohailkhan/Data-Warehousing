-- DESCRIPTION
--   This script creates the tables in the Hotel database used in End-of-chapter Exercises in the Connolly & Begg textbook

DROP TABLE Booking;
DROP TABLE Guest;
DROP TABLE Room;
DROP TABLE Hotel;

CREATE TABLE Hotel
	(hotelNo		CHAR(4) constraint hotel_pk PRIMARY KEY,
		hotelName 	VARCHAR2(20),
		city		VARCHAR2(50));


CREATE TABLE Room
	(roomNo		VARCHAR2(4),
		hotelNo	CHAR(4),
		type 	CHAR(1)	Check (type IN ('S', 'D', 'F')),
		price	DECIMAL(5,2),
		constraint room_pk PRIMARY KEY (roomNo, hotelNo),
		constraint room_FK FOREIGN KEY (hotelNo) REFERENCES Hotel(hotelNo)); 


CREATE TABLE Guest
		(guestNo		CHAR(4)	constraint guest_pk PRIMARY KEY,
		guestName 	VARCHAR2(20),
		guestAddress	VARCHAR2(50),
		guestCity varchar2 (50));
		

CREATE TABLE Booking
	(hotelNo		CHAR(4),
		guestNo		CHAR(4),
		dateFrom 	DATE,
		dateTo		DATE,
		roomNo		VARCHAR2(4),
		constraint booking_pk PRIMARY KEY (hotelNo, guestNo, dateFrom),
		constraint booking_fk1 FOREIGN KEY (hotelNo) REFERENCES Hotel(hotelNo), 
		constraint booking_fk2 FOREIGN KEY (guestNo) REFERENCES Guest(guestNo),
		constraint booking_fk3 FOREIGN KEY (roomNo, hotelNo) REFERENCES Room(roomNo, hotelNo));

INSERT INTO Hotel
	VALUES ('H111','Grosvenor Hotel','London');
INSERT INTO Hotel
	VALUES ('H222','Waipuna Hotel','Auckland');
INSERT INTO Hotel
	VALUES ('H333','Taupo Resort Hotel','Taupo');
INSERT INTO Hotel
	VALUES ('H444','Bay View Hotel','Wellington');
INSERT INTO Hotel
	VALUES ('H555','Quest Hotel','Hamilton');


INSERT INTO Room
	VALUES ('1','H111','S',72.00);
INSERT INTO Room
	VALUES ('2','H111','S',10.00);
INSERT INTO Room
	VALUES ('3','H111','D',40.00);
INSERT INTO Room
	VALUES ('4','H111','D',40.00);
INSERT INTO Room
	VALUES ('5','H111','F',80.00);
INSERT INTO Room
	VALUES ('6','H111','F',80.00);
INSERT INTO Room
	VALUES ('1','H222','F',80.00);
INSERT INTO Room
	VALUES ('2','H222','F',85.00);
INSERT INTO Room
	VALUES ('3','H222','F',90.00);
INSERT INTO Room
	VALUES ('4','H222','F',95.00);
INSERT INTO Room
	VALUES ('1','H333','F',85.00);
INSERT INTO Room
	VALUES ('1','H444','F',60.00);
INSERT INTO Room
	VALUES ('1','H555','S',15.00);
INSERT INTO Room
	VALUES ('2','H555','D',50.00);
INSERT INTO Room
	VALUES ('3','H555','F',90.00);

INSERT INTO Guest
	VALUES ('G111','John Smith','88 Oxford Road, London, UK', 'London');
INSERT INTO Guest
	VALUES ('G112','Pat Cahi','1 Beach Road, Keri Keri, NZ', 'Keri Keri');
INSERT INTO Guest
	VALUES ('G113','Pritam Joseph','16 Sun Drive, Napier, NZ', 'Napier');
INSERT INTO Guest
	VALUES ('G114','Marama Jones','250 Queen Road, Hamilton, NZ', 'Hamilton');
INSERT INTO Guest
	VALUES ('G115','Ken Lee','8 Mount St., Auckland CBD, 1010, NZ', 'Auckland');
INSERT INTO Guest
	VALUES ('G116','250 Elizabeth St, Sydney, NSW 5454, Australia', 'Sydney');

INSERT INTO Booking
	VALUES ('H111','G111','26-Dec-03','29-Dec-03','1');
INSERT INTO Booking
	VALUES ('H222','G111','03-Jun-04','05-Jun-04','1');
INSERT INTO Booking
	VALUES ('H333','G112','06-Jun-04','10-Jun-04','1');
INSERT INTO Booking
	VALUES ('H111','G113','30-Jun-04','01-Jul-04','3');
INSERT INTO Booking
	VALUES ('H111','G114','05-Jul-04','10-Jul-04','2');
INSERT INTO Booking
	VALUES ('H111','G113','05-Jul-04','08-Jul-04','3');
INSERT INTO Booking
	VALUES ('H555','G116','01-Aug-04','03-Aug-04','2');
INSERT INTO Booking
	VALUES ('H111','G113','01-Aug-04','08-Aug-04','3');
INSERT INTO Booking
	VALUES ('H111','G116','10-Aug-04','14-Aug-04','3');
INSERT INTO Booking
	VALUES ('H111','G113','20-Aug-04','22-Aug-04','4');
INSERT INTO Booking
	VALUES ('H444','G115','21-Aug-04','22-Aug-04','1');

COMMIT;

