USE [DGS_RAND_ARCHIBUS]
GO

/****** Object:  View [afm].[dash_benchmarks]   Script Date: 1/11/2021 2:54:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP VIEW if exists [afm].[dash_benchmarks]
GO 

CREATE VIEW [afm].[dash_benchmarks]
AS 
(SELECT wr_id,
	STATUS,
	fy_request,
	CONVERT(VARCHAR(7), DateAdd(month, DateDiff(month, 0, date_requested), 0), 120) AS calendar_month_request,
	CONVERT(VARCHAR(7), DateAdd(month, DateDiff(month, 0, date_closed), 0), 120) AS calendar_month_close,
	DATEDIFF(day, date_requested, date_completed) AS days_to_completion,
	DATEDIFF(day, date_requested, DateAdd(year, - 2, getDate())) AS days_open,
	primary_type,
	date_completed,
	CASE 
		WHEN primary_type IN ('BUILDING', 'DELIVERY', 'INSPECTION', 'OTHER-INTERNAL', 'LOCK')
			THEN 7
		WHEN primary_type IN ('BATHROOM', 'CEILTILE', 'DOOR', 'ELECTRICAL', 'FIXTURES', 'LANDSCAPING', 'OTHER-EXTERNAL', 'PLUMBING', 'SERVICE')
			THEN 14
		WHEN primary_type IN ('APPLIANCE', 'CARPENTRY', 'ELEVATOR', 'PAINTING', 'PREVENTIVE')
			THEN 21
		WHEN primary_type IN ('HVAC', 'WINDOW')
			THEN 30
		WHEN primary_type IN ('AIR QUALITY', 'ENVIRONMENTAL', 'FENCE GATE', 'FIRE SUPPRESSION-PROTECTION', 'FLOOR', 'OVERHDDOOR', 'SECURITY SYSTEMS')
			THEN 45
		WHEN primary_type IN ('DESIGN', 'ROOF', 'DUCT CLEANING')
			THEN 60
		END AS benchmark
FROM afm.dash_cmu_problem_types);

GO