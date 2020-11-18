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

function test(item) {
	var restriction = new Ab.view.Restriction();
	var panel = View.panels.get("extDrillDownReportFrom2dChart_report");
	panel.addParameter('summaryValueForThisGroup', item.selectedChartData['afm_cal_dates.month']);
		
	for(var cat in item.selectedChartData){
		if(typeof cat != undefined && item.selectedChartData[cat] == item.selectedChartData.values.value){
			panel.addParameter('restriction2Ctry', cat);
			break;
		}
	}
		
	panel.refresh();
    
	panel.showInWindow({
	            width: 300, 
	            height: 200
	        });
}
