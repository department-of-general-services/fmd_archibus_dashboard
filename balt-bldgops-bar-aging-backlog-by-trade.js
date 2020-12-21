function onDrillDown(item) {
    //var restriction = new Ab.view.Restriction();
    //restriction.addClause('wrhwr.trade', item.selectedChartData['wrhwr.trade']);
    
    var panel = View.panels.get("chartDrillDown_metrics");

    panel.addParameter('summaryValueForThisGroup', item.selectedChartData['wrhwr.timespan']);

	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}

