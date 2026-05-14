/* search_gv.js */
'use strict';

$(document).ready(function () {
    var $root = $('#search_tp53_gv');
    var $form = $root.find('form.search-form');
    var $panels = $root.find('#gv_type_collapse .type-collapse');

    function syncTypePanel() {
        var $checked = $root.find('input[name="type_input"]:checked');
        var panelSelector = $checked.data('type-panel');
        var $visible = panelSelector ? $(panelSelector) : $();

        $panels.removeClass('show').attr('aria-hidden', 'true');
        if ($visible.length && $panels.index($visible) !== -1) {
            $visible.addClass('show').attr('aria-hidden', 'false');
        }
    }

    $form.on('change', 'input[name="type_input"]', syncTypePanel);
    $form.on('reset', function () {
        setTimeout(syncTypePanel, 0);
    });

    syncTypePanel();
});
