function onDrillDownCompleteToClose(item) {
	var panel = View.panels.get("chartDrillDown_complete_to_close");

	panel.addParameter('summaryValueForThisGroup', item.selectedChartData['wrhwr.calendar_month_complete']);

	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}


function onDrillDownByTimespan(item) {
	var panel = View.panels.get("chartDrillDown_metrics");

	panel.addParameter('summaryTimespan', item.selectedChartData['wrhwr.timespan']);
	panel.addParameter('summaryAction', item.selectedChartData['wrhwr.action']);

	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}

function onDrillDownByCalMonth(item) {
	var panel = View.panels.get("chartDrillDown_monthly_volume");

	panel.addParameter('summaryMonth', item.selectedChartData['wrhwr.calendar_month']);
	panel.addParameter('summaryAction', item.selectedChartData['wrhwr.action']);

	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}


function onDrillDownByTrade(item) {
	var panel = View.panels.get("chartDrillDown_aging_by_trade");

	panel.addParameter('summaryValueForThisGroup', item.selectedChartData['wrhwr.trade']);

	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}