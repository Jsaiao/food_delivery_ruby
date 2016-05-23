angular.module('myApp')
    .directive('onLastRepeat', function () {
        return function (scope, element, attrs) {
            if (scope.$last) setTimeout(function () {
                scope.$emit('onRepeatLast', element, attrs);
            }, 1);
        };
    })

    .controller('CartCtrl', function ($scope, $http) {
<<<<<<< a442bb92fbd9e3897757c48e538dcee9bc970191
=======

>>>>>>> Se modifica estructura de jquery a angular para gestionar un carrito
        $http({
            method: "GET",
            url: "/generate_cart_json"
        }).then(function mySucces(response) {
            $scope.entries = response.data;
<<<<<<< a442bb92fbd9e3897757c48e538dcee9bc970191
            if (response.data.length == 0){
                $('#order-button')[0].setAttribute("hidden", true);
            }
=======
>>>>>>> Se modifica estructura de jquery a angular para gestionar un carrito
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
<<<<<<< a442bb92fbd9e3897757c48e538dcee9bc970191
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
=======
            $http({
                method: "POST",
                url: '/one_less_product/' + arguments
            }).then(function mySucces(response) {
                var price = '#price-product-' + product;
                var subtotal = '#subtotal-product-' + product;
                var quantity = '#quantity-product-' + product;
                var total = 0;
                $(subtotal).html((Number($(subtotal).html()) - Number($(price).html())).toFixed(2));
                $(quantity).html((Number($(quantity).html())) - 1);
                $('.subtotal').each(function (index, value) {
                    total = total + Number($(this).html());
                });
                $('#total-price').html('$ ' + total.toFixed(2));
            });
>>>>>>> Se modifica estructura de jquery a angular para gestionar un carrito
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
<<<<<<< a442bb92fbd9e3897757c48e538dcee9bc970191
                if ($('.subtotal').length == 0){
                    $('#order-button')[0].setAttribute("hidden", true);
                }
=======
>>>>>>> Se modifica estructura de jquery a angular para gestionar un carrito
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
