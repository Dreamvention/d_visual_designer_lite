<vd-autocomplete>
    <input type="text" class="form-control" name="autocomplete_text" list="list-text" value={autocomplete_text} />
	<datalist id="list-text"></datalist>
    <script>
        this.autocomplete_text = ''
        this.on('mount', function(){
            if(!_.isEmpty(this.opts.riotValue)) {
                $.ajax({
                    url: this.opts.url+'&filter_id=' +  encodeURIComponent(this.opts.riotValue),
                    dataType: 'json',
                    context: this,
                    success: function(json) {
                        if(!_.isUndefined(json[0])){
                            this.autocomplete_text = json[0]['name']
                            this.update()
                        }
                    }
                })
            }
            $('input', this.root).autocomplete({
                'source': function(request, response) {
                    $.ajax({
                        url: this.opts.url+'&filter_name=' +  encodeURIComponent(request),
                        dataType: 'json',
                        success: function(json) {
                            response($.map(json, function(item) {
                                return {
                                    label: item['name'],
                                    value: item['id']
                                }
                            }));
                        }
                    });
                }.bind(this),
                'select': function(item) {
                     this.autocomplete_text = item['label']
                    this.opts.evchange({target: {
                        name: this.opts.name,
                        value: item['value']

                    }})
                }.bind(this)
            });
        })
    </script>
</vd-autocomplete>
