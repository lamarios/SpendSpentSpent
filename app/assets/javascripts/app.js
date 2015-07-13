var HTTP_HEADERS = {
	transformRequest : function(obj) {
		var str = [];
		for ( var p in obj) {
			str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
		}
		return str.join("&");
	},
	headers : {
		'Content-Type' : 'application/x-www-form-urlencoded'
	}
};

var app = angular.module('ExpTrackerApp', [ 'angular-chartist', 'ngTouch' ]).run(function($rootScope, $http) {
	$rootScope.showSettings = false;
	$rootScope.animating = false;

	if ($('#right-column').is(':visible')) {
		$('#footer .page-marker i:nth-child(3)').addClass('active');
	}

	$rootScope.logout = function(callback) {
		if (typeof (Storage) !== "undefined") {
			localStorage.removeItem("token");
		}
		$http.defaults.headers.common.Authorization = '';

		$('login').show();
	};

	$rootScope.swipeLeft = function() {
		if (!$rootScope.animating) {
			$rootScope.animating = true;
			var columns = $('.column:visible');
			switch (columns.length) {
			case 1:
				$rootScope.oneColumnSwipe(columns, 'left');
				break;
			case 2:
				$rootScope.twoColumnsSwipe(columns, 'left');
				break;
			}
		}
	};

	$rootScope.swipeRight = function() {
		if (!$rootScope.animating) {
			$rootScope.animating = true;
			var columns = $('.column:visible');

			switch (columns.length) {
			case 1:
				$rootScope.oneColumnSwipe(columns, 'right');
				break;
			case 2:
				$rootScope.twoColumnsSwipe(columns, 'right');
				break;
			}
		}
	};

	$rootScope.oneColumnSwipe = function(column, direction) {
		var id = column.attr('id');

		var classToRemove = 'slideInLeft slideInRight slideOutLeft slideOutRight';

		var center = $('#center-column');
		var left = $('#left-column');
		var right = $('#right-column');

		var removed;

		$('.column').removeClass(classToRemove);

		switch (id) {
		case 'center-column':
			// moving away from center column
			if (direction === 'left') {
				// center.hide();
				// right.show();
				right.addClass('slideInRight active');
				center.addClass('slideOutLeft');
				$('#footer .page-marker i:nth-child(3)').addClass('active');
			} else {
				// center.hide();
				// left.show();
				left.addClass('slideInLeft active');
				center.addClass('slideOutRight');
				$('#footer .page-marker i:nth-child(1)').addClass('active');
			}

			removed = center;

			break;
		case 'left-column':
			if (direction === 'left') {
				// center.show();
				center.addClass('slideInRight active');
				left.addClass('slideOutLeft');
				$('#footer .page-marker i:nth-child(2)').addClass('active');
				removed = left;
			}
			break;
		case 'right-column':
			if (direction === 'right') {
				// center.show();
				center.addClass('slideInLeft active');
				right.addClass('slideOutRight');
				$('#footer .page-marker i:nth-child(2)').addClass('active');
				removed = right;
			}
			break;
		}

		setTimeout(function() {
			$('#footer .page-marker i').removeClass('active');
			removed.removeClass('active');
			$rootScope.animating = false;
		}, 500);

	};

	$rootScope.twoColumnsSwipe = function(columns, direction) {
		var showingColumn = '';

		// alert('2 column swipe');

		var center = $('#center-column');
		var left = $('#left-column');
		var right = $('#right-column');
		var classToRemove = 'slideInLeft slideInRight';

		//var removed;
		
		if (right.is(':visible') && direction === 'right') {
			right.hide();
			left.show();
			left.removeClass(classToRemove);
			left.addClass('slideInLeft');
			$('#footer .page-marker i:nth-child(1)').addClass('active');
			$('#footer .page-marker i:nth-child(3)').removeClass('active');
			

		} else if (left.is(':visible') && direction === 'left') {
			left.hide();
			right.show();
			right.removeClass(classToRemove);
			right.addClass('slideInRight');
			$('#footer .page-marker i:nth-child(3)').addClass('active');
			$('#footer .page-marker i:nth-child(1)').removeClass('active');
		}
		
		setTimeout(function() {
			//removed.removeClass('active');
			$rootScope.animating = false;
		}, 500);
	};

	// FastClick.attach(document.body);
});

app.config([ '$httpProvider', function($httpProvider) {
	// initialize get if not there
	if (!$httpProvider.defaults.headers.get) {
		$httpProvider.defaults.headers.get = {};
	}

	// Answer edited to include suggestions from comments
	// because previous version of code introduced browser-related errors

	// disable IE ajax request caching
	$httpProvider.defaults.headers.get['If-Modified-Since'] = 'Mon, 26 Jul 1997 05:00:00 GMT';
	// extra
	$httpProvider.defaults.headers.get['Cache-Control'] = 'no-cache';
	$httpProvider.defaults.headers.get.Pragma = 'no-cache';

	// showing loading when there's a request
	$httpProvider.interceptors.push(function($q) {
		var interceptor = {};
		interceptor.count = 0;

		interceptor.request = function(config) {
			if (interceptor.count === 0) {
				$("#http-activity").fadeIn('fast');
			}
			interceptor.count++;

			return config;
		};

		interceptor.response = function(response) {
			interceptor.count--;
			if (interceptor.count === 0) {
				$("#http-activity").fadeOut('fast');
			}

			return response;
		};

		interceptor.responseError = function(rejection) {
			interceptor.count--;
			if (interceptor.count === 0) {
				$("#http-activity").fadeOut('fast');
			}

			if (rejection.status === 401) {
				$('login').show();
			}
			return null;
		};

		return interceptor;
	});

} ]);
