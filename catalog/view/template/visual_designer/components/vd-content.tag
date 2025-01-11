<vd-content>
    <vd-layout-main each={block in this.blocks}></vd-layout-main>
<script>
    this.top = this.parent ? this.parent.top : this
    this.mixin({store:d_visual_designer})
    this.blocks = this.store.getBlocks(opts.designer_id, '')

    this.on('update', function(){
        this.blocks = this.store.getBlocks(opts.designer_id, '')
    }.bind(this))

</script>
</vd-content>