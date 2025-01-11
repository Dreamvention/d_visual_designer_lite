<vd-switcher>
    <input type="hidden" name="{opts.name}" value="0" />
    <input type="checkbox" name="{opts.name}" class="switcher" data-label-text="{opts.label ? opts.label : store.getLocal('designer.text_enabled')}" checked={opts.riotValue} value="1"/>
    <script>
        this.mixin({store:d_visual_designer})
        this.on('mount', function(){
            $(".switcher[type='checkbox']", this.root).bootstrapSwitch({
                'onColor': 'success',
                'onText': this.store.getLocal('designer.text_yes'),
                'offText': this.store.getLocal('designer.text_no')
            });
            $(".switcher[type='checkbox']", this.root).on('switchChange.bootstrapSwitch', function(e, state) {
                this.opts.evchange({target: {name: e.target.name, value: state}})
            }.bind(this));
        })
    </script>
</vd-switcher>