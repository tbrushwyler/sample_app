function setUpChart() {
	setUpPieGraph();
	setUpLineGraph();
}

function setUpPieGraph() {
	var pieChart = document.getElementById("pie-chart");
	if (pieChart === undefined)
		return;

	var ctx = pieChart.getContext("2d");

	var data = [
		{ value: 30, color: "#2D4055" },
		{ value: 20, color: "#1A84B9" },
		{ value: 10, color: "#31DCB5" }
	];
	var options = {
		segmentShowStroke: false,
		animateScale: true
	};
	var myNewChart = new Chart(ctx).Pie(data, options);
}

function setUpLineGraph() {
	var lineGraph = document.getElementById("line-graph");
	if (lineGraph === undefined)
		return;

	var ctx = lineGraph.getContext("2d");

	var data = {
		labels : ["January","February","March","April","May","June","July"],
		datasets : [
			{
				fillColor : "rgba(45,64,85,0.8)",
				strokeColor : "rgba(45,64,85,1)",
				pointColor : "rgba(45,64,85,1)",
				pointStrokeColor : "#fff",
				data : [65,59,90,81,56,55,40]
			},
			{
				fillColor : "rgba(26,132,185,0.8)",
				strokeColor : "rgba(26,132,185,1)",
				pointColor : "rgba(26,132,185,1)",
				pointStrokeColor : "#fff",
				data : [28,48,40,19,96,27,100]
			},
			{
				fillColor : "rgba(49,220,181,0.8)",
				strokeColor : "rgba(49,220,181,1)",
				pointColor : "rgba(49,220,181,1)",
				pointStrokeColor : "#fff",
				data : [10,21,5,16,6,40,1]
			}
		]
	};
	var options = {
		segmentShowStroke: false,
		animateScale: true
	};
	var myNewChart = new Chart(ctx).Line(data);
}

function next() {
	$("#next").click();
}

function previous() {
	$("#previous").click();
}