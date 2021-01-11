USE [DGS_RAND_ARCHIBUS]
GO

/****** Object:  View [afm].[dash_cmu_problem_types]    Script Date: 1/11/2021 2:35:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [afm].[dash_cmu_problem_types]
AS 
(SELECT wr_id,
	STATUS,
	CASE 
		WHEN prob_type = 'AIR QUALITY'
			THEN 'AIR QUALITY'
		WHEN prob_type = 'APPLIANCE'
			THEN 'APPLIANCE'
		WHEN prob_type = 'BOILER'
			THEN 'HVAC'
		WHEN prob_type = 'BUILDING EXTERIOR'
			THEN 'BUILDING'
		WHEN prob_type IN ('CARPENTRY', 'WALL')
			THEN 'CARPENTRY'
		WHEN prob_type = 'CEILTILE'
			THEN 'CEILTILE'
		WHEN prob_type = 'CHILLERS'
			THEN 'HVAC'
		WHEN prob_type = 'COOLING TOWERS'
			THEN 'HVAC'
		WHEN prob_type IN ('DELIVERY', '_DELIVERY')
			THEN 'DELIVERY'
		WHEN prob_type = 'DESIGN/RENOVATION'
			THEN 'DESIGN'
		WHEN prob_type IN ('PEDESTRIAN DOORS', 'DOOR')
			THEN 'DOOR'
		WHEN prob_type = 'OVERHDDOOR'
			THEN 'OVERHDDOOR'
		WHEN prob_type = 'DUCT CLEANING'
			THEN 'DUCT CLEANING'
		WHEN (prob_type LIKE 'ELEC%' OR prob_type = 'OUTLETS')
			THEN 'ELECTRICAL'
		WHEN prob_type = 'ELEVATOR'
			THEN 'ELEVATOR'
		WHEN (prob_type LIKE 'ENVIR%' OR prob_type = 'ASBESTOS')
			THEN 'ENVIRONMENTAL'
		WHEN prob_type = 'FENCE_GATE'
			THEN 'FENCE GATE'
		WHEN prob_type = 'FIRE SUPPRESSION-PROTECTION'
			THEN 'FIRE SUPPRESSION-PROTECTION'
		WHEN prob_type = 'BATHROOM_FIXT'
			THEN 'BATHROOM'
		WHEN prob_type = 'FLOOR'
			THEN 'FLOOR'
		WHEN prob_type IN ('HVAC|INFRASTRUCTURE', 'HVAC|HEATING OIL', 'HVAC|INSPECTION', 'HVAC|REPAIR', 'HVAC|REPLACEMENT', 'HVAC')
			THEN 'HVAC'
		WHEN prob_type IN ('BUILDING INTERIOR INSPECTION', 'BUILDING PM', 'GENERATOR PM', 'HVAC|PM', 'PREVENTIVE MAINT', 'INSPECTION', 'FUEL INSPECTION')
			THEN 'PREVENTIVE'
		WHEN prob_type IN ('LAWN', 'LANDSCAPING')
			THEN 'LANDSCAPING'
		WHEN prob_type = 'LOCK'
			THEN 'LOCK'
		WHEN prob_type IN ('PAINT', 'PAINTING')
			THEN 'PAINTING'
		WHEN prob_type LIKE 'PLUMB%'
			THEN 'PLUMBING'
		WHEN (prob_type IN ('OTHER', 'RAMPS', 'STEPS', 'RAILSTAIRSRAMP') AND u.role_name LIKE 'GATEKEEPER%')
			THEN 'OTHER-EXTERNAL'
		WHEN (prob_type IN ('OTHER', 'RAMPS', 'STEPS', 'RAILSTAIRSRAMP') AND u.role_name NOT LIKE 'GATEKEEPER%')
			THEN 'OTHER-INTERNAL'
		WHEN prob_type = 'ROOF'
			THEN 'ROOF'
		WHEN prob_type LIKE 'SECURITY SYSTEMS%'
			THEN 'SECURITY SYTEMS'
		WHEN prob_type LIKE 'SERV/%'
			THEN 'SERVICE'
		WHEN prob_type = 'SNOW REMOVAL'
			THEN 'SNOW REMOVAL'
		WHEN prob_type = 'WINDOW'
			THEN 'WINDOW'
		ELSE 'SMALL_TYPES_DISCARD'
		END AS primary_type,
	prob_type AS problem_type,
	date_requested,
	date_completed,
	date_closed,
	u.role_name,
	CASE 
		WHEN datepart(mm, date_requested) >= 7
			THEN datepart(yy, date_requested) + 1
		ELSE datepart(yy, date_requested)
		END AS 'fy_request',
	CASE 
		WHEN datepart(mm, date_closed) >= 7
			THEN datepart(yy, date_closed) + 1
		ELSE datepart(yy, date_closed)
		END AS 'fy_close'
FROM afm.wrhwr r
LEFT JOIN afm.afm_users u ON r.requestor = u.user_name
WHERE prob_type IS NOT NULL AND date_closed IS NOT NULL AND prob_type != 'TEST (DO NOT USE)' AND date_requested >= DateAdd(month, - 13, DateAdd(year, - 2, getDate())) AND date_requested < dateAdd(MS, - 3, DateAdd(MM, DateDiff(MM, 0, DateAdd(year, - 2, getDate())), 0)));
									
GO