USE [DGS_RAND_ARCHIBUS]
GO
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
			p.pm_group AS pm_group,
			CASE
				WHEN (po_number is null)
				OR (po_number = '0') THEN CAST(0 AS DECIMAL)
				ELSE CAST(1 AS DECIMAL)
			END AS 'is_vendor_work',
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
					'HVAC INFRASTRUCTURE',
					'HVAC|HEATING OIL',
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
				)
				OR (
					prob_type = 'PREVENTIVE MAINT'
					AND (
						p.pm_group IN (
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
						)
						OR p.pm_group IS NULL
					)
				) THEN 'PREVENTIVE_GENERAL'
				WHEN prob_type IN ('HVAC|PM', 'HVAC|INSPECTION')
				OR (
					prob_type = 'PREVENTIVE MAINT'
					AND p.pm_group IN (
						'HEAT CHECK TEST',
						'HEATING LEVELS',
						'HVAC INSPECTION',
						'HVAC FILTER CHAN'
					)
				) THEN 'PREVENTIVE_HVAC'
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
					AND (
						u.role_name NOT LIKE 'GATEKEEPER%'
						or u.role_name IS NULL
					)
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
				WHEN datepart(mm, date_completed) >= 7 THEN datepart(yy, date_requested) + 1
				ELSE datepart(yy, date_completed)
			END AS 'fy_complete',
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
			AND prob_type NOT IN ('TEST', 'TEST (DO NOT USE)', 'TEST(DO NOT USE)')
	);

GO
	DROP VIEW if exists [afm].[dash_benchmarks]
GO
	CREATE VIEW [afm].[dash_benchmarks] AS (
		SELECT
			*,
			CONVERT(
				VARCHAR(7),
				DateAdd(month, DateDiff(month, 0, date_requested), 0),
				120
			) AS calendar_month_request,
			CONVERT(
				VARCHAR(7),
				DateAdd(month, DateDiff(month, 0, date_completed), 0),
				120
			) AS calendar_month_complete,
			CONVERT(
				VARCHAR(7),
				DateAdd(month, DateDiff(month, 0, date_closed), 0),
				120
			) AS calendar_month_close,
			DATEDIFF(day, date_requested, date_completed) AS days_to_completion,
			DATEDIFF(
				day,
				date_requested,
				DateAdd(month, -1, getDate())
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
	DROP VIEW if exists [afm].[dash_kpis];

GO
	CREATE VIEW [afm].[dash_kpis] AS WITH catch_unfinished_but_late
	/*This query allows us to account for work that hasn't been 
	 completed yet, but is already past the benchmark.*/
	AS (
		SELECT
			*,
			CASE
				WHEN (
					date_completed IS NULL
					AND days_open > benchmark
				) THEN CAST(1 AS DECIMAL)
				ELSE CAST(0 AS DECIMAL)
			END AS unfinished_but_late
		FROM
			[afm].[dash_benchmarks]
	)
SELECT
	*,
	CASE
		WHEN days_to_completion <= benchmark THEN CAST(1 AS DECIMAL)
		WHEN unfinished_but_late = 1 THEN CAST(0 AS DECIMAL)
		ELSE CAST(0 AS DECIMAL)
	END AS is_on_time,
	CASE
		WHEN primary_type IN ('PREVENTIVE_HVAC') THEN CAST(1 AS DECIMAL)
		ELSE CAST(0 AS DECIMAL)
	END AS is_ratio_pm,
	CASE
		WHEN primary_type IN ('HVAC') THEN CAST(1 AS DECIMAL)
		ELSE CAST(0 AS DECIMAL)
	END AS is_ratio_cm,
	CASE
		WHEN primary_type IN ('PREVENTIVE_HVAC', 'PREVENTIVE_GENERAL') THEN CAST(1 AS DECIMAL)
		ELSE CAST(0 AS DECIMAL)
	END AS is_any_pm
FROM
	catch_unfinished_but_late c
WHERE
	date_closed >= DateAdd(month, -13, DateAdd(month, -1, getDate()))
	AND date_closed < dateAdd(
		MS,
		-3,
		DateAdd(
			MM,
			DateDiff(MM, 0, DateAdd(month, -1, getDate())),
			0
		)
	)
	/*For the KPIs table, we're only interested in jobs that we
	 can label as on time or not. So we must throw away the jobs 
	 that are still in process and could be on time.*/
	AND (
		date_completed IS NOT NULL
		OR unfinished_but_late = 1
	);

GO
	DROP VIEW if exists [afm].[dash_cms_on_time_by_close];

GO
	CREATE VIEW [afm].[dash_cms_on_time_by_close] AS (
		SELECT
			calendar_month_close,
			SUM(is_on_time) * 100 / COUNT(wr_id) as percent_ontime,
			CAST(COUNT(wr_id) AS DECIMAL) as wr_volume,
			SUM(is_on_time) as count_on_time
		FROM
			[afm].[dash_kpis]
		WHERE
			is_any_pm = 0
			AND primary_type != 'SMALL_TYPES_DISCARD'
		GROUP BY
			calendar_month_close
	);

GO
	DROP VIEW if exists [afm].[dash_pms_on_time_by_close];

GO
	CREATE VIEW [afm].[dash_pms_on_time_by_close] AS (
		SELECT
			calendar_month_close,
			SUM(is_on_time) * 100 / COUNT(wr_id) as percent_ontime,
			CAST(COUNT(wr_id) AS DECIMAL) as wr_volume,
			SUM(is_on_time) as count_on_time
		FROM
			[afm].[dash_kpis]
		WHERE
			is_any_pm = 1
		GROUP BY
			calendar_month_close
	);

GO
	DROP VIEW if exists [afm].[dash_pm_cm_ratio_by_close];

GO
	CREATE VIEW [afm].[dash_pm_cm_ratio_by_close] AS (
		SELECT
			calendar_month_close,
			CAST(SUM(is_ratio_pm) * 100 AS DECIMAL) / CAST(SUM(is_ratio_cm) AS DECIMAL) AS pm_cm_ratio,
			SUM(is_ratio_pm) AS pm_volume,
			SUM(is_ratio_cm) AS cm_volume,
			(SUM(is_ratio_cm) + SUM(is_ratio_pm)) AS pm_cm_volume
		FROM
			[afm].[dash_kpis]
		GROUP BY
			calendar_month_close
	);

GO
	DROP VIEW if exists [afm].[dash_backlog];

GO
	CREATE VIEW [afm].[dash_backlog] AS (
		SELECT
			*,
			/* This trick allows us to still filter by
			 empty values, which isn't possible when they remain
			 raw nulls. */
			CASE
				WHEN (supervisor IS NULL) THEN 'NULL'
				ELSE supervisor
			END AS supervisor_with_nulls
		FROM
			[afm].[dash_benchmarks]
		WHERE
			days_open > 30
			AND status not in ('Clo', 'Can', 'Rej', 'R')
	)
GO
	DROP VIEW if exists [afm].[dash_backlog_by_month];

GO
	CREATE VIEW [afm].[dash_backlog_by_month] AS (
		SELECT
			CAST(COALESCE(opened.year, closed.year) AS VARCHAR(4)) + '-' + RIGHT(
				'00' + CAST(
					COALESCE(opened.month, closed.month) AS VARCHAR(2)
				),
				2
			) AS calendar_month,
			CONVERT(
				DATE,
				CAST(COALESCE(opened.year, closed.year) AS VARCHAR(4)) + '-' + RIGHT(
					'00' + CAST(
						COALESCE(opened.month, closed.month) AS VARCHAR(2)
					),
					2
				) + '-01'
			) AS month_start,
			COALESCE(opened.year, closed.year) AS year,
			COALESCE(opened.month, closed.month) AS month,
			COALESCE(opened.wr_volume, 0) AS requests_opened,
			COALESCE(closed.wr_volume, 0) AS requests_closed,
			SUM(
				COALESCE(opened.wr_volume, 0) - coalesce(closed.wr_volume, 0)
			) OVER (
				ORDER BY
					COALESCE(opened.year, closed.year),
					COALESCE(opened.month, closed.month)
			) AS backlog
		FROM
			(
				SELECT
					YEAR(date_requested) AS year,
					MONTH(date_requested) AS month,
					COUNT(wr_id) AS wr_volume
				FROM
					afm.dash_benchmarks
				WHERE
					date_requested IS NOT NULL
					AND status NOT IN ('Can', 'Rej', 'R')
				GROUP BY
					YEAR(date_requested),
					MONTH(date_requested)
			) opened FULL
			OUTER JOIN (
				SELECT
					YEAR(date_closed) AS year,
					MONTH(date_closed) AS month,
					COUNT(wr_id) AS wr_volume
				FROM
					afm.wrhwr
				WHERE
					status = 'Clo'
				GROUP BY
					YEAR(date_closed),
					MONTH(date_closed)
			) closed ON opened.year = closed.year
			AND opened.month = closed.month
	);