/*
function onDrillDown(item) {
	var restriction = new Ab.view.Restriction();
	var panel = View.panels.get("chartOneValMultCriteria_chart");
	panel.addParameter('summaryValueForThisGroup', item.selectedChartData['bl.site_id']);
		
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
*/


function onDrillDown(item) {
    //var restriction = new Ab.view.Restriction();
    //restriction.addClause('bl.site_id', item.selectedChartData['bl.site_id']);
	    
	//var panel = View.panels.get("chartDrillDown_building_report");
	console.log("Hello, world.")
	//panel.addParameter('summaryValueForThisGroup', item.selectedChartData['bl.site_id']);
	
	//panel.refresh();
	    
	//panel.show(true);

	}
