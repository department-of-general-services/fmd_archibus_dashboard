function onDrillDownCMsByCalendarMonth(item) {
	var panel = View.panels.get("chartDrillDown_pct_cms_ontime");

	panel.addParameter('summaryValueForThisGroup', item.selectedChartData['wrhwr.calendar_month_complete']);
	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}
