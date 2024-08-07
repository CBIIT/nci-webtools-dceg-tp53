/* view_mouse.js*/
'use strict';

$(document).ready(function () {
    var table = $('#mouse-result-table').DataTable(
        {
            initComplete: function (settings, json) {
                $('.spinner').hide();
            },
            dom: "<'row'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
                // "<'row d-none'<'col-sm-12 col-md-4'B>>" +
                "<'row'<'col-sm-12'tr>>" +
                "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            // buttons: [{
            //     extend: 'csv',
            //     filename: function(){
            //         var db_version;// default version;
            //         $.ajax({
            //             method: "GET",
            //             async: false,
            //             url: "/get_db_version",
            //             success: function (data) {
            //                 db_version = data;
            //             }
            //         });
            //         return 'tp53db_mouse_models'+ (db_version ? '_'+db_version: '');
            //     }
            // }],

            columns: [
                {
                    data: 'model_description'
                },
                {
                    data: 'tumor_sites'
                },
                {
                    data: 'aa_change',
                    render: function (data, type, row, meta) {
                        if (data !== 'NA'){
                            var render_str = '';
                            // var p_list = 'p.'+ (data.split('/').join(', p.'));
                            var p_list = data.split('/');
                            for(var p=0; p< p_list.length; p++){
                                if(p > 0)
                                    render_str += '/'
                                render_str += '<a href="javascript:displayGeneVariations(\'p\',\'p.' + p_list[p] + '\');">' + p_list[p] + '</a>';
                            }
                            return render_str;
                        }
                        else return data;
                    }
                },
                {
                    data: 'camod_id'
                },
                {
                    data: 'pubmed',
                    render: function (data, type, row, meta) {
                        return '<a href="https://www.ncbi.nlm.nih.gov/pubmed/' + data + '" target="_blank" rel="noopener noreferrer">' + data + '</a>';
                    }
                }
            ]
        }
    );

    $('.download-btn').on('click', function () {
        download_csv('tp53db_mouse_models', 'MouseModelView');
    });

});


