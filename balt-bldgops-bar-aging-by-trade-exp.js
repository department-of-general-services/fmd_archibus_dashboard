function onDrillDown(item) {
    var restriction = new Ab.view.Restriction();
    restriction.addClause('wrhwr.trade', item.selectedChartData['wrhwr.trade']);
    // console.log(item) 
    var panel = View.panels.get("chartDrillDown_aging_by_trade");

    panel.refresh(restriction);

    panel.showInWindow({
        width: 300, 
        height: 200
    });

}

