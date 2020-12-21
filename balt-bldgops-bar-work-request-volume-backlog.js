function onDrillDown(item) {
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

