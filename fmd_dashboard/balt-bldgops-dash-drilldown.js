function onDrillDownByTrade(item) {
	//var restriction = new Ab.view.Restriction();
	//restriction.addClause('wrhwr.trade', item.selectedChartData['wrhwr.trade']);

	var panel = View.panels.get("chartDrillDown_aging_by_trade");

	panel.addParameter('summaryValueForThisGroup', item.selectedChartData['wrhwr.trade']);

	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}


function onDrillDownByTimespan(item) {
	//var restriction = new Ab.view.Restriction();
	//restriction.addClause('wrhwr.trade', item.selectedChartData['wrhwr.trade']);

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
	//var restriction = new Ab.view.Restriction();
	//restriction.addClause('wrhwr.trade', item.selectedChartData['wrhwr.trade']);

	var panel = View.panels.get("chartDrillDown_monthly_volume");

	panel.addParameter('summaryMonth', item.selectedChartData['wrhwr.calendar_month']);
	panel.addParameter('summaryAction', item.selectedChartData['wrhwr.action']);

	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}
