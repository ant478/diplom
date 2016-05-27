'use strict';

var angular = require('angular');
require('angular-route');
require('angular-resource');
require('angular-cookies');
var config = require('./config/config');

function appConfig($routeProvider, $httpProvider) {
  $routeProvider
    .when('/', {
      template: require('./views/products_list/products_list.html'),
      controller: 'ProductsList'
    })
    .when('/users', {
      template: require('./views/users_list/users_list.html'),
      controller: 'UsersListCtrl'
    })
    .when('/users/new', {
      template: require('./views/users_new/users_new.html'),
      controller: 'UsersNewCtrl'
    })
    .when('/users/login', {
      template: require('./views/users_login/users_login.html'),
      controller: 'UsersLoginCtrl'
    })
    .when('/products/new', {
      template: require('./views/products_new/products_new.html'),
      controller: 'ProductsNewCtrl'
    })
    .otherwise({
      redirectTo: '/'
    });

  $httpProvider.interceptors.push('errorInterceptor');

  $httpProvider.interceptors.push(function($q, $cookies) {
    return {
      'request': function(config) {
        config.headers['auth-token'] = $cookies.get('auth-token');
        return config;
      }
    };
  });
}

appConfig.$inject = ['$routeProvider', '$httpProvider'];

function appRun ($rootScope, Categories) {
  if (!$rootScope.categories) {
    Categories.getCategories({category: {}}).then(function(responce) {
      $rootScope.categories = responce.categories;
    });
  };

  if (!$rootScope.currencies) {
    Categories.getCategories({category: {}}).then(function(responce) {
      $rootScope.currencies = responce.currencies;
    });
  }
}

appRun.$inject = ['$rootScope', 'Categories'];

var app = angular
  .module('salesFront', [
    'ngRoute',
    'ngResource',
    'ngCookies'
  ])
  .config(appConfig)
  .run(appRun);

require('./services/users');
require('./services/products');
require('./services/sessions');
require('./services/categories');
require('./services/deals');
require('./services/transactions');
require('./services/comments');
require('./errorIntercepter');

require('./views/products_list/products_list.js');
require('./views/users_list/users_list.js');
require('./views/users_new/users_new.js');
require('./views/users_login/users_login.js');
require('./views/products_new/products_new.js');
