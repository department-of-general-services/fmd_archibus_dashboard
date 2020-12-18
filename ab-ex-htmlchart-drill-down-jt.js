function onDrillDown(item) {
    var restriction = new Ab.view.Restriction();
    restriction.addClause('bl.bl_id', item.selectedChartData['bl.bl_id']);
	    
	var panel = View.panels.get("chartDrillDown_building_report");
	
	panel.refresh(restriction);
	    
	panel.show(true);

	}

