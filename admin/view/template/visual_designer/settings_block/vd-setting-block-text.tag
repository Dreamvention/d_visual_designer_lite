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
