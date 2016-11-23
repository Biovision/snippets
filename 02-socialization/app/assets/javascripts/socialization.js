'use strict';

$(function () {
    var $container = $('.follow-user-buttons');
    var url = $container.data('url');

    $container.find('.follow').on('click', function () {
        var $follow = $(this).parent().find('.follow');
        var $unfollow = $(this).parent().find('.unfollow');

        $.ajax(url, {
            method: 'put',
            success: function (response) {
                $follow.addClass('hidden');
                $unfollow.removeClass('hidden');
            }
        }).fail(handle_ajax_failure);
    });

    $container.find('.unfollow').on('click', function () {
        var $follow = $(this).parent().find('.follow');
        var $unfollow = $(this).parent().find('.unfollow');

        $.ajax(url, {
            method: 'delete',
            success: function (response) {
                $follow.removeClass('hidden');
                $unfollow.addClass('hidden');
            }
        }).fail(handle_ajax_failure);
    });
});
