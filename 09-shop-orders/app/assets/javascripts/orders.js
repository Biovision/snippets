'use strict';

var cart = {
    show: function(callback) {
        var url = '/api/cart';

        $.get(url, callback).fail(handle_ajax_failure);
    },
    add_item: function(item_id, quantity, callback) {
        var url = '/api/cart/items';
        var data = { item_id: item_id, quantity: quantity };

        $.post(url, data, callback).fail(handle_ajax_failure);
    },
    remove_item: function(item_id, quantity, callback) {
        var url = '/api/cart/items/' + item_id + '?quantity=' + quantity;

        $.ajax(url, {
            method: 'delete',
            success: callback
        }).fail(handle_ajax_failure);
    },
    update_summary: function(data) {
        var $summary = $('#order-summary');
        var $brief = $('#cart-brief');

        if ($summary[0]) {
            if (data['price'] > 0 || data['items_count'] > 0) {
                $summary.removeClass('hidden');
                $summary.find('.items-count').html(data['texts']['items_count']);
                $summary.find('.price').html(data['price']);
            } else {
                $summary.addClass('hidden');
            }
        }

        if ($brief[0]) {
            $brief.find('.items-count').html(data['texts']['items_count']);
            $brief.find('.price').html(data['price']);
        }
    }
};

$(function () {
    var $order_items = $('#order-items');

    $(document).on('click', '.add-to-cart', function () {
        cart.add_item($(this).data('item-id'), 1, function(response) {
            if (response.hasOwnProperty('data')) {
                cart.update_summary(response['data']);
            }
        });
    });

    function handle_item_delta(item_id, response) {
        item_id = parseInt(item_id);

        if (response.hasOwnProperty('data')) {
            cart.update_summary(response['data']);

            if (response['data'].hasOwnProperty('order_items')) {
                var item_present = false;
                var $container = $order_items.find('[data-item-id=' + item_id + ']');

                $(response['data']['order_items']).each(function() {
                    var order_item = this.order_item;

                    if (order_item.item_id == item_id) {
                        item_present = true;
                        $container.find('.quantity').html(order_item.quantity);
                        $container.find('.total').html(order_item.total_price);
                    }
                });

                if (!item_present) {
                    $container.remove();
                }
            }
        }
    }

    $order_items.find('.increment').on('click', function () {
        var item_id = $(this).closest('li').data('item-id');

        cart.add_item(item_id, 1, function (response) {
            handle_item_delta(item_id, response);
        });
    });

    $order_items.find('.decrement').on('click', function () {
        var item_id = $(this).closest('li').data('item-id');

        cart.remove_item(item_id, 1, function (response) {
            handle_item_delta(item_id, response);
        });
    });

    cart.show(function (response) {
        if (response.hasOwnProperty('data')) {
            cart.update_summary(response['data']);
        }
    });
});
