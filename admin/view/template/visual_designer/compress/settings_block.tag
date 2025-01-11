<vd-setting-block-column>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.column.entry_size')}</label>
        <div class="fg-setting">
            <select name="size" class="form-select" onChange={change}>
                <option each={value, key in store.getOptions('blocks.column.sizes')} value="{key}" selected={key == setting.global.size}>{value}</option>
            </select>
        </div>
    </div>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.column.entry_offset')}</label>
        <div class="fg-setting">
            <select name="offset" class="form-select" onChange={change}>
                <option value="" selected={setting.global.offset == ''}>{store.getLocal('blocks.column.text_none')}</option>
                <option each={value, key in store.getOptions('blocks.column.sizes')} value="{key}" selected={key == setting.global.offset}>{value}</option>
            </select>
        </div>
    </div>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.column.entry_order')}</label>
        <div class="fg-setting">
            <select name="order" class="form-select" onChange={change}>
                <option value="" selected={setting.global.order == ''}>{store.getLocal('blocks.column.text_none')}</option>
                <option each={value, key in store.getOptions('blocks.column.orders')} value="{key}" selected={key == setting.global.order}>{value}</option>
            </select>
        </div>
    </div>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.column.entry_adaptive_design')}</label>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <td>{store.getLocal('blocks.column.column_device')}</td>
                    <td>{store.getLocal('blocks.column.column_offset')}</td>
                    <td>{store.getLocal('blocks.column.column_order')}</td>
                    <td>{store.getLocal('blocks.column.column_size')}</td>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>{store.getLocal('blocks.column.text_tablet')}</td>
                    <td>
                        <select name="offset_tablet" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.offset_tablet == ''}>{store.getLocal('blocks.column.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column.sizes')} value="{key}" selected={key == setting.global.offset_tablet}>{value}</option>
                        </select>
                    </td>
                    <td>
                        <select name="order_tablet" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.order_tablet == ''}>{store.getLocal('blocks.column.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column.orders')} value="{key}" selected={key == setting.global.order_tablet}>{value}</option>
                        </select>
                    </td>
                    <td>
                        <select name="size_tablet" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.size_tablet == ''}>{store.getLocal('blocks.column.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column.sizes')} value="{key}" selected={key == setting.global.size_tablet}>{value}</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>{store.getLocal('blocks.column.text_phone')}</td>
                    <td>
                        <select name="offset_phone" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.offset_phone == ''}>{store.getLocal('blocks.column.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column.sizes')} value="{key}" selected={key == setting.global.offset_phone}>{value}</option>
                        </select>
                    </td>
                    <td>
                        <select name="order_phone" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.order_phone == ''}>{store.getLocal('blocks.column.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column.orders')} value="{key}" selected={key == setting.global.order_phone}>{value}</option>
                        </select>
                    </td>
                    <td>
                        <select name="size_phone" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.size_phone == ''}>{store.getLocal('blocks.column.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column.sizes')} value="{key}" selected={key == setting.global.size_phone}>{value}</option>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.column.entry_float')}</label>
        <div class="fg-setting">
            <vd-switcher name="float" value="{setting.global.float}" evchange={change}/>
        </div>
    </div>
    <div class="vd-form-control" id="align">
        <label class="vd-control-label">{store.getLocal('blocks.column.entry_align')}</label>
        <div class="fg-setting">
            <vd-radio-btn-group name="align" value={setting.global.align} options={store.getOptions('blocks.column.aligns')} evchange={change}/>
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
</vd-setting-block-column>

<vd-setting-block-column_inner>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.column_inner.entry_size')}</label>
        <div class="fg-setting">
            <select name="size" class="form-select" onChange={change}>
                <option each={value, key in store.getOptions('blocks.column_inner.sizes')} value="{key}" selected={key == setting.global.size}>{value}</option>
            </select>
        </div>
    </div>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.column_inner.entry_offset')}</label>
        <div class="fg-setting">
            <select name="offset" class="form-select" onChange={change}>
                <option value="" selected={setting.global.offset == ''}>{store.getLocal('blocks.column_inner.text_none')}</option>
                <option each={value, key in store.getOptions('blocks.column_inner.sizes')} value="{key}" selected={key == setting.global.offset}>{value}</option>
            </select>
        </div>
    </div>
        <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.column_inner.entry_order')}</label>
        <div class="fg-setting">
            <select name="order" class="form-select" onChange={change}>
                <option value="" selected={setting.global.order == ''}>{store.getLocal('blocks.column_inner.text_none')}</option>
                <option each={value, key in store.getOptions('blocks.column_inner.orders')} value="{key}" selected={key == setting.global.order}>{value}</option>
            </select>
        </div>
    </div>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.column_inner.entry_adaptive_design')}</label>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <td>{store.getLocal('blocks.column_inner.column_device')}</td>
                    <td>{store.getLocal('blocks.column_inner.column_offset')}</td>
                    <td>{store.getLocal('blocks.column.column_order')}</td>
                    <td>{store.getLocal('blocks.column_inner.column_size')}</td>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>{store.getLocal('blocks.column_inner.text_tablet')}</td>
                    <td>
                        <select name="offset_tablet" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.offset_tablet == ''}>{store.getLocal('blocks.column_inner.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column_inner.sizes')} value="{key}" selected={key == setting.global.offset_tablet}>{value}</option>
                        </select>
                    </td>
                    <td>
                        <select name="order_tablet" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.order_tablet == ''}>{store.getLocal('blocks.column_inner.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column_inner.orders')} value="{key}" selected={key == setting.global.order_tablet}>{value}</option>
                        </select>
                    </td>
                    <td>
                        <select name="size_tablet" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.size_tablet == ''}>{store.getLocal('blocks.column_inner.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column_inner.sizes')} value="{key}" selected={key == setting.global.size_tablet}>{value}</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>{store.getLocal('blocks.column_inner.text_phone')}</td>
                    <td>
                        <select name="offset_phone" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.offset_phone == ''}>{store.getLocal('blocks.column_inner.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column_inner.sizes')} value="{key}" selected={key == setting.global.offset_phone}>{value}</option>
                        </select>
                    </td>
                    <td>
                        <select name="order_phone" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.order_phone == ''}>{store.getLocal('blocks.column_inner.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column_inner.orders')} value="{key}" selected={key == setting.global.order_phone}>{value}</option>
                        </select>
                    </td>
                    <td>
                        <select name="size_phone" class="form-select" onChange={change}>
                            <option value="" selected={setting.global.size_phone == ''}>{store.getLocal('blocks.column_inner.text_none')}</option>
                            <option each={value, key in store.getOptions('blocks.column_inner.sizes')} value="{key}" selected={key == setting.global.size_phone}>{value}</option>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="vd-form-control">
        <label class="vd-control-label">{store.getLocal('blocks.column_inner.entry_float')}</label>
        <div class="fg-setting">
            <vd-switcher name="float" value="{setting.global.float}" evchange={change}/>
        </div>
    </div>
    <div class="vd-form-control" id="align">
        <label class="vd-control-label">{store.getLocal('blocks.column_inner.entry_align')}</label>
        <div class="fg-setting">
            <vd-radio-btn-group name="align" value={setting.global.align} options={store.getOptions('blocks.column_inner.aligns')} evchange={change}/>
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
</vd-setting-block-column_inner>

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

<vd-setting-block-row>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.row.entry_row_stretch')}</label>
    <div class="fg-setting">
        <select class="form-select" name="row_stretch" onChange={change}>
            <option each={value, key in store.getOptions('blocks.row.stretchs')} value="{key}" selected={key == setting.global.row_stretch}>{value}</option>
        </select>
    </div>
</div>
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
    <label class="vd-control-label">{store.getLocal('blocks.row.entry_container')}</label>
    <div class="fg-setting">
        <vd-radio-btn-group name="container" value={setting.global.container} options={store.getOptions('blocks.row.containers')} evchange={change}/>
    </div>
</div>
<div class="vd-form-control" id="align">
    <label class="vd-control-label">{store.getLocal('blocks.row.entry_align')}</label>
    <div class="fg-setting">
        <vd-radio-btn-group name="align" value={setting.global.align} options={store.getOptions('blocks.row.aligns')} evchange={change}/>
    </div>
</div>
<div class="vd-form-control" id="align">
    <label class="vd-control-label">{store.getLocal('blocks.row.entry_align_items')}</label>
    <div class="fg-setting">
        <select name="align_items" class="form-select" onChange={change}>
            <option each={value, key in store.getOptions('blocks.row.align_items')} value="{key}" selected={setting.global.align_items == key}>{value}</option>
        </select>
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
</vd-setting-block-row>

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

<vd-setting-block-text>
<div class="vd-form-control">
    <label class="vd-control-label">{store.getLocal('blocks.text.entry_text')}</label>
    <div class="fg-setting">
        <vd-ckeditor language={store.getLocal('blocks.text.ckeditor.language')} name={'text'} value={setting.edit.text} evchange={change}/>
    </div>
</div>
<script>
    this.mixin({store:d_visual_designer})
    this.setting = this.opts.block.setting;

    this.on('update', function(){
        this.setting = this.opts.block.setting;
    })
    change(name, value){
        this.setting.global[name] = value
        this.setting.user[name] = value
        this.store.dispatch('block/setting/fastUpdate', {designer_id: this.parent.designer_id, block_id: this.opts.block.id, setting: this.setting});
        this.update()
    }
</script>
</vd-setting-block-text>

