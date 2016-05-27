'use strict';

angular.module('salesFront').factory('Products', ['$resource', '$rootScope', function Products($resource, $rootScope) {
  var resource = $resource('/api/products/:id', {}, {
    index: {
      method: 'GET',
      params: {
        isArray: true
      }
    },
    show: {
      method: 'GET',
      params: {
        id: '@id'
      }
    },
    create: {
      method: 'POST'
    },
    update: {
      method: 'PUT'
    },
    destroy: {
      method: 'DELETE',
      params: {
        id: '@id'
      }
    }
  });

  return {
    getProducts: function(params) {
      return resource.index(params).$promise;
    },

    getProduct: function(params) {
      return resource.show(params).$promise;
    },

    createProduct: function(params) {
      return resource.create(params).$promise;
    },

    updateProduct: function(params) {
      return resource.update(params).$promise;
    },

    destroyProduct: function(params) {
      return resource.destroy(params).$promise;
    }
  };
}]);
