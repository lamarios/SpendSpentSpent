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

var app = angular.module('ExpTrackerApp', [ 'angular-chartist', '720kb.datepicker', 'ngTouch' ]).run(function($rootScope) {

	if($('#right-column').is(':visible')){
		$('#footer .page-marker i:nth-child(3)').addClass('active');
	}
	
	$rootScope.swipeLeft = function() {
		var columns = $('.column:visible');
		switch (columns.length) {
		case 1:
			$rootScope.oneColumnSwipe(columns, 'left');
			break;
		case 2:
			$rootScope.twoColumnsSwipe(columns, 'left');
			break;
		}

	};

	
	$rootScope.swipeRight = function() {
		var columns = $('.column:visible');

		switch (columns.length) {
		case 1:
			$rootScope.oneColumnSwipe(columns, 'right');
			break;
		case 2:
			$rootScope.twoColumnsSwipe(columns, 'right');
			break;
		}
	};

	$rootScope.oneColumnSwipe = function(column, direction) {
		var id = column.attr('id');
		
		var classToRemove = 'slideInLeft slideInRight';
		
		var center = $('#center-column');
		var left = $('#left-column');
		var right = $('#right-column');
		
		$('#footer .page-marker i').removeClass('active');
		
		switch (id) {
		case 'center-column':
			//moving away from center column
			if(direction ==='left'){
				center.hide();
				right.show();
				right.addClass('slideInRight');
				$('#footer .page-marker i:nth-child(3)').addClass('active');
			}else{
				center.hide();
				left.show();
				left.addClass('slideInLeft');
				$('#footer .page-marker i:nth-child(1)').addClass('active');
			}
			
			break;
		case 'left-column':
			if(direction ==='left'){
				left.hide();
				center.removeClass(classToRemove);
				center.show();
				center.addClass('slideInRight');
				$('#footer .page-marker i:nth-child(2)').addClass('active');
			}
			break;
		case 'right-column':
			if(direction ==='right'){
				right.hide();
				center.removeClass(classToRemove);
				center.show();
				$('#footer .page-marker i:nth-child(2)').addClass('active');
				center.addClass('slideInLeft');
			}
			break;
		}
	};

	$rootScope.twoColumnsSwipe = function(columns, direction) {
		var showingColumn = '';
		
		//alert('2 column swipe');
		
		var center = $('#center-column');
		var left = $('#left-column');
		var right = $('#right-column');
		var classToRemove = 'slideInLeft slideInRight';

		if(right.is(':visible') && direction === 'right'){
			right.hide();
			left.show();
			left.removeClass(classToRemove);
			left.addClass('slideInLeft');
			$('#footer .page-marker i:nth-child(1)').addClass('active');
			$('#footer .page-marker i:nth-child(3)').removeClass('active');

		}else if(left.is(':visible') && direction === 'left'){
			left.hide();
			right.show();
			right.removeClass(classToRemove);
			right.addClass('slideInRight');
			$('#footer .page-marker i:nth-child(3)').addClass('active');
			$('#footer .page-marker i:nth-child(1)').removeClass('active');
		}
		
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
} ]);
