<vd-autocomplete-well>
    <input type="text" class="form-control" name="autocomplete_text" value={autocomplete_text} />
    <div class="well well-sm" style="height: 150px; overflow: auto;">
        <div each={option in options}><i class="fa fa-minus-circle" onClick={removeItem}></i> {option.name}</div>
    </div>
    <script>
        this.autocomplete_text = ''
        this.options = _.values(this.opts.options)
        removeItem(e) {
            this.options = _.filter(this.options, function(option){
                return e.item.option.id != option.id
            })
            this.opts.evchange({target: {
                name: this.opts.name,
                value: _.map(this.options, function(option) {
                    return option.id;
                })
            }})
            this.update()
        }
        this.on('mount', function(){
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
                    this.autocomplete_text = ''
                    this.options = _.filter(this.options, function(option){
                        return item.value != option.id
                    })
                    this.options.push({id: item.value, name: item.label})
                    this.opts.evchange({target: {
                        name: this.opts.name,
                        value: _.map(this.options, function(option) {
                            return option.id;
                        })
                    }})
                    this.update()
                }.bind(this)
            });
        })
    </script>
</vd-autocomplete-well>
