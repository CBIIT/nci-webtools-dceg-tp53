'use strict';
var active_menu;
// var active_submenu;
// var scrollSpy;
$(document).ready(function () {

    // $('.spinner').hide();
    function set_active_menu(menu_id) {
        if (!menu_id) {
            menu_id = 'home_menu';
        }
        $('#' + menu_id).parent().addClass("active");
    }



    // function set_active_submenu(submenu_id) {
    //     if (!submenu_id)
    //         return;
    //     toggle_collapse_jQSel($(".collapsible-sidebar #"+submenu_id+".sub-navitem").parents('.collapse'), false);
    //
    //     $(".sidebar, .collapsible-sidebar").find(".active").removeClass("active");
    //     $('#' + submenu_id).addClass("active");
    //
    // }

    // function set_data_bs_target(enableScrollspy) {
    //     if (enableScrollspy) {
    //         scrollSpy = new bootstrap.ScrollSpy(document.body, {
    //             target: '.sidebar',
    //             offset: 150
    //         });
    //     }
    //     else {
    //         scrollSpy = null;
    //     }
    // }



    set_active_menu(active_menu);
    // set_active_submenu(active_submenu);

    // WCAG 2.4.1: programmatic focus needed because #main-content is not natively focusable
    $('a.skip-to-main').on('click', function () {
        window.setTimeout(function () {
            var el = document.getElementById('main-content');
            if (el) {
                el.focus();
            }
        }, 0);
    });

    // WCAG 1.3.3 / GSA: announce new-tab for all target="_blank" links
    (function enhanceNewTabLinks() {
        var hint = ' (opens in new tab)';
        $('a[target="_blank"]').each(function () {
            var a = this;
            if (a.getAttribute('data-skip-new-tab-a11y') === 'true') {
                return;
            }
            var al = a.getAttribute('aria-label');
            if (al !== null && al !== '') {
                if (al.indexOf('opens in new') < 0 && al.indexOf('new tab') < 0) {
                    a.setAttribute('aria-label', al + hint);
                }
                return;
            }
            var hasManual = false;
            $(a).find('.visually-hidden').each(function () {
                if ((this.textContent || '').indexOf('opens in new') >= 0) {
                    hasManual = true;
                }
            });
            if (!hasManual) {
                $(a).append('<span class="visually-hidden">' + hint + '</span>');
            }
        });
    }());

    // set_data_bs_target(['help', 'resources', 'about'].indexOf(active_menu) >= 0);

    // $(".back-button").click(function () {
    //     window.history.back();
    // });
    if (navigator.userAgent.search("Chrome") < 0 && navigator.userAgent.search("Firefox") < 0 || navigator.userAgent.search("Edge") > 0) {
        $('#browser-alert').show();
    }



    $('.submit-link').on('click', function () {
        $('.spinner').show();
    });

});

$(window).on('pagehide', function(){
    $('.spinner').hide();
});


var toggle_collapse_jQSel = function (selections, triggerHide) {
    $.each(selections, function (index, value) {
        var div_ids = $(value).prop('id');
        var divCollapse = document.getElementById(div_ids);
        new bootstrap.Collapse(divCollapse,
            triggerHide ? {hide: true, show: false} : {hide: false, show: true}
        );
    });
};

// var copy_to_clipboard = function (el) {
//     var $temp = $("<input>");
//     $("body").append($temp);
//     $temp.val($(el).text()).select();
//     document.execCommand("copy");
//     $temp.remove();
// };

// var open_sidebar = function(){
//     $('div.collapsible-sidebar').addClass('hover');
// };
let assign_var = function (val){
        return val;
};

var download_csv = function (filename, table, criteria_map) {
    var input;
    var form = $("<form method='POST' action='/download_dataset'></form>");

    if (criteria_map) {
        $("<input>", { value: JSON.stringify(criteria_map), name: 'criteria_map', type: 'hidden' }).appendTo(form);
    }
    input = $("<input type='hidden' name='filename' value='"+filename+"'/>");
    input.appendTo(form);

    input = $("<input type='hidden' name='query_datatable' value='"+table+"'/>");
    input.appendTo(form);

    form.appendTo($("body"));
    form.submit();
    form.remove();
};

