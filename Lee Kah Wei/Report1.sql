SET PAGESIZE 600
SET LINESIZE 1200

CREATE OR REPLACE VIEW TOTAL_TRANSACTION_PAYMENT AS
SELECT MEMBERID, SUM(TOTALPAYMENT) AS TOTAL_PAID, COUNT(TOTALPAYMENT) AS TRANSACTION_MADE
FROM TRANSACTION
GROUP BY MEMBERID
ORDER BY TOTAL_PAID DESC;

CREATE OR REPLACE PROCEDURE PRC_SUMMARY_RPT(V_NUMBER IN NUMBER) AS
TOTAL_PERCENTAGE_CONTRIBUTE NUMBER(7,2);
PERCENTAGE_CONTRIBUTE NUMBER(7,2);
PAYMENT NUMBER(10,2);
TRANSACTION_MADE NUMBER;
TOTAL_PAYMENT_RECEIVED NUMBER(10,2);
TOTAL_TRANSACTION_MADE NUMBER;

CURSOR TOP_MEMBER IS
	SELECT M.MEMBERID AS MEMBERID, MEMBERNAME AS NAME, TO_CHAR(MEMBERDOB, 'DD-Mon-YYYY') AS DOB, MEMBERSHIPPOINT AS POINT, T.TOTAL_PAID AS TOTALPAYMENT, T.TRANSACTION_MADE AS TRANSACTIONMADE
	FROM MEMBER M, TOTAL_TRANSACTION_PAYMENT T
	WHERE M.MEMBERID = T.MEMBERID AND ROWNUM <= V_NUMBER;

CURSOR TOTAL_SALES_YEAR IS
	SELECT SUM(TOTALPAYMENT) AS TOTAL_PAID, COUNT(*) AS TRANSACTION_MADE
	FROM TRANSACTION;

BEGIN
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE(rpad(chr(9),23)||' TOP ' || V_NUMBER ||  ' MEMBER OF ALL TIME');
DBMS_OUTPUT.PUT_LINE(rpad(chr(9),23)||'***************************');
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE(RPAD('-',80,'-'));
DBMS_OUTPUT.PUT_LINE(RPAD('MEMBER ID', 10, ' ') || RPAD('NAME', 20, ' ') || RPAD('DOB', 15, ' ') || RPAD('POINT', 7, ' ') || RPAD('Total', 12, ' ') || RPAD('Counter', 9, ' ') || RPAD('%', 5, ' '));
DBMS_OUTPUT.PUT_LINE(RPAD('-',80,'-'));
TOTAL_PAYMENT_RECEIVED := 0;
TOTAL_TRANSACTION_MADE := 0;

FOR MEMBER_REC IN TOP_MEMBER LOOP
	OPEN TOTAL_SALES_YEAR;
	LOOP
	FETCH TOTAL_SALES_YEAR INTO
		PAYMENT,
		TRANSACTION_MADE;
	EXIT WHEN (TOTAL_SALES_YEAR%NOTFOUND);
	TOTAL_PAYMENT_RECEIVED := TOTAL_PAYMENT_RECEIVED + MEMBER_REC.TOTALPAYMENT;
	TOTAL_TRANSACTION_MADE := TOTAL_TRANSACTION_MADE + MEMBER_REC.TRANSACTIONMADE;
	PERCENTAGE_CONTRIBUTE := (MEMBER_REC.TOTALPAYMENT / PAYMENT) * 100;
	TOTAL_PERCENTAGE_CONTRIBUTE := TOTAL_PERCENTAGE_CONTRIBUTE + PERCENTAGE_CONTRIBUTE;
	DBMS_OUTPUT.PUT_LINE(RPAD(MEMBER_REC.MEMBERID,10, ' ') || RPAD(MEMBER_REC.NAME, 20, ' ') || RPAD(MEMBER_REC.DOB, 15, ' ') || RPAD(MEMBER_REC.POINT, 7, ' ') || RPAD('RM ' ||TRIM(TO_CHAR(MEMBER_REC.TOTALPAYMENT,'99999D99')) , 12, ' ') || RPAD(MEMBER_REC.TRANSACTIONMADE, 9, ' ') || RPAD( '0' ||TRIM(TO_CHAR(PERCENTAGE_CONTRIBUTE,'999D99')) || '%', 5, ' '));

	END LOOP;
CLOSE TOTAL_SALES_YEAR;
END LOOP;

DBMS_OUTPUT.PUT_LINE(RPAD('-',80,'-'));
DBMS_OUTPUT.PUT_LINE(RPAD('TOTAL TRANSACTION VALUE: RM ',28,' ') || RPAD(TRIM(TO_CHAR(TOTAL_PAYMENT_RECEIVED ,'99999D99')), 10, ' '));
DBMS_OUTPUT.PUT_LINE(RPAD('TOTAL TRANSACTION MADE: ',24,' ') || RPAD(TOTAL_TRANSACTION_MADE, 10, ' '));
DBMS_OUTPUT.PUT_LINE(CHR(10)||LPAD('-END OF REPORT-',50,' '));
END;
/

ACCEPT TOTAL_NUMBER NUMBER PROMPT 'Enter TOTAL NUMBER:  '
EXEC PRC_SUMMARY_RPT(&TOTAL_NUMBER)