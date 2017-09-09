function HistoryService($http) {
	var historyService = {};

	historyService.list = [];
	historyService.type = 'Monthly';

	historyService.refresh = function(callback) {
		while (this.list.length > 0) {
			this.list.pop();
		}

		var graphOptions = {
			width : '100%',
			height : '200px',
			low : 0,
			showArea : true,
			lineSmooth : Chartist.Interpolation.none()
		};

		var url = '/API/History/' + this.type + '/5';
		console.log('Calling ' + url);

		var maxValue = "";

		var parent = this;
		$http.get(url).success(function(data) {

			console.log('History:');
			console.log(data);
			angular.forEach(data, function(value, key) {

				var labels = [];
				var series = [];
				var percentageOfLast = 100;
				var lastvalue = 0;
				angular.forEach(value, function(serie, label) {
					if (key == 'all') {
						maxValue = serie;
					} else {
						percentageOfLast = Math.ceil((serie / maxValue) * 100);
					}

					lastvalue = serie;

					if (label != 'category') {
						labels.push(label);
						series.push(serie);
					}
				});

				var graphObject = {
					labels : labels,
					series : [ {
						data : series
					} ]
				};

				var object = {
					category : key,
					data : graphObject,
					options : graphOptions,
					percentage : percentageOfLast,
					lastValue : lastvalue
				};

				parent.list.push(object);
			});
			console.log(parent.list);
			if (callback !== undefined) {
				callback(data);
			}
		});
	};

	return historyService;
}