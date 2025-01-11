<vd-layout-block-row>
    <div class="row layout-edit">
        <div each={value in store.getOptions('blocks.row.layout_sizes')} class="col-md-3 col-sm-6 col-xs-12 layout {size == value ? 'active' : ''}" onClick={editLayout}>
            <a id="edit-layout">
                <span each={layout_size in value.split('+')} class="layout-{layout_size}"><span></span></span>
            </a>
        </div>
    </div>
    <div class="setting">
        <div class="form-group">
            <label class="control-label">{store.getLocal('blocks.row.entry_size')}</label>
            <div class="fg-setting">
                <div class="input-group">
                    <input type="text" class="form-control" name="size" value="{size}"/>
                    <span class="input-group-btn">
                        <button id="layoutSet" class="btn btn-default" type="button" onClick={setLayout}>{store.getLocal('blocks.row.text_set_custom')}</button>
                    </span>
                </div>
            </div>
        </div>
    </div>
<script>
    this.level = this.parent.level
    this.mixin({store:d_visual_designer})
    this.setting = this.opts.block.setting

    this.initSize = function(){
        var blocks = this.store.getBlocks(opts.designer_id, this.opts.block.id)
        var size = []
        for(var key in blocks){
            size.push(blocks[key].setting.global.size);
        }
        this.size = size.join('+')
    }
    this.initSize()

    setLayout(e){
        this.size = $('input[name=size]', this.root).val()
        var size = $('input[name=size]', this.root).val().split('+')
        this.store.dispatch('block/layout/setting/update', {size: size})
    }

    editLayout(e){
        this.size = e.item.value
        var size = e.item.value.split('+')
        this.store.dispatch('block/layout/setting/update', {size: size})
    }

    this.on('update', function(){
        this.setting = this.opts.block.setting
    })
</script>
</vd-layout-block-row>