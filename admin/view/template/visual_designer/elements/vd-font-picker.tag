<vd-font-picker>
    <select name="{opts.name}" class="form-control"></select>
    <script>
        var y = 0;

        this.on('mount', function(){

            $('select', this.root).select2({
                data: $.fontset,
                placeholder: "Select Font Family",
                triggerChange: true,
                allowClear: true,
                theme: "bootstrap",
                minimumResultsForSearch: Infinity,
                templateResult: function (result) {
                    var state = $('<div style="background-position:-10px -' + y + 'px !important;" class="li_' + result.itemId + '">' + result.text + '</div>');
                    y += 29;
                    return state;
                }
            });
            $('select', this.root).val(this.opts.riotValue).trigger('change');

            $('select', this.root).on("select2:open", function () {
                y = 0;
            });
            $('select', this.root).on("select2:close", function () {
                y = 0;
            });
            var that = this
            $('select', this.root).on('change', function(e) {
                that.opts.evchange(e)
            })
        })
</script>
</vd-font-picker>