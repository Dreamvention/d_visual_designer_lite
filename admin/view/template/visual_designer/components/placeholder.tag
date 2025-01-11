<placeholder class="element-placeholder type-{opts.placeholder_type}">
    <script>
        this.top = this.parent ? this.parent.top : this
        this.mixin({store:d_visual_designer})
        this.on('mount', function(){
            $(this.root).on('mouseup', function(){
                this.store.dispatch('sortable/end', {designer_id: this.top.opts.id, block_id: this.opts.block_id, sort_order: this.opts.sort_order})
            }.bind(this))
        })
    </script>
</placeholder>