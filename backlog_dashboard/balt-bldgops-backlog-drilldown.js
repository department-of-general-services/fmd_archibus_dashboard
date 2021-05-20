function onDrillDownBacklogByPrimaryType(item) {
	var panel = View.panels.get("chartDrillDown_backlog_by_primary_type");

	panel.addParameter('summaryValueForThisGroup', item.selectedChartData['wrhwr.primary_type']);
	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}


function onDrillDownBacklogBySupervisor(item) {
	var panel = View.panels.get("chartDrillDown_backlog_by_supervisor");

	panel.addParameter('summaryValueForThisGroup', item.selectedChartData['wrhwr.supervisor']);
	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}

function onDrillDownBacklogByStatus(item) {
	var panel = View.panels.get("chartDrillDown_backlog_by_status");

	console.log(item.selectedChartData['wrhwr.status'])

	if (item.selectedChartData['wrhwr.status'] === 'Assigned to Work Order') {
		brief_status = 'AA'
	}
	else if (item.selectedChartData['wrhwr.status'] === 'Completed') {
		brief_status = 'Com'
	}
	else if (item.selectedChartData['wrhwr.status'] === 'Closed') {
		brief_status = 'Clo'
	}
	else if (item.selectedChartData['wrhwr.status'] === 'Issued and In Process') {
		brief_status = 'I'
	}
	else if (item.selectedChartData['wrhwr.status'] === 'Stopped') {
		brief_status = 'S'
	}
	else {
		brief_status = item.selectedChartData['wrhwr.status']
	}

	panel.addParameter('summaryValueForThisGroup', brief_status);
	panel.refresh();

	panel.showInWindow({
		width: 800,
		height: 300
	});

}
