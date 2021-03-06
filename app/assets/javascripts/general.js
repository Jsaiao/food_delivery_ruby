angular.module('myApp', []);

$(window).bind('page:change', function () {

    $('form').enableClientSideValidations();

    //iCheck initializer
    $('input').iCheck({
        checkboxClass: 'icheckbox_square-blue',
        radioClass: 'iradio_square-red',
        increaseArea: '20%' // optional
    });

    $.AdminLTE.layout.fix();
    $.AdminLTE.pushMenu.activate("[data-toggle='offcanvas']");
    $.AdminLTE.controlSidebar.activate("[data-toggle='control-sidebar']");
    $(ClientSideValidations.selectors.forms).enableClientSideValidations();

    angular.bootstrap(document.body, ['myApp']);
});

$('.dropdown-toggle').on('click', function () {
    if ($(this).parent().hasClass('open')) {
        $(this).parent().removeClass('open');
    } else {
        $(this).parent().addClass('open');
    }
});
