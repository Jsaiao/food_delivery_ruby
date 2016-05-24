$(window).bind('scroll', function() {
    var url;
    if (window.pagination_loading) {
        return;
    }
    url = $('.pagination .next_page').attr('href');
    if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 150) {
        window.pagination_loading = true;
        if (url.includes('media')){
            $('.pagination').css("visibility", 'visible').html('<i class="fa fa-circle-o-notch fa-spin" title="' + 'Processing...' +
                '"></i> ' + 'Processing...');
        } else {
            $('.logbook-loading-page').html('<i class="fa fa-circle-o-notch fa-spin" style="margin-top:-30px;color:#666!important;"></i>');
        }
        return $.getScript(url).always(function() {
            return window.pagination_loading = false;
        });
    }
});
