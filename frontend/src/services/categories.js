'use strict';

angular.module('salesFront').factory('Categories', ['$resource', '$rootScope', function Categories($resource, $rootScope) {
  var resource = $resource('/api/categories/:id', {}, {
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
    getCategories: function(params) {
      return resource.index(params).$promise;
    },

    getCategory: function(params) {
      return resource.show(params).$promise;
    },

    createCategory: function(params) {
      return resource.create(params).$promise;
    },

    updateCategory: function(params) {
      return resource.update(params).$promise;
    },

    destroyCategory: function(params) {
      return resource.destroy(params).$promise;
    }
  };
}]);
