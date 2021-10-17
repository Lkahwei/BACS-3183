SET LINESIZE 250
SET PAGESIZE 100
CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES
TTITLE OFF
BTITLE OFF
REPFOOTER OFF

CREATE OR REPLACE VIEW FIND_CUSTOMER_SPENT AS
SELECT M.MEMBERID, TO_CHAR(PURCHASEDATE, 'YYYY') AS YEAR, SUM(totalPayment) as TOTALAMOUNTPAID, COUNT(TRANSACTIONID) AS TOTALTRANSACTIONMADE
FROM MEMBER M, TRANSACTION T
WHERE M.MEMBERID = T.MEMBERID
GROUP BY M.MEMBERID, TO_CHAR(PURCHASEDATE, 'YYYY');

COLUMN memberID			heading 'Member ID'			format a10
COLUMN memberGender		heading 'Gender'			format a8
COLUMN memberName		heading 'Name'				format a20
column memberPhoneNo		heading 'Phone No'			format a15
column TotalAmountPaid		heading 'Total Amount'			format $999,999,999.99
column TOTALTRANSACTIONMADE	heading 'Total Transaction Made'	format 999999

ACCEPT v_minimumAmount NUMBER FORMAT 99999.99  PROMPT 'Enter minimum amount : '

ACCEPT v_year NUMBER FORMAT 9999 PROMPT 'Enter year: '

ttitle 'CUSTOMER(S) WHO HAVE SPENT MORE THAN RM'&V_MINIMUMAMOUNT' AT YEAR '&V_YEAR'' skip 1-
'---------------------------------------------------------' skip 1-
left 'Page:' format 999 sql.pno skip 2
repfooter skip 1 center '---End of Report---'

compute sum label 'Total: ' OF TotalAmountPaid ON REPORT
compute sum label 'Total: ' OF TotalTransactionMade ON REPORT

BREAK ON REPORT

SELECT M.memberID as memberID, memberName, memberGender, memberPhoneNo, TOTALAMOUNTPAID, TOTALTRANSACTIONMADE
FROM MEMBER M, FIND_CUSTOMER_SPENT FP
WHERE M.MEMBERID = FP.MEMBERID AND FP.YEAR = &V_YEAR AND TOTALAMOUNTPAID >= &V_MINIMUMAMOUNT
ORDER BY TOTALAMOUNTPAID DESC;