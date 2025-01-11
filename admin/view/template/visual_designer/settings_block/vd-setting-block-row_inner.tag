<vd-setting-block-row_inner>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.row.entry_background_video')}</label>
        <div class="fg-setting">
            <vd-switcher name="background_video" value="{setting.global.background_video}" evchange={change}/>
        </div>
    </div>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.row.entry_video_link')}</label>
        <div class="fg-setting">
            <input type="text" class="form-control" name="link" value="{setting.global.link}" onChange={change}/>
        </div>
    </div>
    <div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.row_inner.entry_container')}</label>
    <div class="fg-setting">
        <vd-radio-btn-group name="container" value={setting.global.container} options={store.getOptions('blocks.row_inner.containers')} evchange={change}/>
    </div>
</div>
    <div class="vd-form-control" id="align">
        <label class="vd-control-label">{store.getLocal('blocks.row_inner.entry_align')}</label>
        <div class="fg-setting">
            <vd-radio-btn-group name="align" value={setting.global.align} options={store.getOptions('blocks.row_inner.aligns')} evchange={change}/>
        </div>
    </div>
    <div class="vd-form-control" id="align">
        <label class="vd-control-label">{store.getLocal('blocks.row_inner.entry_align_items')}</label>
        <div class="fg-setting">
            <select name="align_items" class="form-select" onChange={change}>
                <option each={value, key in store.getOptions('blocks.row_inner.align_items')} value="{key}" selected={setting.global.align_items == key}>{value}</option>
            </select>
        </div>
    </div>
    <script>
        this.mixin({store:d_visual_designer})
        this.setting = this.opts.block.setting
        this.on('update', function(){
            this.setting = this.opts.block.setting
        })
        change(e){
            this.setting.global[e.target.name] = e.target.value
            this.store.dispatch('block/setting/fastUpdate', {designer_id: this.parent.designer_id, block_id: this.opts.block.id, setting: this.setting})
            this.update()
        }
    </script>
</vd-setting-block-row_inner>
