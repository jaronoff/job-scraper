angular.module("JobScraper", [])

.directive("jobtitle", function() {
  return {
    restrict: "A",
    template: "<td><a href='{{job.url}}'>{{job.title}}</a></td>"
  }
})

.directive("jobdate", function() {
  return {
    restrict: "A",
    template: "<td>{{job.date}}</td>"
  }
})

.directive("joblocation", function() {
  return {
    restrict: "A",
    template: "<td>{{job.location}}</td>"
  }
})

.directive("jobtype", function() {
  return {
    restrict: "A",
    template: "<td>{{job.type}}</td>"
  }
})

.directive("jobdelete", function() {
    return {
      restrict: "A",
      template: "<button class='btn btn-danger'>Delete</button>",
      link: function(scope, element) {
        element.bind("click", function() {
          element.parent("tr").remove();
        })

      }
    }

  })

.controller('JobsCtrl', function($scope, $http) {
  $scope.jobs = {};

  $scope.working = "";

  $scope.alert ="";

  $scope.showJobFilter = false;

  $scope.searched = false;

  $scope.loading = false;

  $scope.getJobs = function(search_term) {
    if (typeof search_term !== 'undefined') {
      $scope.loading = true;

      $http.get('/jobs/' + encodeURI(search_term["$"])).
      success(function(data, status) {
        $scope.jobs = data

        $scope.searched = true;

        $scope.loading = false;
      }).
      error(function(data, status) {
        console.log("Something went wrong ");
      });
    }
  }
});

