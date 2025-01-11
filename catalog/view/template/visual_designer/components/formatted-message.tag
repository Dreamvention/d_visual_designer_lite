<formatted-message>
<div></div>
<script>
    this.mixin({store:d_visual_designer})
    this.set = function(){
        this.root.childNodes[0].innerHTML = this.store.getLocal(opts.path);
    }

    this.on('update', this.set)
    this.on('mount', this.set)
</script>
</formatted-message>