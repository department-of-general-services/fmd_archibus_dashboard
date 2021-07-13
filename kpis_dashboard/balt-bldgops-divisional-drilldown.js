function onDrillDownCMsByCalendarMonth(item) {
	var panel = View.panels.get(" ");

	panel.addParameter('summaryValueForThisGroup', item.selectedChartData['wrhwr.calendar_month_complete']);
	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}
