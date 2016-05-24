angular.module('myApp')
    .directive('onLastRepeat', function () {
        return function (scope, element, attrs) {
            if (scope.$last) setTimeout(function () {
                scope.$emit('onRepeatLast', element, attrs);
            }, 1);
        };
    })

    .controller('CartCtrl', function ($scope, $http) {
        $http({
            method: "GET",
            url: "/generate_cart_json"
        }).then(function mySucces(response) {
            $scope.entries = response.data;
            if (response.data.length == 0) {
                $('#order-button')[0].setAttribute("hidden", true);
            }
        });

        $scope.addProduct = function (arguments) {
            var product = arguments;
            $http({
                method: "POST",
                url: '/add_product/' + arguments
            }).then(function mySucces(response) {
                var price = '#price-product-' + product;
                var subtotal = '#subtotal-product-' + product;
                var quantity = '#quantity-product-' + product;
                var total = 0;
                $(subtotal).html((Number($(price).html()) + Number($(subtotal).html())).toFixed(2));
                $(quantity).html((Number($(quantity).html())) + 1);
                $('.subtotal').each(function (index, value) {
                    total = total + Number($(this).html());
                });
                $('#total-price').html('$ ' + total.toFixed(2));

            });
        };

        $scope.removeProduct = function (arguments) {
            var product = arguments;
            var quantity = '#quantity-product-' + product;
            if (Number($(quantity).html()) != 1) {
                $http({
                    method: "POST",
                    url: '/one_less_product/' + arguments
                }).then(function mySucces(response) {
                    var price = '#price-product-' + product;
                    var subtotal = '#subtotal-product-' + product;
                    var total = 0;
                    $(subtotal).html((Number($(subtotal).html()) - Number($(price).html())).toFixed(2));
                    $(quantity).html((Number($(quantity).html())) - 1);
                    $('.subtotal').each(function (index, value) {
                        total = total + Number($(this).html());
                    });
                    $('#total-price').html('$ ' + total.toFixed(2));
                });
            }
        };

        $scope.deleteProductFromCart = function (arguments) {
            var product = arguments;
            $http({
                method: "POST",
                url: '/delete_product_from_cart/' + arguments
            }).then(function mySucces(response) {
                var cart = '#cart-product-' + product;
                $(cart).remove();
                var total = 0;
                $('.subtotal').each(function (index, value) {
                    total = total + Number($(this).html());
                });
                $('#total-price').html('$ ' + total.toFixed(2));
                if ($('.subtotal').length == 0) {
                    $('#order-button')[0].setAttribute("hidden", true);
                }
            });
        };

        $scope.$on('onRepeatLast', function (scope, element, attrs) {
            var total = 0;
            $('.subtotal').each(function (index, value) {
                total = total + Number($(this).html());
            });
            $('#total-price').html('$ ' + total.toFixed(2));
        });

    });
