'use strict';

angular.module('salesFront').controller('ProductsNewCtrl', ['$scope', 'Products', '$location', function ($scope, Products, $location) {
  $scope.newProduct = {};
  $scope.new_product_success_message = '';
  $scope.new_product_error_message = '';

  $scope.createNewProduct = function(newProduct) {
    Products.createProduct({product: newProduct}).then(function(newProduct) {
      $scope.new_product_success_message = 'Product created.';
      $scope.new_product_error_message = '';
    }).catch(function(error) {
      $scope.new_product_error_message = 'Product was not created.';
      $scope.new_product_success_message = '';
    });
  };
}]);
