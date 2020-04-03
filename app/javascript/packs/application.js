// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import '../stylesheets/application'
require.context('cryptocurrency-icons/svg', true);
require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("popper.js")
require("bootstrap")
require('daterangepicker')
import ClipboardJS from 'clipboard'
import moment from 'moment'

global.$ = $;

$('document').ready(function(){
    new ClipboardJS('.to-clipboard');
});

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

    if (from == null && till == null){
        $(selector).find('span').html(i18n.all_time);
    }

    if (from !=null){
        properties.start = moment(from);
    }
    if (till != null){
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

    if (from != null && till != null){
        set_reportrange(properties.start, properties.end);
    }

    properties.change = function(cb){

        $(selector).on('apply.daterangepicker', function(ev, picker) {
            var start = picker.startDate.format('YYYY-MM-DD'),
                end = picker.endDate.format('YYYY-MM-DDT23:59:59'),
                clear_date = undefined;
            cb(start, end, clear_date);
        });
        $(selector).on('cancel.daterangepicker', function(ev, picker) {
            var start = null,
                end = null,
                clear_date = 'clear';
            cb(start, end, clear_date);
        });

    };

    return properties
}

global.search = function(selector){
    let form = $(selector);
    let is_find = true;

    form.find('input[name="query"]').keyup(function(){
        let it = $(this);
        let f = it.parents('form').first();
        // form.find('input').not(this).val($(this).val());
        if (it.val() == '') {
            is_find = false;
            f.find('button').addClass('disabled');
        } else {
            is_find = true;
            f.find('button').removeClass('disabled');
        }
    });

    form.find('input[name="query"]').change(function(){
        $(this).keyup();
    });
    form.find('input[name="query"]').keyup();

    form.submit(function(){
        let it = $(this);
        let net = it.find('input[type="hidden"][name="network"]');
        let btn = it.find('button').first();

        if (!net[0] && btn.data('network')!=''){
            append_network(btn.data('network'));
        }
        return is_find;
    });

    form.find('.search-form-type').click(function(){
        let it = $(this);
        append_network(it.data('network'));
        it.parents('form').first().submit();
        return false;
    });

    function append_network(network){
        $('<input />').
        attr('type', 'hidden').
        attr('name', 'network').
        attr('value', network).
        appendTo(selector);
    };
}


global.dateRangeReportFormat = function(from, till){
    if (from){
        var tillp = till ? Date.parse(till) : Date.now();
        if ((tillp - Date.parse(from) ) / (24*3600*1000) > 100 ){
            return '%m/%Y';
        }else{
            return '%d/%m';
        }
    }else{
        return '%m/%Y';
    }
};

global.dateSortReportFormat = function(dateFormat){
    if(dateFormat.indexOf('%d')>=0){
        return '%Y%m%d';
    }else{
        return '%Y%m';
    }
};

global.queryWithTimeRange = function(rr, query, from, till, params){

    function draw(start,end){
        var dateFormat = dateRangeReportFormat(start,end);
        var data = Object.assign({}, params, {
            from: start,
            till: end,
            dateFormat: dateFormat,
            dateSort: dateSortReportFormat(dateFormat)
        });
        query.request(data);
    }

    draw(from,till);
    rr.change(draw);

};

