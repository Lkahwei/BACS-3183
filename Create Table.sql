drop table transactionDetails;
drop table busSchedule;
drop table busRepair;
drop table transaction;
drop table ticketPrice;
drop table mechanic;
drop table driver;
drop table serviceCentre;
drop table route;
drop table bus;
drop table member;

CREATE TABLE member(
 memberID           CHAR(5)         NOT NULL, 
 memberName         VARCHAR2(60)    NOT NULL,
 memberIcNo         CHAR(12)        NOT NULL,
 memberGender       CHAR(1)         NOT NULL,
 memberDob          DATE            NOT NULL,
 memberEmail        VARCHAR2(50)    NOT NULL,
 memberPhoneNo      VARCHAR2(12)    NOT NULL,
 membershipPoint    NUMBER(5)       DEFAULT 0,
CONSTRAINT pk_member PRIMARY KEY (memberID), 
CONSTRAINT chk_email CHECK (REGEXP_LIKE(memberEmail, '^[a-zA-Z]\w+@(\S+)$')),
CONSTRAINT chk_memberPhone CHECK (REGEXP_LIKE(memberPhoneNo, '^0\d{9}|\d{11,12}$')),
CONSTRAINT uni_memberPhone UNIQUE (memberPhoneNo),
CONSTRAINT chk_memberIcNo CHECK (REGEXP_LIKE(memberIcNo, '^0\d{9}|\d{12}$')),
CONSTRAINT uni_memberIcNo UNIQUE (memberIcNo),
CONSTRAINT chk_memberGender CHECK (memberGender in ('M','F'))
);


CREATE TABLE bus(
 busPlateNo         VARCHAR2(7)   NOT NULL,
 totalNoOfSeats     NUMBER(2)     NOT NULL,
 roadTaxExpDate     DATE          DEFAULT NULL,
 insuranceExpDate   DATE          DEFAULT NULL,
 yearOfManufacture  NUMBER(4)     NOT NULL,
 busType            VARCHAR2(20)  NOT NULL,
CONSTRAINT pk_bus PRIMARY KEY (busPlateNo),
CONSTRAINT chk_busExpDATE CHECK (roadTaxExpDate = insuranceExpDate)
);

CREATE TABLE route(
 routeNo              CHAR(4)      NOT NULL,
 departureTerminal    VARCHAR2(30) NOT NULL, 
 arrivalTerminal      VARCHAR2(30) NOT NULL,
 travellingDistance   NUMBER(3)    NOT NULL,
 duration             TIMESTAMP    NOT NULL,
CONSTRAINT pk_route PRIMARY KEY (routeNo)
);

CREATE TABLE serviceCentre(
 serviceCentreID     CHAR(5)          NOT NULL,
 serviceCentreName   VARCHAR2(35)     NOT NULL,
 address             VARCHAR2(60)     NOT NULL,
 postalCode          CHAR(5)          NOT NULL,
 state               VARCHAR2(20)     NOT NULL,
 phoneNo             VARCHAR2(12)     NOT NULL,
CONSTRAINT pk_serviceCentre PRIMARY KEY (serviceCentreID),
CONSTRAINT chk_phoneNo CHECK (REGEXP_LIKE(phoneNo, '^0\d{9}|\d{11,12}$')),
CONSTRAINT uni_phoneNo UNIQUE (phoneNo)
);

CREATE TABLE driver(
 driverID          CHAR(4)       NOT NULL,
 driverName        VARCHAR2(60)  NOT NULL,
 driverIcNo        CHAR(12)      NOT NULL,
 driverGender      CHAR(1)               ,
 driverDob         DATE                  ,
 driverPhone       VARCHAR2(12)  NOT NULL,
 licenseExpDate    DATE          NOT NULL,
CONSTRAINT pk_driver PRIMARY KEY (driverID),
CONSTRAINT chk_driverPhone CHECK (REGEXP_LIKE(driverPhone, '^0\d{9}|\d{11,12}$')),
CONSTRAINT uni_driverPhone UNIQUE (driverPhone),
CONSTRAINT chk_driverIcNo CHECK (REGEXP_LIKE(driverIcNo, '^0\d{9}|\d{12}$')),
CONSTRAINT uni_driverIcNo UNIQUE (driverIcNo),
CONSTRAINT chk_driverGender CHECK (driverGender in ('M','F'))
);



CREATE TABLE mechanic(
 mechanicID      CHAR(5)       NOT NULL,
 mechanicName    VARCHAR2(60)  NOT NULL,
 mechanicIcNo    CHAR(12)      NOT NULL,
 mechanicDob     DATE                  ,
 mechanicGender  CHAR(1)               ,
 mechanicPhoneNo VARCHAR2(12)  NOT NULL,
 serviceCentreID CHAR(5)       NOT NULL,
CONSTRAINT pk_mechanic PRIMARY KEY (mechanicID),
CONSTRAINT chk_mechanicPhone CHECK (REGEXP_LIKE(mechanicPhoneNo, '^0\d{9}|\d{11,12}$')),
CONSTRAINT uni_mechanicPhone UNIQUE (mechanicPhoneNo),
CONSTRAINT chk_mechanicGender check (mechanicGender in ('M','F')),
CONSTRAINT chk_mechanicIcNo CHECK (REGEXP_LIKE(mechanicIcNo, '^0\d{9}|\d{12}$')),
CONSTRAINT uni_mechanicIcNo UNIQUE (mechanicIcNo),
CONSTRAINT fk_serviceCentre FOREIGN KEY (serviceCentreID) REFERENCES serviceCentre(serviceCentreID)
);

CREATE TABLE ticketPrice(
 ticketID            CHAR(5)       NOT NULL,
 routeNo             CHAR(4)       NOT NULL,
 childPrice          NUMBER(4,2)   NOT NULL,
 adultPrice          NUMBER(4,2)   NOT NULL,
 seniorCitizenPrice  NUMBER(4,2)   NOT NULL,
 status              VARCHAR2(10)  NOT NULL,
CONSTRAINT pk_ticket PRIMARY KEY (ticketID),
CONSTRAINT fk_route_ticket FOREIGN KEY (routeNo) REFERENCES route(routeNo),
CONSTRAINT chk_childPrice CHECK (childPrice < adultPrice),
CONSTRAINT chk_senCitiPrice CHECK (seniorCitizenPrice < adultPrice),
CONSTRAINT chk_status CHECK (status in ('PAST','CURRENT')) 
);

CREATE TABLE transaction(
 transactionID  CHAR(6)       NOT NULL,
 memberID       CHAR(5)       NOT NULL,
 purchaseDate   DATE          NOT NULL,
 totalPayment   NUMBER(6,2)   DEFAULT 0.00,
 paymentType    VARCHAR2(25)  NOT NULL,
CONSTRAINT pk_transaction PRIMARY KEY (transactionID),
CONSTRAINT fk_member_transaction FOREIGN KEY (memberID) REFERENCES member(memberID),
CONSTRAINT chk_paymentType CHECK (paymentType in ('E-Wallet','Debit Card/Credit Card', 'Online Banking'))
);

CREATE TABLE busRepair(
 busRepairID      CHAR(5)        NOT NULL,
 busPlateNo       VARCHAR2(7)    NOT NULL,
 mechanicID       CHAR(5)        NOT NULL,
 workDesc         VARCHAR2(100)  NOT NULL,
 repairDate       DATE           DEFAULT NULL,
CONSTRAINT pk_busRepair PRIMARY KEY (busRepairID),
CONSTRAINT fk_bus_busRepair FOREIGN KEY (busPlateNo) REFERENCES bus(busPlateNo),
CONSTRAINT fk_mechanic_busRepair FOREIGN KEY (mechanicID) REFERENCES mechanic(mechanicID)
);

CREATE TABLE busSchedule(
 scheduleID           CHAR(6)       NOT NULL,
 routeNo              CHAR(4)       NOT NULL,
 driverID             CHAR(4)       NOT NULL,
 busPlateNo           VARCHAR2(7)   NOT NULL,
 departureDate        DATE          NOT NULL,
 departureTime        TIMESTAMP     NOT NULL,
 scheduleStatus       VARCHAR2(10)  NOT NULL,
 noOfTicketAvailable  NUMBER(2)     NOT NULL,
CONSTRAINT pk_busSchedule PRIMARY KEY (scheduleID),
CONSTRAINT fk_route_bs FOREIGN KEY (routeNo) REFERENCES route(routeNo),
CONSTRAINT fk_driver_bs FOREIGN KEY (driverID) REFERENCES driver(driverID),
CONSTRAINT fk_bm_bs FOREIGN KEY (busPlateNo) REFERENCES bus(busPlateNo)
);

CREATE TABLE transactionDetails(
 transactionID      CHAR(6)     NOT NULL,
 scheduleID         CHAR(6)     NOT NULL,
 childTicketQty     NUMBER(2)   DEFAULT 0,
 adultTicketQty     NUMBER(2)   DEFAULT 0,
 citizenTicketQty   NUMBER(2)   DEFAULT 0,
CONSTRAINT pk_transactionDetails PRIMARY KEY (transactionID,scheduleID),
CONSTRAINT fk1_transaction FOREIGN KEY (transactionID) REFERENCES transaction(transactionID),
CONSTRAINT fk2_transaction FOREIGN KEY (scheduleID) REFERENCES busSchedule(scheduleID)
); 
