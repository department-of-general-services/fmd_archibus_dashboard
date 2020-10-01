SELECT wr_id,
    'Opened' as transaction_type,
    CONVERT(
        VARCHAR(7),
        DateAdd(month, DateDiff(month, 0, date_requested), 0),
        120
    ) AS calendar_month
FROM DGS_Archibus.afm.wrhwr
WHERE prob_type IS NOT NULL
    AND prob_type != 'TEST(DO NOT USE)'
    AND date_requested >= DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
UNION
SELECT wr_id,
    'Closed' as transaction_type,
    CONVERT(
        VARCHAR(7),
        DateAdd(month, DateDiff(month, 0, date_closed), 0),
        120
    ) AS calendar_month
FROM DGS_Archibus.afm.wrhwr
WHERE prob_type IS NOT NULL
    AND prob_type != 'TEST(DO NOT USE)'
    AND date_requested >= DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)