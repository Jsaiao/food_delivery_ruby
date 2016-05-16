$(window).bind('page:change', function () {
    //iCheck initializer
    $('input').iCheck({
        checkboxClass: 'icheckbox_square-blue',
        radioClass: 'iradio_square-red',
        increaseArea: '20%' // optional
    });

    $.AdminLTE.layout.fix();
    $.AdminLTE.pushMenu.activate("[data-toggle='offcanvas']");
    $.AdminLTE.controlSidebar.activate("[data-toggle='control-sidebar']");
    //$(ClientSideValidations.selectors.forms).enableClientSideValidations();
});

$('.dropdown-toggle').on('click', function () {
    if ($(this).parent().hasClass('open')) {
        $(this).parent().removeClass('open');
    } else {
        $(this).parent().addClass('open');
    }
});
