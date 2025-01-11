<vd-select-icon-library>
    <select class="form-select" name="{opts.name}" onChange={change}>
        <option each={value, key in store.getOptions('designer.libraries')} value="{key}" selected={key == opts.riotValue}>{value}</option>
    </select>
    <script>
        this.mixin({store:d_visual_designer})
        change(e) {
            if(e.target.value !== this.opts.riotValue) {
                this.opts.evchange(e)
            }
        }
    </script>
</vd-select-icon-library>
