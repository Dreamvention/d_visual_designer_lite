<placeholder class="element-placeholder type-{opts.placeholder_type}">
    <script>
        this.mixin(new vd_component(this, false))
        this.on('mount', function(){
            $(this.root).on('mouseup', function(){
                this.store.dispatch('sortable/end', {designer_id: this.getState().top.opts.id, block_id: this.opts.block_id, sort_order: this.opts.sort_order})
            }.bind(this))
        })
    </script>
</placeholder>