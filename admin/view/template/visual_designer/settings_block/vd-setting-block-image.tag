<vd-setting-block-image>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.image.entry_title')}</label>
    <div class="fg-setting">
        <input type="text" name="title" class="form-control" value="{setting.global.title}" onChange={change}>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.image.entry_image')}</label>
    <div class="fg-setting">
        <a href="" id="thumb-vd-image" data-toggle="vd-image" class="vd-img-thumbnail"><img src="{setting.edit.thumb}" alt="" title="" width="100px" height="100px"/></a>
        <input type="hidden" name="image" value="{setting.global.image}" id="input-vd-image"  onChange={change}/>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.image.entry_alt')}</label>
    <div class="fg-setting">
        <input type="text" name="image_alt" class="form-control" value="{setting.global.image_alt}" onChange={change}>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.image.entry_title')}</label>
    <div class="fg-setting">
        <input type="text" name="image_title" class="form-control" value="{setting.global.image_title}" onChange={change}>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.image.entry_size')}</label>
    <div class="fg-setting">
        <select class="form-select" name="size" onChange={change}>
        <option each={value, key in store.getOptions('blocks.image.sizes')} value="{key}" selected={setting.global.size == key}>{value}</option>
        </select>
    </div>
</div>
<div id="size" hide={setting.global.size != 'custom'}>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.image.entry_width')}</label>
        <div class="fg-setting">
            <input type="text" name="width" class="form-control pixels" value="{setting.global.width}" onChange={change}>
        </div>
    </div>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.image.entry_height')}</label>
        <div class="fg-setting">
            <input type="text" name="height" class="form-control pixels" value="{setting.global.height}" onChange={change}>
        </div>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.image.entry_style')}</label>
    <div class="fg-setting">
        <select class="form-select" name="style" onChange={change}>
            <option each={value, key in store.getOptions('blocks.image.styles')} value="{key}" selected={setting.global.style == key} selected="selected">{value}</option>
        </select>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.image.entry_onclick')}</label>
    <div class="fg-setting">
        <select class="form-select" name="onclick" onChange={change}>
            <option each={value, key in store.getOptions('blocks.image.actions')} value="{key}" selected={setting.global.onclick == key} selected="selected">{value}</option>
        </select>
    </div>
</div>
<div id="link" hide={setting.global.onclick != 'link'}>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.image.entry_link')}</label>
        <div class="fg-setting">
            <input type="text" name="link" class="form-control" value="{setting.global.link}" onChange={change}>
        </div>
    </div>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.image.entry_link_target')}</label>
        <div class="fg-setting">
            <select class="form-select" name="link_target" onChange={change}>
                <option value="new" selected={setting.global.link_target == 'new'}>{store.getLocal('blocks.image.text_new_window')}</option>
                <option value="current" selected={setting.global.link_target == 'current'}>{store.getLocal('blocks.image.text_current_window')}</option>
            </select>
        </div>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.image.entry_align')}</label>
    <div class="fg-setting">
        <vd-radio-btn-group name="align" value={setting.global.align} options={store.getOptions('blocks.image.aligns')} evchange={change}/>
    </div>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.image.entry_adaptive_design')}</label>

    <table class="table table-bordered">
        <thead>
            <tr>
                <td>{store.getLocal('blocks.image.column_device')}</td>
                <td>{store.getLocal('blocks.image.column_align')}</td>
                <td>{store.getLocal('blocks.image.column_size')}</td>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>{store.getLocal('blocks.image.text_tablet')}</td>
                <td class="text-center">
                    <select class="form-select" name="align_tablet" onChange={change}>
                        <option value="" selected={setting.global.align_tablet == ''}>{store.getLocal('blocks.image.text_none')}</option>
                        <option each={value, key in store.getOptions('blocks.image.aligns')} value="{key}" selected={setting.global.align_tablet == key} selected="selected">{value}</option>
                    </select>
                </td>
                <td>
                    <select class="form-select" name="size_tablet" onChange={change}>
                        <option value="" selected={setting.global.size_tablet == ''}>{store.getLocal('blocks.image.text_none')}</option>
                        <option each={value, key in store.getOptions('blocks.image.sizes')} value="{key}" selected={setting.global.size_tablet == key} selected="selected">{value}</option>
                    </select>
                    <div id="size_tablet" style="margin:20px 0px 0px 0px !important;" hide={setting.global.size_tablet != 'custom'}>
                        <div class="vd-form-control">
                            <label class="vd-control-label">{store.getLocal('blocks.image.entry_width')}</label>
                            <div class="fg-setting">
                                <input type="text" name="width_tablet" class="form-control pixels" value="{setting.global.width_tablet}" onChange={change}>
                            </div>
                        </div>
                        <div class="vd-form-control">
                            <label class="vd-control-label">{store.getLocal('blocks.image.entry_height')}</label>
                            <div class="fg-setting">
                                <input type="text" name="height_tablet" class="form-control pixels" value="{setting.global.height_tablet}" onChange={change}>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>{store.getLocal('blocks.image.text_phone')}</td>
                <td class="text-center">
                    <select class="form-select" name="align_phone" onChange={change}>
                        <option value="" selected={setting.global.align_phone == ''}>{store.getLocal('blocks.image.text_none')}</option>
                        <option each={value, key in store.getOptions('blocks.image.aligns')} value="{key}" selected={setting.global.align_phone == key} selected="selected">{value}</option>
                    </select>
                </td>
                <td>
                    <select class="form-select" name="size_phone" onChange={change}>
                        <option value="" selected={setting.global.size_phone == ''}>{store.getLocal('blocks.image.text_none')}</option>
                        <option each={value, key in store.getOptions('blocks.image.sizes')} value="{key}" selected={setting.global.size_phone == key} selected="selected">{value}</option>
                    </select>
                    <div id="size_phone" style="margin:0px 0px 20px 0px !important;" hide={setting.global.size_phone != 'custom'}>
                        <div class="vd-form-control">
                            <label class="vd-control-label">{store.getLocal('blocks.image.entry_width')}</label>
                            <div class="fg-setting">
                                <input type="text" name="width_phone" class="form-control pixels" value="{setting.global.width_phone}" onChange={change}>
                            </div>
                        </div>
                        <div class="vd-form-control">
                            <label class="vd-control-label">{store.getLocal('blocks.image.entry_height')}</label>
                            <div class="fg-setting">
                                <input type="text" name="height_phone" class="form-control pixels" value="{setting.global.height_phone}" onChange={change}>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
</div>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.image.entry_parallax')}</label>
    <div class="fg-setting">
        <vd-switcher name="parallax" value="{setting.global.parallax}" evchange={change}/>
    </div>
</div>
<div id="parallax" hide={!setting.global.parallax}>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.image.entry_parallax_height')}</label>
        <div class="fg-setting">
            <input type="text" name="parallax_height" class="form-control pixels" value="{setting.global.parallax_height}" onChange={change}/>
        </div>
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
</vd-setting-block-image>
