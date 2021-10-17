SET LINESIZE 1200
SET PAGESIZE 600
CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES
TTITLE OFF
BTITLE OFF
REPFOOTER OFF

COLUMN YEAR			heading 'Year'			format a8
column TotalChildQty		heading 'Children Ticket'	format 999999
column TotalChildSales		heading 'Children Sales'	format $999,999,999.99
column TotalAdultQty		heading 'Adult Ticket'		format 999999
column TotalAdultSales		heading 'Adult Sales'		format $999,999,999.99
column TotalCitizenQty		heading 'Citizen Ticket'	format 999999
column TotalCitizenSales	heading 'Citizen Sales'		format $999,999,999.99


ttitle ' Yearly Comparison of Sales for Children, Adult, Citizen' skip 1-
'---------------------------------------------------------' skip 1-
left 'Page:' format 999 sql.pno skip 2
repfooter skip 1 center '---End of Report---'

compute sum label 'Total: ' OF TotalCitizenSales ON REPORT
compute sum label 'Total: ' OF TotalAdultSales ON REPORT
compute sum label 'Total: ' OF TotalChildSales ON REPORT
compute sum label 'Total: ' OF TotalChildQty ON REPORT
compute sum label 'Total: ' OF TotalAdultQty ON REPORT
compute sum label 'Total: ' OF TotalCitizenQty ON REPORT
BREAK ON REPORT

Select TO_CHAR(departureDate, 'YYYY') as YEAR, SUM(childTicketQty) as TotalChildQty, SUM(childTicketQty * childPrice) as TotalChildSales, SUM(adultTicketQty) as TotalAdultQty, SUM(adultTicketQty * adultPrice) as TotalAdultSales, SUM(citizenTicketQty) as TotalCitizenQty, SUM(citizenTicketQty * seniorCitizenPrice) as TotalCitizenSales
FROM BUSSCHEDULE BS, TRANSACTIONDETAILS TD, TICKETPRICE TP
WHERE BS.scheduleID = TD.scheduleID AND BS.routeNo = TP.routeNo
group by TO_CHAR(departureDate, 'YYYY')
order by 1;