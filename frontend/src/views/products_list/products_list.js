'use strict';

var _ = require('lodash');

angular.module('salesFront').controller('ProductsList', ['$scope', '$rootScope', 'Products' ,function ($scope, $rootScope, Products) {
  $scope.products = [];

  Products.getProducts(function(responce) {
    $scope.products = responce.products;
  });

}]);
