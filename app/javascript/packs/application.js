// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import '../stylesheets/application'
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("popper.js")
require("bootstrap")
require('daterangepicker')
import moment from 'moment'
// require("widgets/dist/widgets")
// import widgetsGraphiql from 'widgets/dist/widgetsGraphiql'
// import widgetsGraph from 'widgets/dist/widgetsGraph'
console.log('37');

global.$ = $;

global.reportRange = function(selector, from, till, i18n){
    var properties = {
        start: undefined,
        end: undefined,
        i18n: i18n,
        ranges: {}
    };

    if (i18n.locale == 'ru'){
        moment.locale('ru');
    } else if ((i18n.locale == 'zh')){
        moment.locale('zh-cn');
    } else {
        moment.locale('en');
    }

    if (from == '' && till == ''){
        $(selector).find('span').html(i18n.all_time);
    } else {
        properties.start = moment(from);
        properties.end = moment(till);
    }

    function set_reportrange(start, end) {
        $(selector).find('span').html(start.format(i18n.format) + ' - ' + end.format(i18n.format));
    }

    properties.ranges[i18n.today] = [moment(), moment()];
    properties.ranges[i18n.yesterday] = [moment().subtract(1, 'days'), moment().subtract(1, 'days')];
    properties.ranges[i18n.last7] = [moment().subtract(6, 'days'), moment()];
    properties.ranges[i18n.last30] = [moment().subtract(29, 'days'), moment()];
    properties.ranges[i18n.this_month] = [moment().startOf('month'), moment().endOf('month')];
    properties.ranges[i18n.last_month] = [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')];

    $(selector).daterangepicker({
        startDate: properties.start,
        endDate: properties.end,
        opens: 'left',
        alwaysShowCalendars: true,
        locale: {
            cancelLabel: i18n.clear,
            applyLabel: i18n.apply,
            customRangeLabel: i18n.custom_range
        },
        ranges: properties.ranges
    }, set_reportrange);

    $(selector).on('cancel.daterangepicker', function(ev, picker) {
        $(selector).find('span').html(i18n.all_time);
    });

    if (from != '' && till != ''){
        set_reportrange(properties.start, properties.end);
    }

    properties.change = function(cb){

        $(selector).on('apply.daterangepicker', function(ev, picker) {
            var start = picker.startDate.format('YYYY-MM-DDT00:00'),
                end = picker.endDate.format('YYYY-MM-DDT23:59'),
                clear_date = undefined;
            cb(start, end, clear_date);
        });
        $(selector).on('cancel.daterangepicker', function(ev, picker) {
            var start = undefined,
                end = undefined,
                clear_date = 'clear';
            cb(start, end, clear_date);
        });

    };

    return properties
}

global.search = function(){
    let form = $('#search-form');
    let is_find = true;

    form.find('input[name="query"]').keyup(function(){
        if ($(this).val() == '') {
            is_find = false;
            form.find('button').addClass('disabled');
        } else {
            is_find = true;
            form.find('button').removeClass('disabled');
        }
    });

    form.submit(function(){
        return is_find;
    });

    form.find('.search-form-type').click(function(){
        $('<input />').
        attr('type', 'hidden').
        attr('name', 'network').
        attr('value', $(this).data('network')).
        appendTo('#search-form');
        form.submit();
        return false;
    });
}

