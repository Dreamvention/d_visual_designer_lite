<vd-setting-block-section_wrapper>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.section_wrapper.entry_row_stretch')}</label>
    <div class="fg-setting">
        <select class="form-select" name="row_stretch" onChange={change}>
            <option each={value, key in store.getOptions('blocks.section_wrapper.stretchs')} value="{key}" selected={key == setting.global.section_wrapper_stretch}>{value}</option>
        </select>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.section_wrapper.entry_background_video')}</label>
    <div class="fg-setting">
        <vd-switcher name="background_video" value="{setting.global.background_video}" evchange={change}/>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.section_wrapper.entry_video_link')}</label>
    <div class="fg-setting">
        <input type="text" class="form-control" name="link" value="{setting.global.link}" onChange={change}/>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.section_wrapper.entry_container')}</label>
    <div class="fg-setting">
        <vd-radio-btn-group name="container" value={setting.global.container} options={store.getOptions('blocks.section_wrapper.containers')} evchange={change}/>
    </div>
</div>
<script>
    this.top = this.parent ? this.parent.top : this
    this.level = this.parent.level
    this.mixin({store:d_visual_designer})
    this.setting = this.opts.block.setting

    this.on('update', function(){
        this.setting = this.opts.block.setting
    })
    change(e){
        this.setting.global[e.target.name] = e.target.value
        this.store.dispatch('block/setting/fastUpdate', {designer_id: this.parent.designer_id, block_id: this.opts.block.id, setting: this.setting})
    }
</script>
</vd-setting-block-section_wrapper>
