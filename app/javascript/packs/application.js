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
import vis from 'vis'
import numeral from 'numeral'

global.$ = $;
global.vis = vis;
global.numeral = numeral;

$('document').ready(function(){
    new ClipboardJS('.to-clipboard');
    $('.to-clipboard').tooltip();
    $('.to-clipboard').on('click', function(){
        let it = $(this);
        $('.to-clipboard').attr('data-original-title', 'Copied!').tooltip('show');
        setTimeout(function(){
            $('.to-clipboard').attr('data-original-title', 'Copy');
        }, 200);
    });
});

global.reportRange = function(selector, from, till, i18n){
    var properties = {
        start: undefined,
        end: undefined,
        i18n: i18n,
        ranges: {},
        cbs: []
    };

    this.cancel = false;
    this.click = false;
    let his = this;

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
    properties.ranges[i18n.all_time] = [null, null];
    properties.ranges[i18n.today] = [moment(), moment()];
    properties.ranges[i18n.yesterday] = [moment().subtract(1, 'days'), moment().subtract(1, 'days')];
    properties.ranges[i18n.last7] = [moment().subtract(6, 'days'), moment()];
    properties.ranges[i18n.last30] = [moment().subtract(29, 'days'), moment()];
    properties.ranges[i18n.this_month] = [moment().startOf('month'), moment().endOf('month')];
    properties.ranges[i18n.last_month] = [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')];

    $(selector).daterangepicker({
        showDropdowns: true,
        minYear: 1970,
        maxYear: parseInt(moment().format('YYYY'),10),
        startDate: properties.start,
        endDate: properties.end,
        maxDate: moment(),
        opens: 'left',
        "linkedCalendars": false,
        locale: {
            cancelLabel: i18n.clear,
            applyLabel: i18n.apply,
            customRangeLabel: i18n.custom_range
        },
        ranges: properties.ranges
    }, set_reportrange);

    $(selector).on('cancel.daterangepicker', function(ev, picker) {
        $(selector).find('span').html(i18n.all_time);
        $('.daterangepicker .ranges li').addClass('active');
    });

    $(selector).on('show.daterangepicker', function(ev, picker){
            if($(selector).find('span').html() == i18n.all_time){
                picker.container.find('.ranges li').removeClass('active');
                picker.container.find('.ranges li').first().addClass('active');
            }
    });

    if (from != null && till != null){
        set_reportrange(properties.start, properties.end);
    }

    function changeUrl(from, till){
        $('a[data-changeurl="true"]').each(function(){
            let href = $(this).prop('href').split('?');
            let up = href[1] ? $.urlParams(href[1].split('&')) : {};
            if (from && till){
                up['from'] = from;
                up['till'] = till;
            }else{
                delete up.from;
                delete up.till;
            }
            $(this).prop('href', (href[0] + ($.param(up) ? '?'+$.param(up) : '')));
        });
    }

    $(window).on("popstate",function(e){
        var up = $.urlParams(window.location.search.substr(1).split('&'));
        if (up.from && up.till){
            $(selector).data('daterangepicker').setStartDate(moment(up.from));
            $(selector).data('daterangepicker').setEndDate(moment(up.till));
            set_reportrange(moment(up.from), moment(up.till));
            $.each(properties.cbs, function(){
                this(moment(up.from).format('YYYY-MM-DD'), moment(up.till).format('YYYY-MM-DD'), undefined);
            });
            changeUrl(up.from, up.till);
        } else {
            $(selector).find('span').html(i18n.all_time);
            $.each(properties.cbs, function(){
                this(null, null, 'clear');
                changeUrl(null, null);
            });
        }
    });

    properties.change = function(cb){
        properties.cbs.push(cb);

        $($(selector).data().daterangepicker.container.find('.ranges li')[1]).on('click', function(ev){
            if(his.click == false){
               his.click = true;
               $(this).click();
                his.click = false;
            }
        });
        $(selector).on('apply.daterangepicker', function(ev, picker) {
            if (!picker.startDate._isValid && !picker.endDate._isValid){
                his.cancel = true;
                picker.startDate = moment();
                picker.endDate = moment();
                $(selector).trigger('cancel.daterangepicker', ev, picker);
            } else if (his.cancel === true){
                his.cancel = false;
            } else {
                var start = picker.startDate.format('YYYY-MM-DD'),
                    end = picker.endDate.format('YYYY-MM-DDT23:59:59'),
                    endToParam = picker.endDate.format('YYYY-MM-DD'),
                    clear_date = undefined;
                cb(start, end, clear_date);
                $(selector).find('span').html(picker.startDate.format(i18n.format) + ' - ' + picker.endDate.format(i18n.format));
                let url = location.origin + location.pathname;
                if (location.href != url+'?'+$.param(_.merge($.urlParams, {from: start, till: endToParam}))){
                    history.pushState({data: {}, url: url}, document.title, url+'?'+$.param(_.merge($.urlParams, {from: start, till: endToParam})));
                    changeUrl(start, endToParam);
                }
            }

        });
        $(selector).on('cancel.daterangepicker', function(ev, picker) {
            var start = null,
                end = null,
                clear_date = 'clear';
            cb(start, end, clear_date);
            let url = location.origin + location.pathname;
            let params = $.urlParams;
            delete params.from;
            delete params.till;
            if (location.href != url+($.param(params) ? '?'+$.param(params) : '')) {
                history.pushState({data: {}, url: url}, document.title, url+($.param(params) ? '?'+$.param(params) : ''));
                changeUrl(start, end);
            }
        });

    };

    return properties
};

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
};

(function($) {
    $.urlParams = function(paramsArray = window.location.search.substr(1).split('&')) {
        var params = {};

        for (var i = 0; i < paramsArray.length; ++i)
        {
            var param = paramsArray[i]
                .split('=', 2);

            if (param.length !== 2)
                continue;

            params[param[0]] = decodeURIComponent(param[1].replace(/\+/g, " "));
        }

        return params;
    };
    $.urlParamsToArray = (function(obj){
        var p = [];
        $.each(obj, function(k,v){
            p.push({name: k, value: v})
        });
        return p;
    })($.urlParams);
})($);

function compactDataArray(arr){
    var data = [];
    $.each(arr, function(){
        this.value != '' ? data.push(this) : '';
    });
    return data;
};


global.dateRangeReportFormat = function(from, till, network){
    if (networksLimitedDates(network)){
        return '%Y-%m-%d';
    }else if (from){
        var tillp = till ? Date.parse(till) : Date.now();
        if ((tillp - Date.parse(from) ) / (24*3600*1000) > 100 ){
            return '%Y-%m';
        }else{
            return '%Y-%m-%d';
        }
    }else{
        return '%Y-%m';
    }
};

global.networksLimitedDates = function(network){
    return ['celo_alfajores','celo_baklava','celo_rc1'].indexOf(network)>=0;
};

global.queryWithTimeRange = function(rr, query, from, till, params){

    function draw(start,end){
        var dateFormat = dateRangeReportFormat(start,end, (params && params.network));
        var data = Object.assign({}, params, {
            from: start,
            till: end,
            dateFormat: dateFormat
        });
        query.request(data);
    }

    draw(from,till);
    rr.change(draw);

};

