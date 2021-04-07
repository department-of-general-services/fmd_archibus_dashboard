USE [DGS_RAND_ARCHIBUS]
GO
	/****** Object:  View [afm].[dash_benchmarks]   Script Date: 1/11/2021 2:54:33 PM ******/
SET
	ANSI_NULLS ON
GO
SET
	QUOTED_IDENTIFIER ON
GO
	DROP VIEW if exists [afm].[dash_cmu_problem_types]
GO
	CREATE VIEW [afm].[dash_cmu_problem_types] AS (
		SELECT
			wr_id,
			r.status,
			r.description,
			r.supervisor,
			date_requested,
			date_completed,
			date_closed,
			prob_type AS problem_type,
			p.pm_group AS PM_type,
			CASE
				WHEN prob_type = 'AIR QUALITY' THEN 'AIR QUALITY'
				WHEN prob_type = 'APPLIANCE' THEN 'APPLIANCE'
				WHEN prob_type = 'BOILER' THEN 'HVAC'
				WHEN prob_type = 'BUILDING EXTERIOR' THEN 'BUILDING'
				WHEN prob_type IN ('CARPENTRY', 'WALL') THEN 'CARPENTRY'
				WHEN prob_type = 'CEILTILE' THEN 'CEILTILE'
				WHEN prob_type = 'CHILLERS' THEN 'HVAC'
				WHEN prob_type = 'COOLING TOWERS' THEN 'HVAC'
				WHEN prob_type IN ('DELIVERY', '_DELIVERY') THEN 'DELIVERY'
				WHEN prob_type = 'DESIGN/RENOVATION' THEN 'DESIGN'
				WHEN prob_type IN ('PEDESTRIAN DOORS', 'DOOR') THEN 'DOOR'
				WHEN prob_type = 'OVERHDDOOR' THEN 'OVERHDDOOR'
				WHEN prob_type = 'DUCT CLEANING' THEN 'DUCT CLEANING'
				WHEN (
					prob_type LIKE 'ELEC%'
					OR prob_type = 'OUTLETS'
				) THEN 'ELECTRICAL'
				WHEN prob_type = 'ELEVATOR' THEN 'ELEVATOR'
				WHEN (
					prob_type LIKE 'ENVIR%'
					OR prob_type = 'ASBESTOS'
				) THEN 'ENVIRONMENTAL'
				WHEN prob_type = 'FENCE_GATE' THEN 'FENCE GATE'
				WHEN prob_type = 'FIRE SUPPRESSION-PROTECTION' THEN 'FIRE SUPPRESSION-PROTECTION'
				WHEN prob_type = 'BATHROOM_FIXT' THEN 'BATHROOM'
				WHEN prob_type = 'FLOOR' THEN 'FLOOR'
				WHEN prob_type IN (
					'HVAC|INFRASTRUCTURE',
					'HVAC|HEATING OIL',
					'HVAC|INSPECTION',
					'HVAC|REPAIR',
					'HVAC|REPLACEMENT',
					'HVAC'
				) THEN 'HVAC'
				WHEN prob_type IN (
					'BUILDING INTERIOR INSPECTION',
					'BUILDING PM',
					'GENERATOR PM',
					'INSPECTION',
					'FUEL INSPECTION'
				) OR (prob_type = 'PREVENTIVE MAINT' AND p.pm_group IN (
				    'BASEMENT INSPECT', 
				    'BLDG INSPECTION', 
				    'ELEVATOR TEST', 
					'EXTERMINATION', 
					'FLOOR BUFFING',
					'FUEL TANK TEST',
					'GENERATOR TEST', 
					'KITCHEN PM',
					'SEMI ANNUAL',
					'UTILITY ROOMS'
				)) 
				THEN 'PREVENTIVE_GENERAL'
				WHEN prob_type = 'HVAC|PM'
				     OR (prob_type = 'PREVENTIVE MAINT' AND p.pm_group IN (
					'HEAT CHECK TEST',
					'HEATING LEVELS', 
					'HVAC INSPECTION',
					'HVAC FILTER CHAN'
				))
				THEN 'PREVENTIVE_HVAC'
				WHEN prob_type IN ('LAWN', 'LANDSCAPING') THEN 'LANDSCAPING'
				WHEN prob_type = 'LOCK' THEN 'LOCK'
				WHEN prob_type IN ('PAINT', 'PAINTING') THEN 'PAINTING'
				WHEN prob_type LIKE 'PLUMB%' THEN 'PLUMBING'
				WHEN (
					prob_type IN ('OTHER', 'RAMPS', 'STEPS', 'RAILSTAIRSRAMP')
					AND u.role_name LIKE 'GATEKEEPER%'
				) THEN 'OTHER-EXTERNAL'
				WHEN (
					prob_type IN ('OTHER', 'RAMPS', 'STEPS', 'RAILSTAIRSRAMP')
					AND u.role_name NOT LIKE 'GATEKEEPER%'
				) THEN 'OTHER-INTERNAL'
				WHEN prob_type = 'ROOF' THEN 'ROOF'
				WHEN prob_type LIKE 'SECURITY SYSTEMS%' THEN 'SECURITY SYTEMS'
				WHEN prob_type LIKE 'SERV/%' THEN 'SERVICE'
				WHEN prob_type = 'SNOW REMOVAL' THEN 'SNOW REMOVAL'
				WHEN prob_type = 'WINDOW' THEN 'WINDOW'
				ELSE 'SMALL_TYPES_DISCARD'
			END AS primary_type,
			u.role_name,
			b.name AS building_name,
			b.bl_id AS b_number,
			CASE
				WHEN datepart(mm, date_requested) >= 7 THEN datepart(yy, date_requested) + 1
				ELSE datepart(yy, date_requested)
			END AS 'fy_request',
			CASE
				WHEN datepart(mm, date_closed) >= 7 THEN datepart(yy, date_closed) + 1
				ELSE datepart(yy, date_closed)
			END AS 'fy_close'
		FROM
			afm.wrhwr r
			LEFT JOIN afm.afm_users u ON r.requestor = u.user_name
			LEFT JOIN afm.bl b ON r.bl_id = b.bl_id
			LEFT JOIN afm.pms p ON r.pms_id = p.pms_id
		WHERE
			prob_type IS NOT NULL
			--AND date_closed IS NOT NULL
			AND prob_type != 'TEST (DO NOT USE)'
	);

GO
	DROP VIEW if exists [afm].[dash_benchmarks]
GO
	CREATE VIEW [afm].[dash_benchmarks] AS (
		SELECT
			wr_id,
			status,
			description,
			supervisor,
			date_completed,
			date_requested,
			date_closed,
			fy_request,
			role_name,
			building_name,
			b_number,
			primary_type,
			problem_type,
			PM_type,
			CONVERT(
				VARCHAR(7),
				DateAdd(month, DateDiff(month, 0, date_requested), 0),
				120
			) AS calendar_month_request,
			CONVERT(
				VARCHAR(7),
				DateAdd(month, DateDiff(month, 0, date_closed), 0),
				120
			) AS calendar_month_close,
			DATEDIFF(day, date_requested, date_completed) AS days_to_completion,
			DATEDIFF(
				day,
				date_requested,
				DateAdd(year, - 2, getDate())
			) AS days_open,
			CASE
				WHEN primary_type IN (
					'BUILDING',
					'DELIVERY',
					'INSPECTION',
					'OTHER-INTERNAL',
					'LOCK'
				) THEN 7
				WHEN primary_type IN (
					'BATHROOM',
					'CEILTILE',
					'DOOR',
					'ELECTRICAL',
					'FIXTURES',
					'LANDSCAPING',
					'OTHER-EXTERNAL',
					'PLUMBING',
					'SERVICE'
				) THEN 14
				WHEN primary_type IN (
					'APPLIANCE',
					'CARPENTRY',
					'ELEVATOR',
					'PAINTING',
					'PREVENTIVE_HVAC', 
					'PREVENTIVE_GENERAL'
				) THEN 21
				WHEN primary_type IN ('HVAC', 'WINDOW') THEN 30
				WHEN primary_type IN (
					'AIR QUALITY',
					'ENVIRONMENTAL',
					'FENCE GATE',
					'FIRE SUPPRESSION-PROTECTION',
					'FLOOR',
					'OVERHDDOOR',
					'SECURITY SYSTEMS'
				) THEN 45
				WHEN primary_type IN ('DESIGN', 'ROOF', 'DUCT CLEANING') THEN 60
			END AS benchmark
		FROM
			afm.dash_cmu_problem_types
	);

GO