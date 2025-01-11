<vd-input-group>
    <div class="wrap-setting-wrapper">
        <div class=wrap-setting>
            <input type="text" name="{params.name}_top" class="form-control pixels-procent" value="{setting.global[params.name+'_top']}" onChange={change}>
            <span class="label-helper">{store.getLocal('designer.text_top')}</span>
        </div>
        <div class="wrap-setting">
            <input type="text" name="{params.name}_right" class="form-control pixels-procent" value="{setting.global[params.name+'_right']}" onChange={change}>
            <span class="label-helper">{store.getLocal('designer.text_right')}</span>
        </div>
        <div class="wrap-setting">
            <input type="text" name="{params.name}_bottom" class="form-control pixels-procent" value="{setting.global[params.name+'_bottom']}" onChange={change}>
            <span class="label-helper">{store.getLocal('designer.text_bottom')}</span>
        </div>
        <div class="wrap-setting">
            <input type="text" name="{params.name}_left" class="form-control pixels-procent" value="{setting.global[params.name+'_left']}" onChange={change}>
            <span class="label-helper">{store.getLocal('designer.text_left')}</span>
        </div>
    </div>
    <script>
        this.mixin({store:d_visual_designer})
        this.params = !_.isUndefined(opts.params)? opts.params : opts

        this.setting = this.store.getState().blocks[this.params.designer_id][this.params.block_id].setting

        change(e) {
            this.setting.global[e.target.name] = e.target.value
            this.store.dispatch('block/setting/fastUpdate', {designer_id: this.params.designer_id, block_id: this.params.block_id, setting: this.setting})
        }.bind(this)

        this.on('update', function () {
            this.params = !_.isUndefined(opts.params)? opts.params : opts

            this.setting = this.store.getState().blocks[this.params.designer_id][this.params.block_id].setting
        })
    </script>
</vd-input-group>