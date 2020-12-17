function onDrillDown(item) {
    var restriction = new Ab.view.Restriction();
    restriction.addClause('property.pr_id', item.selectedChartData['property.pr_id']);
	    
	var panel = View.panels.get("chartDrillDown_property_report");
	
	panel.refresh(restriction);
	    
	panel.show(true);

	}

