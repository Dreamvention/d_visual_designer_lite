<vd-adaptive-checkbox>
    <label class="vd-checkbox">
        <input type="checkbox" name="{opts.name}" value="show_mobile" checked={_.contains(opts.riotValue, 'show_mobile')} onChange={change}> {store.getLocal('designer.text_phone')}
    </label>
    <br>
    <label class="vd-checkbox">
        <input type="checkbox" name="{opts.name}" value="show_tablet" checked={_.contains(opts.riotValue, 'show_tablet')} onChange={change}> {store.getLocal('designer.text_tablet')}
    </label>
    <br>
    <label class="vd-checkbox">
        <input type="checkbox" name="{opts.name}" value="show_desktop" checked={_.contains(opts.riotValue, 'show_desktop')} onChange={change}> {store.getLocal('designer.text_desktop')}
    </label>
    <script>
        this.mixin({store:d_visual_designer})
        change(e) {
            var values = _.values(this.opts.riotValue)
            if(e.target.checked) {
                values.push(e.target.value)
            } else {
                values = _.filter(values, function(name) {
                    return name != e.target.value
                })
            }
            this.opts.evchange({
                currentTarget: {
                    name: this.opts.name,
                    value: values
                },
                target: {
                    name: this.opts.name,
                    value: values
                },
            })
        }
    </script>
</vd-adaptive-checkbox>